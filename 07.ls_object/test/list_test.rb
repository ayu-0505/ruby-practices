# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/list'

class ListTest < Minitest::Test
  TARGET_PATHNAME =  Pathname("test/fixtures/sample_directory/*")
  PATHS = Dir.glob(TARGET_PATHNAME)

  def setup
    @list = List.new(PATHS)
  end

  def test_list
    assert @list 
    assert_kind_of FileData, @list.file_datas[0]
  end

  def test_file_name_width
    assert_equal 12, @list.file_name_width
  end

  def test_hard_link_width
    assert_equal 2, @list.hard_link_width
  end

  def test_size_width
    assert_equal 4, @list.size_width
  end

  # ユーザーネームとグループネームのテストは表示テストでまとめて行う
  # def test_uid_name_width
  #   assert_equal 10, @list.uid_name_width
  # end

  # def test_gid_name_width
  #   assert_equal 5, @list.gid_name_width
  # end
  
end
