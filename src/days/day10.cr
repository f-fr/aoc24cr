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

def run_day10(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64

  grid = input.each_line.map { |l| [' '] + l.chars + [' '] }.to_a
  grid.unshift([' '] * grid[0].size)
  grid.push([' '] * grid[0].size)

  n = grid.size
  m = grid[0].size

  seen = Array.new(n) { Array.new(m, 0) }
  cnt = Array.new(n) { Array.new(m, 0) }
  q = [] of {Int32, Int32}
  k = 0
  (1..n - 2).each do |i|
    (1..m - 2).each do |j|
      next if grid[i][j] != '0'

      k += 1 # next "generation"
      seen[i][j] = k
      cnt[i][j] = 1
      q << {i, j}
      while pos = q.shift?
        cur = grid[pos[0]][pos[1]]
        if cur == '9'
          part1 += 1
          part2 += cnt[pos[0]][pos[1]]
        else
          nxt = cur.succ
          { {-1, 0}, {0, 1}, {1, 0}, {0, -1} }.each do |di, dj|
            inxt, jnxt = pos[0] + di, pos[1] + dj
            if grid[inxt][jnxt] == nxt
              if seen[inxt][jnxt] < k
                cnt[inxt][jnxt] = cnt[pos[0]][pos[1]]
                seen[inxt][jnxt] = k
                q << {inxt, jnxt}
              else
                cnt[inxt][jnxt] += cnt[pos[0]][pos[1]]
              end
            end
          end
        end
      end
    end
  end

  {part1, part2}
end
