# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/shot'

class ShotTest < Minitest::Test
  def test_shot
    assert Shot.new('1')
  end

  def test_mark
    shot = Shot.new('1')
    assert_equal 1, shot.mark
  end

  def test_score
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end
end
