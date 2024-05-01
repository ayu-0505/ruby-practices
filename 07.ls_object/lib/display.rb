# frozen_string_literal: true
require_relative 'list'

class Display
  COLUMN_NUMBER = 3
  SHORT_LIST_PADDING = 7
  MODE_TABLE = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze


  def initialize(paths)
    @list = List.new(paths)
  end

  def render_short_list
    file_width = @list.file_name_width + SHORT_LIST_PADDING
    files_with_spaces = file_name_list.map { |file| file.ljust(file_width) }
    files_number = @list.count_file_datas
    row_number = (files_number / COLUMN_NUMBER.to_f).ceil
    (COLUMN_NUMBER - files_number % COLUMN_NUMBER).times { files_with_spaces << '' } if files_number % COLUMN_NUMBER != 0
    render_lines = []
    files_with_spaces.each_slice(row_number) { |file| render_lines << file }
    render_lines = render_lines.transpose.map {|line| line.join.rstrip }.join("\n")
    render_lines
  end

  private

  # def output(output_files)
  #   output_files.each do |file|
  #     file.each { |filename| print filename }
  #     puts "\n"
  #   end
  # end

  def file_name_list
    @list.file_datas.map(&:filename)
  end
end
