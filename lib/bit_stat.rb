# frozen_string_literal: true

class BitStat

  attr_reader :file, :number_of_zeros, :number_of_ones

  def initialize(file)
    raise 'A file is not provided' unless file
    raise 'It is not a file' unless file.instance_of?(File)

    @file = file
    @number_of_zeros = 0
    @number_of_ones = 0
  end

  def count_bits
    file.each do |line|
      continue if line.empty?
      array = line.unpack('B*')
      binary_content = array[0]
      increase_zeroes_count_by(binary_content.count('0'))
      increase_ones_count_by(binary_content.count('1'))
    end
  end

  def to_s
    "found #{@number_of_ones} bits set to 1 \nfound #{@number_of_zeros} bits set to 0"
  end

  private

  def increase_zeroes_count_by(quantity)
    @number_of_zeros += quantity
  end

  def increase_ones_count_by(quantity)
    @number_of_ones += quantity
  end

end
