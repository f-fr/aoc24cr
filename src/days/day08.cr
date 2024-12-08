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

def run_day08(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64

  grid = input.each_line.map(&.chars.to_a).to_a

  antennas = grid.each_with_index.flat_map do |row, i|
    row.each_with_index.select { |c, _| c != '.' }.map { |c, j| {c, i, j} }
  end.to_a

  antennas.sort!

  pnts = Set({Int32, Int32}).new
  pnts2 = Set({Int32, Int32}).new

  t = 0
  while t < antennas.size
    s = t
    while t < antennas.size && antennas[t][0] == antennas[s][0]
      t += 1
    end
    (s...t).each do |i|
      (s...t).each do |j|
        next if i == j
        dx = antennas[j][1] - antennas[i][1]
        dy = antennas[j][2] - antennas[i][2]
        px = antennas[j][1] + dx
        py = antennas[j][2] + dy
        if 0 <= px < grid.size && 0 <= py < grid[0].size && !pnts.includes?({px, py})
          pnts.add({px, py})
          part1 += 1
        end

        px = antennas[j][1]
        py = antennas[j][2]
        while 0 <= px < grid.size && 0 <= py < grid[0].size
          if !pnts2.includes?({px, py})
            pnts2.add({px, py})
            part2 += 1
          end
          px += dx
          py += dy
        end
      end
    end
  end

  {part1, part2}
end
