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

def run_day01(input) : {Int64, Int64}
  ns, ms = input.each_line.map(&.split.map(&.to_i)).to_a.transpose
  ns.sort!
  ms.sort!
  part1 = ns.each.zip(ms.each).sum { |x, y| (x - y).abs }
  ncnts = ns.tally
  mcnts = ms.tally
  part2 = ncnts.sum { |x, m| x * m * (mcnts[x]? || 0) }
  {part1.to_i64, part2.to_i64}
end
