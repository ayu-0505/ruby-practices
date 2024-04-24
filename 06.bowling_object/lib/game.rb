# frozen_string_literal: true

require_relative 'frame'
class Game
  def initialize(score_characters)
    @frames = to_frames(score_characters)
  end

  def total
    @frames.sum(&:score) + strike_bonus + spare_bonus
  end

  private

  def strike_bonus
    bonus_point = 0
    @frames.each_with_index do |frame, i|
      next if !frame.strike? || i > 8

      bonus_point += @frames[i + 1].first_shot.score
      bonus_point += if @frames[i + 1].strike? && i < 8
                       @frames[i + 2].first_shot.score
                     else
                       @frames[i + 1].second_shot.score
                     end
    end
    bonus_point
  end

  def spare_bonus
    bonus_point = 0
    @frames.each_with_index do |frame, i|
      next if !frame.spare? || i > 8

      bonus_point += @frames[i + 1].first_shot.score
    end
    bonus_point
  end

  def to_frames(score_characters)
    result = []
    scores = []
    score_characters.each do |character|
      scores << character
      next if result.size == 9
      next if scores.size != 2 && character != 'X'

      result << Frame.new(scores[0], scores[1])
      scores = []
    end
    result << Frame.new(scores[0], scores[1], scores[2])
    result
  end
end
