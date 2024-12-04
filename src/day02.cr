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

def run_day02(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64
  input.each_line do |line|
    line = line.split.map(&.to_i)
    k = (0..line.size).find do |i|
      min, max = line
        .each_with_index.reject { |_, j| i > 0 && j == i - 1 }
        .map(&.[0])
        .cons_pair
        .minmax_of { |x, y| y - x }
      1 <= min <= max <= 3 || -3 <= min <= max <= -1
    end
    part1 += 1 if k == 0
    part2 += 1 if k
  end
  {part1, part2}
end
