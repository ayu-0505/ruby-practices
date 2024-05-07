# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/file_data'


class FileDateTest < Minitest::Test
  TARGET_PATHNAME =  Pathname("test/fixtures/sample_directory/app")
  # TAEGET_FILE = File.new()
  

  def setup
    @file = FileData.new(TARGET_PATHNAME)
  end

  def test_file_data
    assert @file
  end

  def test_has_filename
    assert_equal 'app', @file.filename
  end

  def test_type
    assert_equal "directory", @file.type
  end

  def test_mode
    assert_equal "40755", @file.mode
  end

  def test_nlink
    assert_equal 14, @file.nlink
  end

  # ユーザーネームとグループネームのテストは表示テストでまとめて行う
  # def test_user_name
  #   assert_equal 'fukuiayumi', @file.user_name
  # end

  # def test_group_name
  #   assert_equal 'staff', @file.group_name
  # end

  def test_size
    assert_equal 448, @file.size
  end

  def test_blocks
    assert_equal 0, @file.blocks
  end

  def test_mtime
    expected = `date -r #{TARGET_PATHNAME} "+%_m %e %R"`.chomp
    assert_kind_of Time, @file.modify_time
    assert_equal expected, @file.modify_time.strftime('%_m %e %R') #対象ファイルの更新日時と同じかどうかの確認のため表示形式は問わない
  end
end
