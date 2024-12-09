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
  fileid.to_i64 * (((pos + len) * (pos + len - 1)) // 2 - (pos * (pos - 1)) // 2)
end

def run_day09(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64

  input = input.gets || raise "Unexpected end of input"
  nums = input.each_char.map(&.to_i.- '0'.to_i).to_a
  nums2 = nums.dup

  i, j, pos = 0, nums.size - 1, 0
  while i < j
    # add current left file block
    part1 += value(i // 2, pos, nums[i])
    pos += nums[i]
    nums[i] = 0
    # go to space
    i += 1
    while nums[i] > 0
      # copy from right to space
      k = {nums[i], nums[j]}.min
      part1 += value(j // 2, pos, k)
      pos += k
      nums[i] -= k
      nums[j] -= k
      j -= 2 if nums[j] == 0 # skip space
    end
    # next block
    i += 1
  end
  # remaining file blocks stay at right end
  part1 += value(j // 2, pos, nums[j])

  # collect all gap sizes in pri queues
  gaps = Array.new(10) { PriQueue(Int32).new }
  i, pos = 0, 0
  while i < nums2.size
    pos += nums2[i]
    i += 1
    if i < nums2.size && nums2[i] > 0
      gaps[nums2[i]].push(pos)
      pos += nums2[i]
    end
    i += 1
  end

  j = nums2.size - 1
  while j >= 0
    pos -= nums2[j]
    best = (nums2[j]..9).compact_map do |i|
      if (min = gaps[i].min?) && min < pos
        {i, min}
      end
    end.min_by?(&.[1])
    if best
      best_gap, best_pos = best
      gaps[best_gap].pop?
      # move to gap
      gaps[best_gap - nums2[j]].push(best_pos + nums2[j]) if best_gap > nums2[j]
      part2 += value(j // 2, best_pos.to_i64, nums2[j].to_i64)
    else
      part2 += value(j // 2, pos.to_i64, nums2[j].to_i64)
    end

    pos -= nums2[j - 1] if j > 0
    j -= 2
  end

  {part1, part2}
end
