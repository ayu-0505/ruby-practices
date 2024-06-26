# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/display'

class DisplayTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixtures/sample_directory/*')

  def test_render
    paths = Dir.glob(TARGET_PATHNAME)
    display = Display.new(paths)
    expected = <<~TEXT.chomp
      Gemfile            config             storage
      Gemfile.lock       config.ru          test
      README.md          db                 tmp
      Rakefile           lib                vendor
      app                log
      bin                public
    TEXT

    assert_equal expected, display.render
  end

  def test_render_at_reverse
    paths = Dir.glob(TARGET_PATHNAME).reverse
    display = Display.new(paths)
    expected = <<~TEXT.chomp
      vendor             lib                Rakefile
      tmp                db                 README.md
      test               config.ru          Gemfile.lock
      storage            config             Gemfile
      public             bin
      log                app
    TEXT

    assert_equal expected, display.render
  end

  def test_render_with_dotfiles
    paths = Dir.glob(TARGET_PATHNAME, File::FNM_DOTMATCH)
    display = Display.new(paths)
    expected = <<~TEXT.chomp
      .                   app                 public
      .ruby-lsp           bin                 storage
      .ruby-version       config              test
      Gemfile             config.ru           tmp
      Gemfile.lock        db                  vendor
      README.md           lib
      Rakefile            log
    TEXT

    assert_equal expected, display.render
  end

  def test_render_long_list
    paths = Dir.glob(TARGET_PATHNAME)
    display = Display.new(paths)

    expected = <<~TEXT.chomp
      total 48
      _rw-r--r--   1 fukuiayumi  staff  2327  5 17 15:43 Gemfile
      _rw-r--r--   1 fukuiayumi  staff  6121  4 25 09:43 Gemfile.lock
      _rw-r--r--   1 fukuiayumi  staff   374  4 25 09:43 README.md
      _rw-r--r--   1 fukuiayumi  staff   258  5 17 15:43 Rakefile
      drwxr-xr-x  14 fukuiayumi  staff   448  4 25 09:43 app
      drwxr-xr-x   7 fukuiayumi  staff   224  4 25 09:43 bin
      drwxr-xr-x  16 fukuiayumi  staff   512  4 25 09:43 config
      _rw-r--r--   1 fukuiayumi  staff   191  5 17 15:43 config.ru
      drwxr-xr-x   6 fukuiayumi  staff   192  4 25 09:43 db
      drwxr-xr-x   4 fukuiayumi  staff   128  4 25 09:43 lib
      drwxr-xr-x   4 fukuiayumi  staff   128  4 25 09:43 log
      drwxr-xr-x   9 fukuiayumi  staff   288  4 25 09:43 public
      drwxr-xr-x  20 fukuiayumi  staff   640  4 25 09:43 storage
      drwxr-xr-x  12 fukuiayumi  staff   384  4 25 09:43 test
      drwxr-xr-x   9 fukuiayumi  staff   288  4 25 09:43 tmp
      drwxr-xr-x   4 fukuiayumi  staff   128  4 25 09:43 vendor
    TEXT

    assert_equal expected, display.render(long: true)
  end
end
