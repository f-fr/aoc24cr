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

def run_day18(input : IO) : {Int32, String}
  nums = input.each_line.map(&.split(',').map(&.to_i)).to_a
  is_test = nums.all? { |n| n[0] <= 6 && n[1] <= 6 }
  n, m, npart1 = is_test ? {7, 7, 12} : {71, 71, 1024}

  # add boundary
  n += 2
  m += 2

  s = Pnt[1, 1]
  t = Pnt[n - 2, m - 2]

  grid = Grid.new(n, m) do |i, j|
    if i == 0 || i == n - 1 || j == 0 || j == m - 1
      0 # boundary is blocked immediately
    else
      Int32::MAX
    end
  end
  dist = Grid.new(n, m) { 0 }
  seen = Grid.new(n, m) { -1 }

  nums.each_with_index do |pos, i|
    grid[pos[0] + 1][pos[1] + 1] = i + 1
  end

  q = Deque(Pnt).new
  # we use binary search
  a, b = 0, nums.size
  i = 0
  while a + 1 < b
    m = i == 0 ? npart1 : ((a + b) // 2)
    q.clear
    q << s
    dist[s] = 0
    seen[s] = i
    while pos = q.shift?
      break if pos == t
      d = dist[pos]
      {Pnt::Up, Pnt::Right, Pnt::Down, Pnt::Left}.each do |dir|
        nxt = pos + dir
        if grid[nxt] > m && seen[nxt] < i
          q << nxt
          seen[nxt] = i
          dist[nxt] = d + 1
        end
      end
    end

    part1 = dist[t] if i == 0
    if seen[t] == i
      a = m
    else
      b = m
    end
    i += 1
  end

  part2 = "#{nums[b - 1][0]},#{nums[b - 1][1]}"

  {part1 || 0, part2}
end
