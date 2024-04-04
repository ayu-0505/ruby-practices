# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score # Shotクラスのscoreと混ざるのでframe_scoreに変更するべき？
    [@first_shot, @second_shot, @third_shot].sum(&:score)
  end

  def strike?
    @first_shot.mark == 'X'
  end

  def spare?
    @first_shot.mark != 'X' && @first_shot.score + @second_shot.score == 10
  end
end
