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

def run_day12(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64

  grid = input.each_line.map { |l| [' '] + l.chars + [' '] }.to_a
  grid.unshift([' '] * grid[0].size)
  grid.push([' '] * grid[0].size)

  n = grid.size
  m = grid[0].size

  seen = Array.new(n) { |i| Array.new(m) { |j| grid[i][j] == ' ' } }
  q = [] of {Int32, Int32}

  1.upto(n - 2) do |i|
    1.upto(n - 2) do |j|
      next if seen[i][j]
      q << {i, j}
      seen[i][j] = true
      area, perm, lns = 0, 0, 0
      while pos = q.pop?
        c = grid[i][j]
        area += 1
        { {0, -1}, {1, 0}, {0, 1}, {-1, 0} }.each do |d|
          nxt = {pos[0] + d[0], pos[1] + d[1]}
          if c != grid[nxt[0]][nxt[1]]
            perm += 1
            a = {pos[0] + d[1], pos[1] - d[0]}
            b = {nxt[0] + d[1], nxt[1] - d[0]}
            lns += 1 if grid[a[0]][a[1]] != c || grid[b[0]][b[1]] == c
          elsif !seen[nxt[0]][nxt[1]]
            seen[nxt[0]][nxt[1]] = true
            q << nxt
          end
        end
      end
      part1 += area * perm
      part2 += area * lns
    end
  end

  {part1, part2}
end
