#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'bit_stat'
class FileNotFound < StandardError; end
class DirectoryFound < StandardError; end

raise FileNotFound, 'File not found' unless FileTest.exist?(ARGV[0])
raise DirectoryFound, 'It is a directory. Please, provide a file' if FileTest.exist?(ARGV[0]) && File.directory?(ARGV[0])

stat = BitStat.new(File.open(ARGV[0], 'rb'))
stat.count_bits
puts stat.to_s
