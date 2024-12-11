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

require "../priqueue"

def split(memo : Hash(Int64, {Int64, Int64}), x) : {Int64, Int64}?
  if r = memo[x]?
    return r[0] == 0 ? nil : r
  end
  a = x
  i = 0
  while a > 0
    i += 1
    a //= 10
  end
  return nil unless i % 2 == 0
  i //= 2
  a = 0_i64
  b = x
  i.times do
    a = a * 10 + b % 10
    b //= 10
  end
  y = 0_i64
  i.times do
    y = y * 10 + a % 10
    a //= 10
  end

  memo[x] = {b, y}

  {b, y}
end

def run_day11(input) : {Int64, Int64}
  part1 = 0_i64

  memo = Hash(Int64, {Int64, Int64}).new
  cnts = Hash(Int64, Int64).new { |h, k| h[k] = 0_i64 }
  cnts2 = Hash(Int64, Int64).new { |h, k| h[k] = 0_i64 }
  (input.gets || "").split(/\s+/).each { |x| cnts.update(x.to_i64, &.+ 1) }

  1.upto(75) do |i|
    cnts2.clear
    cnts.each do |x, n|
      y = nil
      case
      when x == 0              then x = 1_i64
      when sp = split(memo, x) then x, y = sp
      else                          x *= 2024
      end

      cnts2.update(x, &.+ n)
      cnts2.update(y, &.+ n) if y
    end

    cnts, cnts2 = cnts2, cnts

    part1 = cnts.each_value.sum if i == 25
  end

  part2 = cnts.each_value.sum

  {part1, part2}
end
