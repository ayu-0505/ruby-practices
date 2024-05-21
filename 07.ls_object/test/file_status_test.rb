# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/file_status'

class FileStatusTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixtures/sample_directory/app')

  def setup
    @status = FileStatus.new(TARGET_PATHNAME)
  end

  def test_file_data
    assert @status
  end

  def test_type
    assert_equal 'directory', @status.type
  end

  def test_mode
    assert_equal '40755', @status.mode
  end

  def test_nlink
    assert_equal 14, @status.nlink
  end

  def test_size
    assert_equal 448, @status.size
  end

  def test_blocks
    assert_equal 0, @status.blocks
  end

  def test_mtime
    expected = `date -r #{TARGET_PATHNAME} '+%_m %e %R'`.chomp
    assert_kind_of Time, @status.mtime
    assert_equal expected, @status.mtime.strftime('%_m %e %R') # 対象ファイルの更新日時と同じかどうかの確認のため表示形式は問わない
  end
end
