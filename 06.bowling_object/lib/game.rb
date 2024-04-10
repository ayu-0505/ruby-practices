# frozen_string_literal: true

require_relative 'frame'
class Game
  def initialize(raw_data)
    scores = devide_scores(raw_data)
    @frames = [@frame1 = Frame.new(scores[0][0], scores[0][1]),
               @frame2 = Frame.new(scores[1][0], scores[1][1]),
               @frame3 = Frame.new(scores[2][0], scores[2][1]),
               @frame4 = Frame.new(scores[3][0], scores[3][1]),
               @frame5 = Frame.new(scores[4][0], scores[4][1]),
               @frame6 = Frame.new(scores[5][0], scores[5][1]),
               @frame7 = Frame.new(scores[6][0], scores[6][1]),
               @frame8 = Frame.new(scores[7][0], scores[7][1]),
               @frame9 = Frame.new(scores[8][0], scores[8][1]),
               @frame10 = Frame.new(scores[9][0], scores[9][1], scores[9][2])]
  end

  def total
    @frames.sum(&:score) + strike_bonus + spare_bonus
  end

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

  def devide_scores(input_scores)
    devided_scores = []
    temp = []
    frame_count = 1
    input_scores.each do |score|
      temp << score
      next if frame_count == 10
      next if temp.size != 2 && score != 'X'

      devided_scores << temp
      temp = []
      frame_count += 1
    end
    devided_scores << temp # frame_countが10の場合のtempを最後に挿入
  end
end
