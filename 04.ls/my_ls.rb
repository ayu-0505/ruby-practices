#!/usr/bin/env ruby
# frozen_string_literal: true
Column = 3
def line_up_files
  files_with_space = gets_files
  files_number = files_with_space.count
  rows = files_number / Column
  if files_number % Column != 0
    (Column - files_number % Column).times { files_with_space << '' }
    rows += 1
  end
  output(files_with_space, rows)
end

def gets_files
  files = Dir.glob('*')
  filename_max_length = files.map(&:size).max + 7
  files.map do |file|
    file + ' ' * (filename_max_length - file.size)
  end
end

def output(files, rows)
  output_files = []
  files.each_slice(rows) do |file|
    output_files << file
  end

  output_files.transpose.each do |file|
    file.each { |filename| print filename }
    puts "\n"
  end
end

line_up_files
