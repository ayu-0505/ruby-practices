#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/game'

game = Game.new(ARGV[0].split(','))
puts game.total
