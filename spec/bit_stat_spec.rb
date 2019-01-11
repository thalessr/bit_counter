# frozen_string_literal: true

require 'bit_stat'
require 'pathname'

RSpec.describe BitStat do
  let(:root_path) { Pathname.new(File.expand_path('..', __dir__)) }
  let(:temp_dir) { root_path.join('spec', 'tmp') }
  let(:fixtures_dir) { root_path.join('spec', 'fixtures') }
  let(:file) { nil }
  subject { described_class.new(file) }

  before { FileUtils.mkdir(temp_dir) }
  after { FileUtils.rm_rf(temp_dir) }

  def size_in_kb
    ((subject.number_of_zeros + subject.number_of_ones) / 8)
  end

  context 'Empty file' do
    let(:file) { File.open(temp_dir.join('empty.txt'), 'wb+') }

    before { subject.count_bits }

    it '#number_of_zero should be zero' do
      expect(subject.number_of_zeros).to be_zero
    end
    it '#number_of_ones should be zero' do
      expect(subject.number_of_ones).to be_zero
    end
  end

  context 'Not empty file' do
    let(:not_empty_path) { temp_dir.join('not_empty.txt') }
    let(:file) { File.open(not_empty_path, 'rb') }

    before do
      File.open(not_empty_path, 'wb+') { |f| f.write(5) }
      subject.count_bits
    end

    it '#number_of_zero should not be zero' do
      expect(subject.number_of_zeros).to eq(4)
    end

    it '#number_of_ones should not be zero' do
      expect(subject.number_of_ones).to eq(4)
    end

    it 'Number of bits equals to filesize in kb' do
      expect(size_in_kb).to eq(File.size?(not_empty_path))
    end
  end

  context 'Using fixture' do
    let(:aeroplane_fixture_path) { fixtures_dir.join('aeroplane.jpg') }
    let(:file) { File.open(aeroplane_fixture_path, 'rb') }
    before { subject.count_bits }

    it '#number_of_zero should not be zero' do
      expect(subject.number_of_zeros).to eq(11_313_699)
    end

    it '#number_of_ones should not be zero' do
      expect(subject.number_of_ones).to eq(15_744_093)
    end

    it 'Number of bits equals to filesize in kb' do
      expect(size_in_kb).to eq(File.size?(aeroplane_fixture_path))
    end
  end

  context 'Not using a file' do
    let(:file) { '' }
    it { expect { subject.count_bits }.to raise_error(RuntimeError) }
  end
end
