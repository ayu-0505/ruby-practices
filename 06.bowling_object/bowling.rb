#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/game'

raw_scores = ARGV[0].split(',')
result = []
temp = []
frame_num = 1

raw_scores.each do |score|
  if frame_num == 10
    temp << score
    next
  end
  if score == 'X'
    result << [score]
    temp = []
    frame_num += 1
  else
    temp << score
    if temp.size == 2
      result << temp
      temp = []
      frame_num += 1
    end
  end
end
result << temp # frame_numが10の場合のtempを最後に挿入

game = Game.new(result)
puts game.total
