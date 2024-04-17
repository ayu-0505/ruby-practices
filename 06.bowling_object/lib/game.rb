# frozen_string_literal: true

require_relative 'frame'
class Game
  def initialize(standard_input_scores)
    scores = divide_scores_for_frames(standard_input_scores)
    @frames = Array.new(10) do |i|
      if i == 9
        Frame.new(scores[i][0], scores[i][1], scores[i][2])
      else
        Frame.new(scores[i][0], scores[i][1])
      end
    end
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

  def divide_scores_for_frames(scores)
    divided_scores = []
    temp = []
    frame_count = 1
    scores.each do |score|
      temp << score
      next if frame_count == 10
      next if temp.size != 2 && score != 'X'

      divided_scores << temp
      temp = []
      frame_count += 1
    end
    divided_scores << temp # frame_countが10の場合のtempを最後に挿入
  end
end
