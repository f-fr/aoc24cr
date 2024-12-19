# Copyright (c) 2024 Frank Fischer <frank-fischer@shadow-soft.de>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see  <http://www.gnu.org/licenses/>

private class Trie
  class Node
    property nxt : Node?[5] = StaticArray(Node?, 5).new { nil }
    property? valid = false
  end

  getter root : Node

  def initialize
    @root = Node.new
  end

  def <<(pattern : Indexable(UInt8))
    node = @root
    i = 0
    # go through existing nodes
    while i < pattern.size && (nxt = node.nxt[pattern[i]])
      node = nxt
      i += 1
    end
    # maybe add new nodes
    while i < pattern.size
      n = Node.new
      node.nxt[pattern[i]] = n
      node = n
      i += 1
    end
    node.valid = true
    node
  end
end

private def convert(pattern)
  pattern.map do |c|
    case c
    when 'w' then 0_u8
    when 'u' then 1_u8
    when 'b' then 2_u8
    when 'r' then 3_u8
    when 'g' then 4_u8
    else          raise "Invalid stripe color #{c}"
    end
  end.to_a
end

def run_day19(input : IO)
  trie = Trie.new
  (input.gets || raise "missing patterns").split(',').each { |pat| trie << convert(pat.strip.each_char) }

  part1 = 0
  part2 = 0_i64

  possible = [] of Int64
  while line = input.gets
    next if line.empty?
    line = convert(line.each_char)
    possible.clear
    possible << 1
    (line.size - 1).downto(0) do |i|
      pos = 0_i64
      node = trie.root
      (i...line.size).each do |ii|
        break unless node = node.nxt[line[ii]]
        pos += possible[line.size - ii - 1] if node.valid?
      end
      possible << pos
    end
    part1 += 1 if possible.last > 0
    part2 += possible.last
  end

  {part1, part2}
end
