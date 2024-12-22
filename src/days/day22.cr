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

N = 16777216

def run_day22(input)
  seen = Set(UInt32).new
  prices = Hash(UInt32, Int32).new(0)

  part1 = input.each_line.sum do |x|
    x = x.to_u64
    seen.clear
    seq = 0_u32
    2000.times do |i|
      y = ((x * 64) ^ x) % N
      y = ((y // 32) ^ y) % N
      y = ((y * 2048) ^ y) % N
      seq = (seq << 8) | (10 + (y % 10) - (x % 10)).to_u8
      x = y
      prices.update(seq, &.+(x % 10)) if i >= 3 && seen.add?(seq)
    end
    x
  end
  part2 = prices.each_value.max
  {part1, part2}
end
