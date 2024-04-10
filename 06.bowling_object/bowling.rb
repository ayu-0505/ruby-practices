#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/game'

input_scores = ARGV[0].split(',')
p input_scores
game = Game.new(input_scores)
puts game.total
