#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'lib/display'

params = ARGV.getopts('arl')
paths = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
sorted_paths = params['r'] ? paths.reverse : paths
display = Display.new(sorted_paths)
puts display.render(long: params['l'])
