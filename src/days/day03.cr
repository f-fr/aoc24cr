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

def run_day03(input) : {Int64, Int64}
  input = input.gets_to_end
  part1 = 0_i64
  part2 = 0_i64
  doit = true
  input.scan(/mul\((\d{1,3}),(\d{1,3})\)|(do\(\))|(don't\(\))/) do |m|
    if m[3]?
      doit = true
    elsif m[4]?
      doit = false
    else
      x = m[1].to_i * m[2].to_i
      part1 += x
      part2 += x if doit
    end
  end
  {part1, part2}
end
