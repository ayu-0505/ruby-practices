# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/file_data'


class FileDateTest < Minitest::Test
  TARGET_PATHNAME =  Pathname("test/fixtures/sample_directory/app")
  # TAEGET_FILE = File.new()
  

  def setup
    @file = FileData.new('app', TARGET_PATHNAME)
  end

  def test_file_data
    assert @file
  end

  def test_has_file_name
    assert_equal 'app', @file.filename
  end

  def test_filename_length
    assert_equal 3, @file.filename_length 
  end

  def test_type
    assert_equal "directory", @file.type
  end

  def test_permission_mode
    assert_equal "40755", @file.permission_mode
  end

  def test_hard_link
    assert_equal 14, @file.hard_link
  end

  def test_user_id
    assert_equal 501, @file.user_id
  end

  def test_group_id
    assert_equal 20, @file.group_id
  end

  def test_file_size
    assert_equal 448, @file.size
  end

  def test_modify_time
    expected = `date -r #{TARGET_PATHNAME} "+%_m %e %R"`.chomp
    assert_kind_of Time, @file.modify_time
    assert_equal expected, @file.modify_time.strftime('%_m %e %R')
  end
end
