# -*- coding: utf-8 -*-

require "grnline/version"

module GrnLine
  class OptionsParser
    def initialize
      @options = OpenStruct.new
      @options.groonga = "groonga"
      @options.pager = "less"
      @options.groonga_arguments = []
    end

    def parse(argv)
      parser = generate_parser
      separator_index = argv.index("--")
      if separator_index
        @options.groonga_arguments = argv[0..(separator_index - 1)]
        parser.parse!(argv[(separator_index + 1)..-1])
      else
        @options.groonga_arguments = argv
      end
      @options
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
