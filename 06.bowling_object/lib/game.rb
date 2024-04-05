# frozen_string_literal: true

require_relative 'frame'
class Game
  attr_reader :frame1, :frame2, :frame3, :frame4, :frame5, :frame6, :frame7, :frame8, :frame9, :frame10

  def initialize(result)
    @frame1 = Frame.new(result[0][0], result[0][1])
    @frame2 = Frame.new(result[1][0], result[1][1])
    @frame3 = Frame.new(result[2][0], result[2][1])
    @frame4 = Frame.new(result[3][0], result[3][1])
    @frame5 = Frame.new(result[4][0], result[4][1])
    @frame6 = Frame.new(result[5][0], result[5][1])
    @frame7 = Frame.new(result[6][0], result[6][1])
    @frame8 = Frame.new(result[7][0], result[7][1])
    @frame9 = Frame.new(result[8][0], result[8][1])
    @frame10 = Frame.new(result[9][0], result[9][1], result[9][2])

    @frames = [@frame1,
               @frame2,
               @frame3,
               @frame4,
               @frame5,
               @frame6,
               @frame7,
               @frame8,
               @frame9,
               @frame10]
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
end
