#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

case ARGV.first
when "not-running"
  puts("not-running")
  exit(false)

when "status"
  output = ARGV.last
  case output
  when "true"
    puts("status")
    exit(true)
  when "false"
    STDERR.puts("status")
    exit(false)
  end

else
  puts $stdin.gets.chomp
end
