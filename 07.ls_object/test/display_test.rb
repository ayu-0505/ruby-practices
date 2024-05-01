# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/display'

class DisplayTest < Minitest::Test
  TARGET_PATHNAME =  Pathname("test/fixtures/sample_directory/*")
  PATHS = Dir.glob(TARGET_PATHNAME)

  def setup
    @display = Display.new(PATHS)
  end

  def test_render_short_list
    expected = <<~TEXT.chomp
      Gemfile            config             storage
      Gemfile.lock       config.ru          test
      README.md          db                 tmp
      Rakefile           lib                vendor
      app                log
      bin                public
    TEXT

    assert_equal expected, @display.render_short_list
  end
end
