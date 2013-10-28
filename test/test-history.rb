# -*- coding: utf-8 -*-

require "grnline/history"
require "tempfile"

class TestHistory < Test::Unit::TestCase
  def setup
    @file = Tempfile.new("history")
    @file.print(history)
    @file.close
    @history = GrnLine::History.new(@file.path)
  end

  def teardown
    @file.close!
  end

  def test_load
    @history.load
    history_lines = history.split("\n")
    assert_equal(history_lines, @history.lines)
    assert_equal(history_lines, Readline::HISTORY.to_a)
  end

  def test_store
    @history.store("test_command")

    assert_equal(["test_command"], @history.lines)
  end

  def test_save
    test_store

    @history.save
    expected_history = history + "test_command"

    @file.open do |file|
      assert_equal(expected_history, file.read)
    end
  end

  def history
    <<HISTORY
table_list
table_create SHOW
column_create --table SHOW --name title --type ShortText
select SHOW
HISTORY
  end
end
