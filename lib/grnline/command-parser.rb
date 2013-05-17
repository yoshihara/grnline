# -*- coding: utf-8 -*-

require "ostruct"
require "optparse"
require "groonga/command"

module GrnLine
  class CommandParser

    attr_accessor :command

    def initialize
      @command = nil
      @parser = generate_parser
    end

    def <<(raw_input)
      @parser << "#{raw_input}\n"
      @command
    end

    def generate_parser
      parser = Groonga::Command::Parser.new
      parser.on_command do |command|
        @command = command
      end

      parser.on_load_columns do |command, columns|
        @command[:columns] ||= columns.join(",")
      end

      values = []
      parser.on_load_value do |_, value|
        values << value
      end

      parser.on_load_complete do |command|
        @command = command
        @command[:values] ||= Yajl::Encoder.encode(values)
      end

      parser
    end
  end
end
