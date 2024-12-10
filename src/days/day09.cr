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

def value(fileid, pos : Int64, len) : Int64
  fileid.to_i64 * len * (len - 1 + 2 * pos) // 2
end

def run_day09(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64

  input = input.gets || raise "Unexpected end of input"
  nums = input.each_char.map(&.to_i.- '0'.to_i).to_a

  i, j, pos = 0, nums.size - 1, 0
  y = nums[j]
  while i < j
    # add current left file block
    part1 += value(i // 2, pos, nums[i])
    pos += nums[i]
    # go to space
    i += 1
    x = nums[i]
    while x > 0
      # copy from right to space
      k = {x, y}.min
      part1 += value(j // 2, pos, k)
      pos += k
      x -= k
      y -= k
      if y == 0
        j -= 2 # skip space
        break if j <= i
        y = nums[j]
      end
    end
    # next block
    i += 1
  end
  # remaining file blocks stay at right end
  part1 += value(j // 2, pos, y)

  # collect all gap sizes in pri queues
  gaps = Array.new(10) { PriQueue(Int32).new(capacity: 1024) }
  i, pos = 0, 0
  while i < nums.size
    pos += nums[i]
    i += 1
    if i < nums.size && nums[i] > 0
      gaps[nums[i]].push(pos)
      pos += nums[i]
    end
    i += 1
  end

  j = nums.size - 1
  while j >= 0
    pos -= nums[j]
    best_pos, best_gap = pos, nil
    (nums[j]..9).each do |i|
      if (min = gaps[i].min?) && min < best_pos
        best_pos, best_gap = min, i
      end
    end
    if best_gap
      gaps[best_gap].pop?
      # move to gap
      gaps[best_gap - nums[j]].push(best_pos + nums[j]) if best_gap > nums[j]
      part2 += value(j // 2, best_pos, nums[j])
    else
      part2 += value(j // 2, pos, nums[j])
    end

    pos -= nums[j - 1] if j > 0
    j -= 2
  end

  {part1, part2}
end
