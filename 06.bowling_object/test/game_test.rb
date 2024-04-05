# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class GameTest < Minitest::Test
  def test_game
    assert Game.new([%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], ['X'], %w[9 1], %w[8 0], ['X'], %w[6 4 5]])
  end

  def test_has_frames
    game = Game.new([%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], ['X'], %w[9 1], %w[8 0], ['X'], %w[6 4 5]])
    assert_kind_of Frame, game.frame1
  end

  def test_total
    game = Game.new([['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], %w[X X X]])
    game2 = Game.new([%w[6 3], %w[9 0], %w[0 3], %w[8 2], %w[7 3], ['X'], %w[9 1], %w[8 0], ['X'], %w[6 4 5]])
    assert_equal 300, game.total
    assert_equal 114, game2.total
  end

  def test_strike_bonus
    all_strike_game = Game.new([['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], ['X'], %w[X X X]])
    assert_equal 180, all_strike_game.strike_bonus
  end
end
