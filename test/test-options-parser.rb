# -*- coding: utf-8 -*-

require "grnline/options-parser"

class OptionsParserTest < Test::Unit::TestCase
  def setup
    @parser = GrnLine::OptionsParser.new
    @separator = [GrnLine::OptionsParser::SEPARATOR]
  end

  def test_separator_in_both_arguments
    groonga_arguments = ["-n", "db/db"]
    argv =  groonga_arguments + @separator + ["--output", "output_path"]
    options = @parser.parse(argv)

    assert_options(options,
                   :output => "output_path",
                   :groonga_arguments => groonga_arguments)
  end

  def test_separator_with_grnline_arguments_only
    argv = @separator + ["--output", "output_path"]
    options = @parser.parse(argv)

    assert_options(options, :output => "output_path")
  end

  def test_separator_with_groonga_arguments_only
    argv = ["-n", "db/db"]
    options = @parser.parse(argv)
    assert_options(options, :groonga_arguments => argv)
  end

  def test_no_arguments
    argv = []
    options = @parser.parse(argv)
    assert_options(options, {})
  end

  private

  def assert_options(options, expected_options)
    output = expected_options[:output] || $stdout
    groonga_arguments = expected_options[:groonga_arguments] || []

    assert_equal(output, options.output)
    assert_equal(groonga_arguments, options.groonga_arguments)
  end
end
