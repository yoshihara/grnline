# -*- coding: utf-8 -*-

require "readline"
require "json"
require "open3"
require "grnline/options-parser"

module GrnLine
  class Wrapper
    GROONGA_COMMANDS = [
      "cache_limit", "check", "clearlock", "column_create", "column_list",
      "column_remove", "column_rename", "define_selector", "defrag",
      "delete", "dump", "load", "log_level", "log_put", "log_reopen",
      "quit", "register", "select", "shutdown", "status", "table_create",
      "table_list", "table_remove", "table_rename", "truncate"
    ]
    GROONGA_SHUTDOWN_COMMANDS = ["quit", "shutdown"]

    class << self
      def run(argv)
        new.run(argv)
      end
    end

    def initialize
      @options_parser = GrnLine::OptionsParser.new

      setup_input_completion
    end

    def run(argv)
      options = @options_parser.parse(argv)
      groonga_commandline = options.groonga_arguments.unshift(options.groonga)

      Open3.popen3(*groonga_commandline) do |input, output, error, _|
        @input, @output, @error = input, output, error

        ensure_groonga_running
        setup_interrupt_shutdown

        while(buffer = Readline.readline("groonga> ", true)) do
          process_command(buffer)
        end

        shutdown_groonga
      end
    end

    private

    def process_command(command)
      return nil if command.empty?

      raw_response = ""
      count = 0
      begin
        @input.puts(command)
        @input.flush

        timeout = 1
        while IO.select([@output], [], [], 1)
          break if @output.eof?
          read_content = @output.readpartial(1024)
          raw_response << read_content
          timeout = 0 if read_content.bytesize < 1024
        end

      rescue => e
        raise("Failed to access the groonga database: #{e.message}")
      end

      if raw_response.empty? and IO.select([@error], [], [], 0)
        $stderr.puts(@error.read)
      else
        # TODO: support pretty print for formats except JSON
        output_response(raw_response, :json)
        exit(true) if GROONGA_SHUTDOWN_COMMANDS.include?(command)
      end
    end

    def output_response(raw_response, response_type)
      # TODO: support pretty print for formats except JSON
      case response_type
      when :json
        response = JSON.parse(raw_response)
        puts(JSON.pretty_generate(response))
      else
        puts(raw_response)
      end
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
        exit(true)
      end
    end

    def setup_input_completion
      Readline.completion_proc = lambda do |word|
        GROONGA_COMMANDS.grep(/\A#{Regexp.escape(word)}/)
      end
    end

    def ensure_groonga_running
      if IO.select([@output], nil, nil, 0.1) and not @output.eof?
        puts(@output.read)
        exit(true)
      end

      begin
        execute("status")
      rescue Errno::EPIPE
        $stderr.puts(@error.gets)
        exit(false)
      ensure
        if @output.closed?
          $stderr.puts(@error.gets)
          exit(false)
        end
      end
    end

    def format(command)
      if command.original_source.start_with?("/d/")
        command.to_uri_format
      else
        command.to_command_format
      end
    end
  end
end
