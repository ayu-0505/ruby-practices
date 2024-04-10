# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class GameTest < Minitest::Test
  def setup
    @nomal_game = Game.new(%w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X 6 4 5])
    @all_strike_game = Game.new(%w[X X X X X X X X X X X X])
  end

  def test_game
    assert @nomal_game
  end

  def test_total
    assert_equal 139, @nomal_game.total
    assert_equal 300, @all_strike_game.total
  end

  def test_strike_bonus
    assert_equal (9 + 1) + (6 + 4), @nomal_game.strike_bonus
    assert_equal (10 + 10) * 9, @all_strike_game.strike_bonus
  end

  def test_spare_bonus
    assert_equal 7 + 10 + 8, @nomal_game.spare_bonus
  end
end
