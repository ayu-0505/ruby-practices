# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/frame'

class FrameTest < Minitest::Test
  def test_frame
    assert Frame.new('1', '2')
  end

  def test_have_shot_class
    frame = Frame.new('1', '2')
    assert_kind_of Shot, frame.first_shot
  end

  def test_score
    frame = Frame.new('1', '2')
    assert_equal 3, frame.score
  end

  def test_strike?
    strike_frame = Frame.new('X')
    not_strike_frame = Frame.new('1', '2')

    assert strike_frame.strike?
    refute not_strike_frame.strike?
  end
end
