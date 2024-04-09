#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/game'

input_scores = ARGV[0].split(',')
devided_scores = []
temp = []
frame_count = 1

input_scores.each do |score|
  if frame_count == 10
    temp << score
    next
  end
  if score == 'X'
    devided_scores << [score]
    temp = []
    frame_count += 1
  else
    temp << score
    if temp.size == 2
      devided_scores << temp
      temp = []
      frame_count += 1
    end
  end
end
devided_scores << temp # frame_countが10の場合のtempを最後に挿入

game = Game.new(devided_scores)
puts game.total
