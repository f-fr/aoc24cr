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

def run_day04(input) : {Int64, Int64}
  grid = input.each_line.map { |l| ".#{l}." }.to_a
  grid.unshift("." * grid[0].size)
  grid.push("." * grid[0].size)

  part1 = 0_i64
  part2 = 0_i64
  (1...grid.size - 1).each do |i|
    (1...grid[i].size - 1).each do |j|
      (-1..1).each do |dx|
        (-1..1).each do |dy|
          part1 += 1 if "XMAS".each_char.with_index.all? { |c, d| grid[i + d*dx][j + d*dy] == c }
        end
      end
      part2 += 1 if grid[i][j] == 'A' &&
                    {-1, 1}.any? { |d| grid[i + d][j + d] == 'M' && grid[i - d][j - d] == 'S' } &&
                    {-1, 1}.any? { |d| grid[i - d][j + d] == 'M' && grid[i + d][j - d] == 'S' }
    end
  end
  {part1, part2}
end