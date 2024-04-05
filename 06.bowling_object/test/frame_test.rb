# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/frame'

class FrameTest < Minitest::Test
  def setup
    @nomal_frame = Frame.new('1', '2')
    @strike_frame = Frame.new('X')
    @spare_frame = Frame.new('1', '9')
    @frame10_has_third_shot = Frame.new('X', 'X', 'X')
  end

  def test_frame
    assert @nomal_frame
  end

  def test_has_shot_class
    assert_kind_of Shot, @nomal_frame.first_shot
  end

  def test_score
    assert_equal 3, @nomal_frame.score
    assert_equal 10, @strike_frame.score
    assert_equal 30, @frame10_has_third_shot.score
  end

  def test_strike?
    assert @strike_frame.strike?
    refute @nomal_frame.strike?
    refute @spare_frame.strike?
  end

  def test_spare?
    assert @spare_frame.spare?
    refute @nomal_frame.spare?
    refute @strike_frame.spare?
  end
end
