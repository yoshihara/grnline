# -*- coding: utf-8 -*-

require "ostruct"
require "optparse"
require "groonga/command"

module GrnLine
  class CommandParser
    def initialize
      @command = nil
      @parser = generate_parser
    end

    def parse(raw_input)
      @parser << "#{raw_input}\n"
      @command
    end

    def generate_parser
      parser = Groonga::Command::Parser.new
      parser.on_command do |command|
        @command = command
      end

      parser.on_load_complete do |command|
        @command = command
      end

      parser
    end
  end
end
