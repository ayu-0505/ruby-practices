#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def run_wc
  has_options = options
  size_info = group_size_info
  output_with_options(size_info, has_options)
end

def options
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse!(ARGV)
  params
end

def group_size_info
  if ARGV.empty?
    textdata = $stdin.read
    Array[count_textdata(textdata)]
  else
    ARGV.map do |file|
      hash = count_textdata(File.read(file))
      hash[:text_name] = " #{file}"
      hash
    end
  end
end

def count_textdata(textdata)
  { lines: textdata.lines.size, number_of_words: textdata.split(' ').size, bytes: textdata.bytesize, text_name: nil }
end

def output_with_options(size_info, has_options)
  output_info = size_info
  output_info << total(output_info) if output_info.size >= 2
  output_info.each do |information|
    unless has_options.empty?
      information.delete(:lines) if !has_options[:l]
      information.delete(:number_of_words) if !has_options[:w]
      information.delete(:bytes) if !has_options[:c]
    end
    information.each_value { |size| print size.to_s.rjust(8) }
    puts "\n"
  end
end

def total(files)
  total_lines = files.inject(0) { |sum, hash| sum + hash[:lines] }
  total_number_of_words = files.inject(0) { |sum, hash| sum + hash[:number_of_words] }
  total_bytes = files.inject(0) { |sum, hash| sum + hash[:bytes] }
  { lines: total_lines, number_of_words: total_number_of_words, bytes: total_bytes, total: 'total  ' }
end

run_wc
