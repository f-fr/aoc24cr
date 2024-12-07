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

def check(x, ns, n)
  return ns[0] == x if n == 1
  return false if x < ns[n - 1]
  return true if x % ns[n - 1] == 0 && check(x // ns[n - 1], ns, n - 1)
  return true if check(x - ns[n - 1], ns, n - 1)
  false
end

def check2(x, ns, n)
  return ns[0] == x if n == 1
  return false if x < ns[n - 1]
  return true if x % ns[n - 1] == 0 && check2(x // ns[n - 1], ns, n - 1)
  return true if check2(x - ns[n - 1], ns, n - 1)

  y = ns[n - 1]
  while y > 0 && x % 10 == y % 10
    x //= 10
    y //= 10
  end
  return true if y == 0 && check2(x, ns, n - 1)

  false
end

def run_day07(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64
  input.each_line do |line|
    x, *ns = line.split(/[: ]/, remove_empty: true)
    x = x.to_i64
    ns = ns.map(&.to_i)
    part1 += x if check(x, ns, ns.size)
    part2 += x if check2(x, ns, ns.size)
  end

  {part1, part2}
end
