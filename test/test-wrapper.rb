# -*- coding: utf-8 -*-

require "grnline/wrapper"
require "stringio"
require "ostruct"

class TestWrapper < Test::Unit::TestCase
  def setup
    @grnline = GrnLine::Wrapper.new
    @grnline.options = OpenStruct.new
    @output = StringIO.new
  end

  class OutputResponseTest < self
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
  [
    0,
    1369743525.62977,
    9.20295715332031e-05
  ],
  {
    "alloc_count": 129,
    "starttime": 1369743522,
    "uptime": 3,
    "version": "3.0.1",
    "n_queries": 0,
    "cache_hit_rate": 0.0,
    "command_version": 1,
    "default_command_version": 1,
    "max_command_version": 2
  }
]
    RESPONSE
  end
end
