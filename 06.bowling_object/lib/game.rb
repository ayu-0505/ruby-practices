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
    divided_scores = []
    temp = []
    score_characters.each do |character|
      temp << character
      next if divided_scores.size == 9
      next if temp.size != 2 && character != 'X'

      divided_scores << temp
      temp = []
    end
    divided_scores << temp # divided_scoresの長さが10の場合のtempを最後に挿入

    Array.new(10) do |i|
      if i == 9
        Frame.new(divided_scores[i][0], divided_scores[i][1], divided_scores[i][2])
      else
        Frame.new(divided_scores[i][0], divided_scores[i][1])
      end
    end
  end
end
