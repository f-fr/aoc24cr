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

def det(a, b)
  a[0] * b[1] - a[1] * b[0]
end

# Solve [a b]·x = c
def solve(a, b, c)
  d = det(a, b)
  return nil if d == 0 # let's hope there are no linearly dependent instances with a solution
  x = det(c, b)
  return nil if x % d != 0
  y = det(a, c)
  return nil if y % d != 0
  {x // d, y // d}
end

def run_day13(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64

  loop do
    break unless a = input.gets.try(&.split(/[ :,+=]/, remove_empty: true))
    a = {a[3].to_i64, a[5].to_i64}
    break unless b = input.gets.try(&.split(/[ :,+=]/, remove_empty: true))
    b = {b[3].to_i64, b[5].to_i64}
    break unless c = input.gets.try(&.split(/[ :,+=]/, remove_empty: true))
    c = {c[2].to_i64, c[4].to_i64}

    input.gets # empty line
    if x = solve(a, b, c)
      part1 += x[0] * 3 + x[1]
    end
    if x = solve(a, b, {c[0] + 10000000000000, c[1] + 10000000000000})
      part2 += x[0] * 3 + x[1]
    end
  end

  {part1, part2}
end
