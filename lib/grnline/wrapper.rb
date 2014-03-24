# -*- coding: utf-8 -*-

require "readline"
require "lazy-pp-json"
require "open3"
require "grnline/options-parser"
require "grnline/history"

module GrnLine
  class Wrapper
    attr_accessor :options

    GROONGA_COMMANDS = [
      "cache_limit", "check", "clearlock", "column_create", "column_list",
      "column_remove", "column_rename", "define_selector", "defrag",
      "delete", "dump", "load", "log_level", "log_put", "log_reopen",
      "normalize", "quit", "register", "select", "shutdown", "status",
      "table_create", "table_list", "table_remove", "table_rename",
      "tokenize", "truncate"
    ]

    GROONGA_VARIABLES = [
      "--cache", "--columns", "--default_tokenizer", "--drilldown",
      "--drilldown_limit", "--drilldown_offset",
      "--drilldown_output_columns", "--drilldown_sortby", "--each",
      "--filter", "--flags", "--id", "--ifexists", "--input_type",
      "--key", "--key_type", "--level", "--limit", "--match_columns",
      "--match_escalation_threshold", "--max", "--message", "--name",
      "--new_name", "--normalizer", "--obj", "--offset",
      "--output_columns", "--path", "--query", "--query_expander",
      "--query_expansion", "--query_flags", "--scorer", "--seed",
      "--sortby", "--source", "--string", "--table", "--tables",
      "--target_name", "--threshold", "--tokenizer", "--type",
      "--value_type", "--values"
    ]

    GROONGA_FUNCTIONS = [
      "all_records", "edit_distance", "geo_distance", "geo_distance2",
      "geo_distance3", "geo_in_circle", "geo_in_rectangle", "max",
      "min", "now", "query", "rand", "snippet_html", "sub_filter"
    ]

    GROONGA_SHUTDOWN_COMMANDS = ["quit", "shutdown"]

    HISTORY_FILE = File.join(ENV["HOME"], ".grnline-history")

    class << self
      def run(argv)
        new.run(argv)
      end
    end

    def initialize
      @options = nil
      @history = GrnLine::History.new(HISTORY_FILE)
      @commandline_prefix = ""
      setup_input_completion
    end

    def run(argv)
      @options = parse_commandline_options(argv)
      groonga_commandline = generate_groonga_commandline

      Open3.popen3(*groonga_commandline) do |input, output, error, _|
        @input, @output, @error = input, output, error

        return true unless ensure_groonga_running
        return false unless ensure_groonga_ready

        setup_interrupt_shutdown

        command = nil
        @history.load

        while(command = Readline.readline("#{@commandline_prefix}> ", true)) do
          @history.store(Readline::HISTORY.to_a.last)
          process_command(command)
          break if GROONGA_SHUTDOWN_COMMANDS.include?(command)
        end

        shutdown_groonga unless GROONGA_SHUTDOWN_COMMANDS.include?(command)
        @history.save
        true
      end
    end

    private

    def parse_commandline_options(argv)
      options_parser = GrnLine::OptionsParser.new
      options_parser.parse(argv)
    end

    def generate_groonga_commandline
      [@options.groonga, *@options.groonga_arguments]
    end

    def process_command(command)
      raw_response = nil
      begin
        raw_response = read_groonga_response(command)
      rescue => e
        raise("Failed to access the groonga database: #{e.message}")
      end

      if raw_response and not raw_response.empty?
        # TODO: support pretty print for formats except JSON
        @commandline_prefix = ""
        output_response(raw_response)
      else
        @commandline_prefix = "*"
      end
    end

    def read_groonga_response(command)
      return nil if command.empty?
      response = ""

      @input.puts(command)
      @input.flush

      timeout = 1
      while IO.select([@output], [], [], timeout)
        break if @output.eof?
        read_content = @output.readpartial(1024)
        response << read_content
        timeout = 0 if read_content.bytesize < 1024
      end

      response
    end

    def output_response(raw_response)
      # TODO: support pretty print for formats except JSON
      response = raw_response
      if @options.use_pretty_print
        begin
          response = Lazy::PP::JSON.new(response)
        rescue
        end
      end

      output(response)
    end

    def output(object)
      output = nil
      if @options.output.instance_of?(String)
        output = File.open(@options.output, "w")
      else
        output = @options.output
      end

      if object.instance_of?(Lazy::PP::JSON)
        PP.pp(object, output)
      else
        output.puts(object)
      end

      output.close if output.instance_of?(File)
    end

    def execute(command)
      @input.puts(command)
      @input.flush
      @output.gets
    end

    def shutdown_groonga
      execute("shutdown")
      @input.close
    end

    def setup_interrupt_shutdown
      trap("INT") do
        shutdown_groonga
        @history.save
        exit(true)
      end
    end

    def setup_input_completion
      Readline.completion_proc = lambda do |word|
        completions = (GROONGA_COMMANDS + GROONGA_VARIABLES + GROONGA_FUNCTIONS)
        completions.grep(/\A#{Regexp.escape(word)}/)
      end
    end

    def ensure_groonga_running
      if IO.select([@output], nil, nil, 1) and not @output.eof?
        output(@output.read)
        return false
      end
      return true
    end

    def ensure_groonga_ready
      begin
        execute("status")
      rescue
        if IO.select([@error], [], [], 0)
          $stderr.puts(@error.read)
          return false
        end
      end
      return true
    end
  end
end
