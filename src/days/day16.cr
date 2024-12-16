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

private enum Direction
  Up
  Right
  Down
  Left
end

private def step(p : T, d : Direction) : T forall T
  case d
  in Direction::Up    then T.new(p.i - 1, p.j)
  in Direction::Right then T.new(p.i, p.j + 1)
  in Direction::Down  then T.new(p.i + 1, p.j)
  in Direction::Left  then T.new(p.i, p.j - 1)
  end
end

private def invert(d : Direction) : Direction
  Direction.new((d.value + 2) % 4)
end

private def clockwise(d : Direction) : Direction
  Direction.new((d.value + 1) % 4)
end

def run_day16(input) : {Int64, Int64}
  grid = Grid.read(input)

  s = grid.find('S') || raise "No start found"
  t = grid.find('E') || raise "No end found"
  st = {s, t}

  all_dists = Array.new(2) { grid.map { |_, _, c| c == '#' ? [] of Int32 : Array.new(4, Int32::MAX) } }

  degs = grid.map { 0 }
  grid.each do |i, j, c|
    if c != '#'
      Direction.each do |dir|
        nxt = step(Pnt[i, j], dir)
        degs[nxt] += 1
      end
    end
  end

  q = PriQueue({Int32, Pnt, Direction}).new
  simple_q = Deque({Int32, Pnt, Direction}).new

  2.times do |j|
    dists = all_dists[j]
    q.push({0, st[j], Direction::Left})
    dists[st[j]][Direction::Left.value] = 0

    while incoming = (simple_q.shift? || q.pop?)
      d, in_pos, in_dir = incoming
      (1..4).each do |i|
        pos, dir = in_pos, in_dir
        case i
        when 1
          pos, dir, c = step(pos, dir), invert(dir), 1
        when 3
          c = 0
        else
          c = pos != t ? 1000 : 0
        end

        if grid[step(in_pos, in_dir)] != '#' && d + c < dists[pos][dir.value]
          dists[pos][dir.value] = d + c
          if degs[pos] <= 2
            simple_q.push({d + c, pos, dir})
          else
            q.push({d + c, pos, dir})
          end
        end
        in_dir = clockwise(in_dir)
      end
    end
  end

  part1 = all_dists[0][t].min.to_i64
  part2 = 0_i64
  grid.each do |i, j, c|
    next if c == '#'
    Direction.each do |dir|
      next if (x = all_dists[0][i, j][dir.value]) > part1
      next if (y = all_dists[1][i, j][dir.value]) > part1
      if x + y == part1
        if grid[i, j] != 'O'
          grid[i, j] = 'O'
          part2 += 1
        end
      end
    end
  end

  {part1, part2}
end

def run_day16_2(input) : {Int64, Int64}
  grid = Grid.read(input)

  s = grid.find('S') || raise "No start found"
  t = grid.find('E') || raise "No end found"
  st = {s, t}

  q = PriQueue({Int32, Pnt, Direction}).new

  all_dists = Array.new(2) { Hash({Pnt, Direction}, Int32).new(Int32::MAX) }

  (0..1).each do |j|
    dists = all_dists[j]
    q.push({0, st[j], Direction::Left})
    dists[{st[j], Direction::Left}] = 0

    while incoming = q.pop?
      d, in_pos, in_dir = incoming
      (1..4).each do |i|
        pos, dir = in_pos, in_dir
        case i
        when 1
          pos, dir, c = step(pos, dir), invert(dir), 1
        when 3
          c = 0
        else
          c = pos != t ? 1000 : 0
        end

        if grid[step(in_pos, in_dir)] != '#' && d + c < (dists[{pos, dir}]? || Int32::MAX)
          dists[{pos, dir}] = d + c
          q.push({d + c, pos, dir})
        end
        in_dir = clockwise(in_dir)
      end
    end
  end

  part1 = Int32::MAX.to_i64
  Direction.each { |dir| part1 = {part1, all_dists[0][{t, dir}].to_i64}.min }
  part2 = 0_i64
  grid.each do |i, j, c|
    next if c == '#'
    Direction.each do |dir|
      next if (x = all_dists[0][{Pnt[i, j], dir}]) > part1
      next if (y = all_dists[1][{Pnt[i, j], dir}]) > part1
      if x + y == part1
        if grid[i, j] != 'O'
          grid[i, j] = 'O'
          part2 += 1
        end
      end
    end
  end

  {part1, part2}
end
