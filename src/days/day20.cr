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

def run_day20(input)
  grid = Grid.read(input)
  s = grid.find('S') || raise "No start found"
  t = grid.find('E') || raise "No end found"

  q = Deque(Pnt).new
  dist_fwd, dist_bwd = {s, t}.map do |u|
    dists = grid.map { Int32::MAX }
    q.clear
    q << u
    dists[u] = 0
    while u = q.shift?
      d = dists[u]
      {u.up, u.right, u.down, u.left}.each do |v|
        if grid[v] != '#' && dists[v] == Int32::MAX
          dists[v] = d + 1
          q << v
        end
      end
    end
    dists
  end

  diff1, diff2 = grid.n <= 16 ? {1, 50} : {100, 100}

  part1, part2 = 0, 0

  grid.each do |i, j, c|
    next if c == '#'
    {i - 20, 1}.max.upto({i + 20, grid.n - 2}.min) do |i2|
      {j - 20 + (i - i2).abs, 1}.max.upto({j + 20 - (i - i2).abs, grid.m - 2}.min) do |j2|
        next if grid[i2, j2] == '#'
        d = (i - i2).abs + (j - j2).abs
        dst = dist_fwd[t] - (dist_fwd[i, j] + dist_bwd[i2, j2] + d)
        part1 += 1 if d <= 2 && dst >= diff1
        part2 += 1 if d <= 20 && dst >= diff2
      end
    end
  end

  {part1, part2}
end
