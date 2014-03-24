# -*- coding: utf-8 -*-

require "grnline/wrapper"
require "stringio"
require "tempfile"
require "ostruct"

class TestWrapper < Test::Unit::TestCase
  def setup
    @grnline = GrnLine::Wrapper.new
    @grnline.options = OpenStruct.new
  end

  class RunTest < self
    def setup
      super
      fake_groonga = File.join(File.dirname(__FILE__), "bin",
                                "fake-groonga.rb")
      @stdout = Tempfile.new("output")
      @grnline_arguments = [
        "--groonga", fake_groonga,
        "--output",  @stdout.path
      ]
    end

    private

    def generate_argv(arguments)
      arguments + [GrnLine::OptionsParser::SEPARATOR] + @grnline_arguments
    end

    def stdout_output
      File.read(@stdout)
    end

    public

    def test_not_running
      argv = generate_argv(["not-running"])

      assert_true(@grnline.run(argv))
      assert_equal("not-running\n", stdout_output)
    end

    def test_ready
      argv = generate_argv(["status", "true"])

      assert_true(@grnline.run(argv))
      assert_equal("status\n", stdout_output)
    end

    def test_not_ready
      old_stderr = $stderr.dup
      stderr = StringIO.new
      $stderr = stderr

      argv = generate_argv(["status", "false"])

      assert_false(@grnline.run(argv))
      assert_empty(stdout_output)
      assert_equal("status\n", stderr.string)

      $stderr = old_stderr
    end

    def test_running
      description = "The_quit_commands_exits_running_groonga."
      argv = generate_argv([])
      mock(Readline).readline("> ", true) do
        "quit"
      end
      mock(@grnline).process_command("quit") do
        @stdout.puts(description)
        @stdout.flush
      end

      assert_true(@grnline.run(argv))
      assert_equal("#{description}\n", stdout_output)
    end
  end

  class OutputResponseTest < self
    def setup
      super
      @output = StringIO.new
    end

    def test_prerry_print
      @grnline.options.use_pretty_print = true
      @grnline.options.output = @output

      @grnline.send(:output_response, raw_response)
      assert_equal(pretty_response, @output.string)
    end

    def test_no_prerry_print
      @grnline.options.use_pretty_print = false
      @grnline.options.output = @output

      @grnline.send(:output_response, raw_response)
      assert_equal(raw_response, @output.string)
    end
  end

  def raw_response
    <<-RESPONSE
[[0,1369743525.62977,9.20295715332031e-05],{"alloc_count":129,"starttime":1369743522,"uptime":3,"version":"3.0.1","n_queries":0,"cache_hit_rate":0.0,"command_version":1,"default_command_version":1,"max_command_version":2}]
    RESPONSE
  end

  def pretty_response
    <<-RESPONSE
[
  [0, 1369743525.62977, 9.20295715332031e-05],
  {
    "alloc_count"            :129,
    "starttime"              :1369743522,
    "uptime"                 :3,
    "version"                :"3.0.1",
    "n_queries"              :0,
    "cache_hit_rate"         :0.0,
    "command_version"        :1,
    "default_command_version":1,
    "max_command_version"    :2
  }
]
    RESPONSE
  end
end
