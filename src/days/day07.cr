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

def check(x, ns, n, concat = false)
  return ns[0] == x if n == 1
  return false if x < ns[n - 1]
  return true if x % ns[n - 1] == 0 && check(x // ns[n - 1], ns, n - 1, concat)
  return true if check(x - ns[n - 1], ns, n - 1, concat)
  if concat
    y = ns[n - 1]
    while y > 0 && x % 10 == y % 10
      x //= 10
      y //= 10
    end
    return true if y == 0 && check(x, ns, n - 1, concat)
  end
  false
end

def run_day07(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64
  input.each_line do |line|
    x, *ns = line.split(/[: ]/, remove_empty: true)
    x = x.to_i64
    ns = ns.map(&.to_i)
    if check(x, ns, ns.size)
      part1 += x
      part2 += x
    elsif check(x, ns, ns.size, true)
      part2 += x
    end
  end

  {part1, part2}
end
