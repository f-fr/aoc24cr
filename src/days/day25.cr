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

def run_day25(input) : {Int32, Int32}
  keys = [] of Int32[5]
  locks = [] of Int32[5]
  code = StaticArray(Int32, 5).new { 0 }
  codetype = 0
  input.each_line.chain(Iterator.of("").first(1)).each do |line|
    if line.empty?
      case codetype
      when -1 then keys << code
      when +1 then locks << code
      end
      codetype = 0
    elsif codetype == 0
      raise "Invalid first line" unless line.each_char.cons_pair.all? { |x, y| x == y }
      case line[0]
      when '#' then codetype = +1
      when '.' then codetype = -1
      else          raise "Invalid code"
      end
      code.fill(0)
    else
      line.each_char_with_index do |c, i|
        code[i] += 1 if c == '#'
      end
    end
  end

  part1 = 0
  keys.each do |key|
    locks.each do |lock|
      valid = true
      key.size.times { |i| valid &&= key[i] + lock[i] <= 6 }
      part1 += 1 if valid
      # part1 += 1 if key.each.zip(lock.each).all? { |x, y| x + y <= 6 }
    end
  end

  {part1, 0}
end
