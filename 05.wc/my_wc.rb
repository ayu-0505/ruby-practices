#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def run_wc
  output_with_options(options, lists_of_counts)
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

def lists_of_counts
  if ARGV.empty?
    standard_input = $stdin.read
    Array[count_text(standard_input)]
  else
    ARGV.map do |file|
      hash = count_text(File.read(file))
      hash[:text_name] = "#{file}"
      hash
    end
  end
end

def count_text(text)
  { line_count: text.lines.size, word_count: text.split(' ').size, byte_count: text.bytesize, text_name: nil }
end

def output_with_options(options, lists_of_counts)
  lists_of_counts_for_output = Marshal.load(Marshal.dump(lists_of_counts))
  lists_of_counts_for_output << total(lists_of_counts_for_output) if lists_of_counts_for_output.size >= 2
  lists_of_counts_for_output.each do |list_of_counts|
    unless options.empty?
      list_of_counts.delete(:line_count) if !options[:l]
      list_of_counts.delete(:word_count) if !options[:w]
      list_of_counts.delete(:byte_count) if !options[:c]
    end
    list_of_counts.each_value { |size| print size.to_s.rjust(8) }
    puts "\n"
  end
end

def total(lists_of_counts)
  total_counts_of_line = lists_of_counts.inject(0) { |sum, hash| sum + hash[:line_count] }
  total_counts_of_word = lists_of_counts.inject(0) { |sum, hash| sum + hash[:word_count] }
  total_counts_of_byte = lists_of_counts.inject(0) { |sum, hash| sum + hash[:byte_count] }
  { line_count: total_counts_of_line, word_count: total_counts_of_word, byte_count: total_counts_of_byte, total: 'total  ' }
end

run_wc
