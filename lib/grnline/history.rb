# -*- coding: utf-8 -*-

module GrnLine
  class History
    attr_reader :lines

    def initialize(file)
      @history_file = file
      @lines = []
    end

    def load
      @lines = read
      Readline::HISTORY.push(*@lines)
    end

    def save
      saved_history = read
      return if saved_history == @lines

      new_history = (@lines + saved_history).uniq

      File.open(@history_file, "w") do |file|
        file.print(new_history.join("\n"))
      end
    end

    def store(line)
      @lines << line
    end

    private

    def read
      return [] unless File.exist?(@history_file)
      File.readlines(@history_file).collect {|line| line.chomp}
    end
  end
end
