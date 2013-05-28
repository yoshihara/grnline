# -*- coding: utf-8 -*-

require "grnline/version"
require "ostruct"
require "optparse"

module GrnLine
  class OptionsParser

    SEPARATOR = "--"

    def initialize
      @options = OpenStruct.new
      @options.groonga = "groonga"
      @options.pager = "less"
      @options.groonga_arguments = []
      @options.output = $stdout
    end

    def parse(argv)
      parser = generate_parser

      if not argv.include?(SEPARATOR)
        @options.groonga_arguments = argv
      else
        grnline_arguments, groonga_arguments = split_arguments(argv)

        parser.parse!(grnline_arguments)
        @options.groonga_arguments = groonga_arguments
      end
      @options
    end

    def split_arguments(argv)
      grnline_arguments = []
      groonga_arguments = []
      separator_index = argv.index(SEPARATOR)

      unless separator_index.zero?
        groonga_arguments = argv[0 .. (separator_index - 1)]
      end
      grnline_arguments = argv[(separator_index + 1) .. -1]

      [grnline_arguments, groonga_arguments]
    end

    def generate_parser
      parser = OptionParser.new
      banner = "Usage: #{$0} [groonga_options] -- [grnline_options]\n" +
                 "      'groonga_options' is options for groonga. " +
                 "Please type `groonga --help` for the details of them.\n" +
                 " grnline_options :"
      parser.banner = banner

      parser.on("-g", "--groonga=GROONGA", "your groonga.") do |groonga|
        @options.groonga = groonga
      end

      # TODO: supports pager for displaying results from groonga
      # parser.on("-p", "--pager=PAGER",
      #           "your pager using to display results.") do |pager|
      #   @options.pager = pager
      # end

      parser.on("--output=OUTPUT", "Output responses from groonga.") do |output|
        @options.output = output
      end

      parser.on("-v", "--version", "Show version and exit.") do
        puts(GrnLine::VERSION)
        exit(true)
      end

      parser.on_tail("-h", "--help", "Show this message and exit.") do
        puts(parser.help)
        exit(true)
      end

      parser
    end
  end
end
