# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/file_data'


class FileDateTest < Minitest::Test
  TARGET_PATHNAME =  Pathname("test/fixtures/sample_directory/app")

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
end
