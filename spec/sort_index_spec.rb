require 'spec_helper'
require 'tempfile'

describe SortIndex do
  it 'has a version number' do
    expect(SortIndex::VERSION).not_to be nil
  end

  it 'omits duplicate entries' do
    Tempfile.open('sort-index') do |t|
      SortIndex::File.open(t.path, 'r+') do |f|
        f.sorted_puts 'a'
        f.sorted_puts 'a'
        f.sorted_puts 'b'
        f.sorted_puts 'b'
      end
      result = IO.read(t.path)
      expect(result).to eq("a\nb\n")
    end
  end

  it 'maintains cache_positions' do
    Tempfile.open('sort-index') do |t|
      t.write <<-TEXT
a
bb
ccc
TEXT
      t.flush
      SortIndex::File.open(t.path, 'r+') do |f|
        positions = f.send :cached_positions

        expect(positions). to eq([[0, 2], [2, 3], [5, 4]])
      end
    end
  end

  it 'creates a sorted alphabet' do
    random_letters = %w(c r d p x l y i j h k v q b u w s e n g z t a m f o)

    Tempfile.open('sort-index') do |t|
      SortIndex::File.open(t.path, 'r+') do |f|
        random_letters.each do |letter|
          f.sorted_puts letter
        end
      end
      result = IO.read(t.path)
      expect(result).to eq(random_letters.sort.map{|m| "#{m}\n"}.join)
    end
  end
end
