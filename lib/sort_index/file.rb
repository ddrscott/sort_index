module SortIndex
  class File < ::File

    # adds the line to the while maintaining the data's sort order
    #
    # @param [String] line to add to the file, it should not have it's own line ending.
    # @return [Nil] always returns nil to match standard #puts method
    def sorted_puts(line)
      if line == nil || line.size == 0
        raise ArgumentError, 'Line cannot be blank!'
      end
      if line.index($/)
        raise ArgumentError, "Cannot `puts` a line with extra line endings. Make sure the line does not contain `#{$/.inspect}`"
      end

      matched, idx = binary_seek(line)

      if matched
        # an exact match was found, nothing to do
      else
        if idx == nil
          # append to end of file
          self.seek(0, IO::SEEK_END)
          puts(line)
        else
          self.seek(cached_positions[idx][0], IO::SEEK_SET)
          do_at_current_position{puts(line)}
        end
        update_cached_position(idx, line)
      end
      nil
    end

    private

      # Builds an Array of position and length of the current file.
      # @return [Array[Array[Fixnum,Fixnum]]] array of position, line length pairs
      def index_each_line
        positions = []
        size = 0
        each_line do |line|
          positions << [size, line.size]
          size += line.size
        end
        rewind
        positions
      end

      # remembers current file position, reads everything at the position
      # execute the block, and put everything back.
      # This routine is really bad for huge files since it could run out of
      # memory.
      def do_at_current_position(&block)
        current_position = self.tell
        huge_buffer = self.read
        self.seek(current_position, IO::SEEK_SET)
        block.call
      ensure
        self.write huge_buffer
      end

      def update_cached_position(idx, line)
        line_size_with_ending = line.size + $/.size
        if idx
          # add an entry to the positions
          prev_pos = cached_positions[idx][0]
          cached_positions.insert(idx, [prev_pos, line_size_with_ending])

          # move all other entries ahead by the new entries length
          (idx+1).upto(cached_positions.size-1).each do |i|
            prev_pos = cached_positions[i][0]
            cached_positions[i][0] = prev_pos + line_size_with_ending
          end
        elsif cached_positions.empty?
          cached_positions << [0, line_size_with_ending]
        else
          last_pos, last_size = *cached_positions.last
          cached_positions << [last_pos + last_size, line_size_with_ending]
        end
      end

      def cached_positions
        @cached_positions ||= index_each_line
      end

      # @return [Boolean, Fixnum] true if exact match, the minimum position index
      def binary_seek(val)
        return nil if cached_positions.empty?

        last_line = nil
        idx = (0...@cached_positions.size).bsearch do |i|
          last_pair = @cached_positions[i]
          pos, len = *last_pair
          self.seek(pos, IO::SEEK_SET)

          # we don't want to compare the line ending
          last_line = self.read(len).strip
          last_line >= val
        end
        return last_line == val, idx
      end
    # END private
  end
end
