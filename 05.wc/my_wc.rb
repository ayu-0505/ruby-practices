#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
PADDING = 8

def run_wc(options, lists_of_counts)
  lists_of_counts.each { |list_of_counts| output_with_options(list_of_counts, options) }
  output_with_options(total_of_count_texts(lists_of_counts), options) if lists_of_counts.size >= 2
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
      hash[:text_name] = file.to_s
      hash
    end
  end
end

def count_text(text)
  { line_count: text.lines.size, word_count: text.split(' ').size, byte_count: text.bytesize, text_name: nil }
end

def total_of_count_texts(lists_of_counts)
  total_counts_of_line = lists_of_counts.inject(0) { |sum, hash| sum + hash[:line_count] }
  total_counts_of_word = lists_of_counts.inject(0) { |sum, hash| sum + hash[:word_count] }
  total_counts_of_byte = lists_of_counts.inject(0) { |sum, hash| sum + hash[:byte_count] }
  { line_count: total_counts_of_line, word_count: total_counts_of_word, byte_count: total_counts_of_byte, text_name: 'total' }
end

def output_with_options(list_of_counts, options)
  if options.empty?
    print list_of_counts[:line_count].to_s.rjust(adjust_padding(list_of_counts[:line_count]))
    print list_of_counts[:word_count].to_s.rjust(adjust_padding(list_of_counts[:word_count]))
    print list_of_counts[:byte_count].to_s.rjust(adjust_padding(list_of_counts[:byte_count]))
  else
    print list_of_counts[:line_count].to_s.rjust(adjust_padding(list_of_counts[:line_count])) if options[:l]
    print list_of_counts[:word_count].to_s.rjust(adjust_padding(list_of_counts[:word_count])) if options[:w]
    print list_of_counts[:byte_count].to_s.rjust(adjust_padding(list_of_counts[:byte_count])) if options[:c]
  end
  print " #{list_of_counts[:text_name]}"
  puts "\n"
end

def adjust_padding(count)
  if count.to_s.size >= PADDING
    count.to_s.size + 1
  else
    PADDING
  end
end

run_wc(options, lists_of_counts)
