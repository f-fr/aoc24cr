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

enum Direction
  Up
  Right
  Down
  Left
end

def step(p, d)
  case d
  in Direction::Up    then {p[0] - 1, p[1]}
  in Direction::Right then {p[0], p[1] + 1}
  in Direction::Down  then {p[0] + 1, p[1]}
  in Direction::Left  then {p[0], p[1] - 1}
  end
end

def run_day06(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64

  grid = input.each_line.map { |l| [' '] + l.chars.to_a + [' '] }.to_a
  grid.unshift([' '] * grid[0].size)
  grid.push([' '] * grid[0].size)

  n = grid.size
  m = grid[0].size

  gup = Array.new(n) { Array.new(m, 0) }
  gright = Array.new(n) { Array.new(m, 0) }
  gdown = Array.new(n) { Array.new(m, 0) }
  gleft = Array.new(n) { Array.new(m, 0) }
  flags = Array.new(n) { Array.new(m, 0) }

  # for each field we store the next obstacle (or boundary) in that direction
  (1...n - 1).each do |i|
    k = 0
    1.upto(m - 2).each do |j|
      if grid[i][j] == '#'
        k = j + 1
      else
        gleft[i][j] = k
      end
    end
    k = m - 1
    (m - 2).downto(1).each do |j|
      if grid[i][j] == '#'
        k = j - 1
      else
        gright[i][j] = k
      end
    end
  end

  (1...m - 1).each do |j|
    k = 0
    1.upto(n - 2).each do |i|
      if grid[i][j] == '#'
        k = i + 1
      else
        gup[i][j] = k
      end
    end
    k = n - 1
    (n - 2).downto(1).each do |i|
      if grid[i][j] == '#'
        k = i - 1
      else
        gdown[i][j] = k
      end
    end
  end

  s = nil
  (1..n - 2).each do |i|
    (1..m - 2).each do |j|
      case grid[i][j]
      when '<' then s = {i, j, Direction::Left}; break
      when '^' then s = {i, j, Direction::Up}; break
      when '>' then s = {i, j, Direction::Right}; break
      when 'v' then s = {i, j, Direction::Down}; break
      end
    end
  end
  raise "Starting position not found" unless s

  p = s[0..1]
  d = s[2]
  path = [] of {Int32, Int32}

  while grid[p[0]][p[1]] != ' '
    if grid[p[0]][p[1]] != 'X'
      grid[p[0]][p[1]] = 'X'
      path << p if p != s[0..1]
      part1 += 1
    end
    q = step(p, d)
    case grid[q[0]][q[1]]
    when '#' then d = Direction.new((d.value + 1) % 4)
    when ' ' then break
    else          p = q
    end
  end

  visited = [] of {Int32, Int32}
  path.each do |pnew|
    visited.each { |x| flags[x[0]][x[1]] = 0 }
    visited.clear

    p = s[0..1]
    d = s[2]

    while grid[p[0]][p[1]] != ' '
      if flags[p[0]][p[1]] & (1 << d.value) != 0
        part2 += 1
        break
      end
      flags[p[0]][p[1]] |= 1 << d.value
      visited << p

      case d
      in Direction::Up
        if (p[1] == pnew[1]) && (gup[p[0]][p[1]] <= pnew[0] < p[0])
          p = {pnew[0] + 1, p[1]}
        else
          p = {gup[p[0]][p[1]], p[1]}
        end
      in Direction::Right
        if (p[0] == pnew[0]) && (p[1] < pnew[1] <= gright[p[0]][p[1]])
          p = {p[0], pnew[1] - 1}
        else
          p = {p[0], gright[p[0]][p[1]]}
        end
      in Direction::Down
        if (p[1] == pnew[1]) && (p[0] < pnew[0] <= gdown[p[0]][p[1]])
          p = {pnew[0] - 1, p[1]}
        else
          p = {gdown[p[0]][p[1]], p[1]}
        end
      in Direction::Left
        if (p[0] == pnew[0]) && (gleft[p[0]][p[1]] <= pnew[1] < p[1])
          p = {p[0], pnew[1] + 1}
        else
          p = {p[0], gleft[p[0]][p[1]]}
        end
      end
      d = Direction.new((d.value + 1) % 4)
    end
  end

  {part1, part2}
end
