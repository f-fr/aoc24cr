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

def run_day15(input) : {Int64, Int64}
  lines = input.each_line
  grid = lines.take_while(&.empty?.!).map(&.chars).to_a
  moves = lines.join

  pos = Pnt[0, 0]
  n = 0
  grid.each_with_index do |row, i|
    if j = row.index('@')
      pos = Pnt[i, j]
    end
    n += row.count(&.== 'O')
  end

  grid[pos.i][pos.j] = '.'

  pos2 = Pnt[pos.i, pos.j * 2]
  grid2 = grid.map do |row|
    row.flat_map do |c|
      case c
      when '#' then {'#', '#'}.each
      when 'O' then {'[', ']'}.each
      else          {'.', '.'}.each
      end
    end
  end

  moves.each_char do |c|
    dir = case c
          when '^' then Pnt.new(-1, 0)
          when '>' then Pnt.new(0, +1)
          when 'v' then Pnt.new(+1, 0)
          when '<' then Pnt.new(0, -1)
          else          next
          end
    oth = pos + dir
    while grid[oth.i][oth.j] == 'O'
      oth += dir
    end
    if grid[oth.i][oth.j] == '.'
      pos += dir
      grid[pos.i][pos.j] = '.'
      grid[oth.i][oth.j] = 'O' if oth != pos
    end
  end

  part1 = 0_i64
  grid.each_with_index do |row, i|
    row.each_with_index do |c, j|
      part1 += 100 * i + j if c == 'O'
    end
  end

  grid = grid2
  pos = pos2
  seen = Array.new(grid.size) { |i| Array.new(grid[i].size, -1) }
  q = Array(Pnt).new(n, Pnt[0, 0])
  n = 0
  grid[pos.i][pos.j] = '@'
  grid[pos.i][pos.j] = '.'
  moves.each_char do |c|
    n += 1
    if c == '<' || c == '>'
      dir = c == '<' ? Pnt[0, -1] : Pnt[0, 1]
      oth = pos + dir
      while grid[oth.i][oth.j] == '[' || grid[oth.i][oth.j] == ']'
        oth += dir
      end
      if grid[oth.i][oth.j] == '.'
        pos += dir
        box = oth
        while box != pos
          grid[box.i][box.j] = grid[box.i][box.j - dir.j]
          box -= dir
        end
        grid[pos.i][pos.j] = '.'
      end
    elsif c == '^' || c == 'v'
      dir = c == '^' ? Pnt[-1, 0] : Pnt[1, 0]
      case grid[pos.i + dir.i][pos.j]
      when '.'
        pos += dir
      when '#'
        nil
      else
        qput = 1
        qget = 0
        q[0] = grid[pos.i + dir.i][pos.j] == '[' ? pos + dir : pos + dir + Pnt::Left
        while qget < qput
          box = q[qget]
          qget += 1
          oth = box + dir
          if grid[oth.i][oth.j] == '#' || grid[oth.i][oth.j + 1] == '#'
            qget = -1
            break
          end
          oth.j -= 1 if grid[oth.i][oth.j] == ']'
          if grid[oth.i][oth.j] == '[' && seen[oth.i][oth.j] < n
            seen[oth.i][oth.j] = n
            q[qput] = oth
            qput += 1
          end

          oth = box + dir + Pnt::Right
          if grid[oth.i][oth.j] == '#'
            qget = -1
            break
          end
          if grid[oth.i][oth.j] == '[' && seen[oth.i][oth.j] < n
            seen[oth.i][oth.j] = n
            q[qput] = oth
            qput += 1
          end
        end

        if qget >= 0
          q.each.first(qput).each do |pos|
            grid[pos.i][pos.j] = '.'
            grid[pos.i][pos.j + 1] = '.'
          end
          q.each.first(qput).each do |pos|
            grid[pos.i + dir.i][pos.j] = '['
            grid[pos.i + dir.i][pos.j + 1] = ']'
          end
          pos += dir
        end
      end
    end
  end

  part2 = 0_i64
  grid.each_with_index do |row, i|
    row.each_with_index do |c, j|
      part2 += 100 * i + j if c == '['
    end
  end

  {part1, part2}
end

def run_day15_2(input) : {Int64, Int64}
  grid = Grid.read(input)
  moves = input.each_line.join

  n = grid.count(&.[2].== 'O')
  pos = grid.find('@') || raise "No start position '@' found"
  grid[pos] = '.'

  pos2 = Pnt[pos.i, pos.j * 2]
  grid2 = Grid.new(grid.each_row.map do |row|
    row.flat_map do |c|
      case c
      when '#' then {'#', '#'}.each
      when 'O' then {'[', ']'}.each
      else          {'.', '.'}.each
      end
    end
  end.to_a)

  moves.each_char do |c|
    dir = case c
          when '^' then Pnt::Up
          when '>' then Pnt::Right
          when 'v' then Pnt::Down
          when '<' then Pnt::Left
          else          next
          end
    oth = pos + dir
    while grid[oth] == 'O'
      oth += dir
    end
    if grid[oth] == '.'
      pos += dir
      grid[pos] = '.'
      grid[oth] = 'O' if oth != pos
    end
  end

  part1 = grid.sum(0_i64) { |i, j, c| c == 'O' ? 100 * i + j : 0 }

  grid = grid2
  pos = pos2
  seen = grid.map { -1 }
  q = Deque(Pnt).new
  boxes = Array(Pnt).new
  moves.each_char.with_index do |c, iter|
    if c == '<' || c == '>'
      dir = c == '<' ? Pnt[0, -1] : Pnt[0, 1]
      oth = pos + dir
      while grid[oth] == '[' || grid[oth] == ']'
        oth += dir
      end
      if grid[oth] == '.'
        pos += dir
        box = oth
        while box != pos
          grid[box] = grid[box - dir]
          box -= dir
        end
        grid[pos.i][pos.j] = '.'
      end
    elsif c == '^' || c == 'v'
      dir = c == '^' ? Pnt[-1, 0] : Pnt[1, 0]
      case grid[pos + dir]
      when '.' then pos += dir
      when '#' then nil
      else
        boxes.clear
        q.clear
        q << (grid[pos + dir] == '[' ? pos + dir : pos + dir + Pnt::Left)
        result = while box = q.pop?
          boxes << box
          oth = box + dir
          break false if grid[oth] == '#' || grid[oth.right] == '#'
          oth.j -= 1 if grid[oth] == ']'
          if grid[oth] == '[' && seen[oth] < iter
            seen[oth] = iter
            q << oth
          end

          oth = box + dir + Pnt::Right
          break false if grid[oth] == '#'
          if grid[oth] == '[' && seen[oth] < iter
            seen[oth] = iter
            q << oth
          end
        end

        if result != false
          boxes.each do |pos|
            grid[pos] = '.'
            grid[pos.right] = '.'
          end
          boxes.each do |pos|
            grid[pos + dir] = '['
            grid[pos + dir + Pnt::Right] = ']'
          end
          pos += dir
        end
      end
    end
  end

  part2 = grid.sum(0_i64) { |i, j, c| c == '[' ? 100 * i + j : 0 }

  {part1, part2}
end
