#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'lib/display'

params = ARGV.getopts('arl')
paths = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
paths.reverse! if params['r']
display = Display.new(paths)
puts params['l'] ? display.render_long_list : display.render_short_list
