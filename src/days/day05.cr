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

def run_day05(input) : {Int64, Int64}
  lines = input.each_line
  edges = lines.take_while(&.empty?.!).map(&.split('|')).map { |a| {a[0].to_i, a[1].to_i} }.to_set

  part1, part2 = 0_i64, 0_i64
  lines.each.map(&.split(',').map(&.to_i)).each do |nums|
    if nums.each_cons_pair.none? { |u, v| edges.includes?({v, u}) }
      part1 += nums[nums.size // 2]
    elsif nums.sort! do |u, v|
            case
            when u == v                  then 0
            when edges.includes?({v, u}) then 1
            else                              -1
            end
          end
      part2 += nums[nums.size // 2]
    end
  end

  {part1, part2}
end
