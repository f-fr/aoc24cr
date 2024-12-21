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

enum Button
  Up; Right; Down; Left; Act
end

private def try_ctrl_press(but : Button, bctrl : Button) : Button?
  pos = case but
        in Button::Up    then Pnt[0, 1]
        in Button::Right then Pnt[1, 2]
        in Button::Down  then Pnt[1, 1]
        in Button::Left  then Pnt[1, 0]
        in Button::Act   then Pnt[0, 2]
        end

  case bctrl
  in Button::Up    then pos = pos.up
  in Button::Right then pos = pos.right
  in Button::Down  then pos = pos.down
  in Button::Left  then pos = pos.left
  in Button::Act   then return but
  end

  if 0 <= pos.i <= 1 && 0 <= pos.j <= 2 && pos != Pnt[0, 0]
    case pos
    when Pnt[0, 1] then Button::Up
    when Pnt[0, 2] then Button::Act
    when Pnt[1, 0] then Button::Left
    when Pnt[1, 1] then Button::Down
    when Pnt[1, 2] then Button::Right
    end
  else
    nil
  end
end

# try press number 0..9 or 10 (is 'A')
private def try_num_press(but : Int32, bctrl : Button) : Int32?
  pos = case but
        when  0 then Pnt[3, 1]
        when  1 then Pnt[2, 0]
        when  2 then Pnt[2, 1]
        when  3 then Pnt[2, 2]
        when  4 then Pnt[1, 0]
        when  5 then Pnt[1, 1]
        when  6 then Pnt[1, 2]
        when  7 then Pnt[0, 0]
        when  8 then Pnt[0, 1]
        when  9 then Pnt[0, 2]
        when 10 then Pnt[3, 2]
        else         raise "Invalid button: #{but}"
        end

  case bctrl
  in Button::Up    then pos = pos.up
  in Button::Right then pos = pos.right
  in Button::Down  then pos = pos.down
  in Button::Left  then pos = pos.left
  in Button::Act   then return but
  end

  case pos
  when Pnt[3, 1] then 0
  when Pnt[2, 0] then 1
  when Pnt[2, 1] then 2
  when Pnt[2, 2] then 3
  when Pnt[1, 0] then 4
  when Pnt[1, 1] then 5
  when Pnt[1, 2] then 6
  when Pnt[0, 0] then 7
  when Pnt[0, 1] then 8
  when Pnt[0, 2] then 9
  when Pnt[3, 2] then 10
  else
    nil
  end
end

# - q the priority queue (for reuse)
# - s, t the start and end positions on the current pad
# - dists the distances grid (for reuse)
# - costs[b1, b2] the cost (on the control pad) for pressing b2 after b1
# - &: (but, bctrl) -> but? the callback returning the new button position
#      when the current position is `but` and `bctrl` is pressed on the control pad,
#      or `nil` if invalid
private def solve(q, s, t, dists, costs, & : (Int32, Button) -> Int32?)
  q.clear
  q.push({0_i64, s, Button::Act})
  dists.fill(Int64::MAX)
  dists[s, Button::Act.value] = 1
  while cur = q.pop?
    d, cur_b, cur_bctrl = cur
    break if cur_b == t && cur_bctrl == Button::Act
    Button.each do |nxt_bctrl|
      c = costs[cur_bctrl.value, nxt_bctrl.value]
      nxt_b = yield(cur_b, nxt_bctrl) || next
      if d + c < dists[nxt_b, nxt_bctrl.value]
        dists[nxt_b, nxt_bctrl.value] = d + c
        q.push({d + c, nxt_b, nxt_bctrl})
      end
    end
  end
  dists[t, Button::Act.value]
end

def run_day21(input)
  lines = input.each_line.to_a
  part1 = 0_i64
  part2 = 0_i64

  n = Button.values.size
  cost = Grid(Int64).new(n, n) { 1_i64 }
  nxtcost = cost.map { Int64::MAX }

  q = PriQueue({Int64, Int32, Button}).new
  dists = cost.map { Int64::MAX }
  num_dists = Grid.new(11, 5) { Int64::MAX }

  1.upto(25) do |k|
    Button.each do |b1|
      Button.each do |b2|
        nxtcost[b1.value, b2.value] = solve(q, b1.value, b2.value, dists, cost) do |but, bctrl|
          try_ctrl_press(Button.new(but), bctrl).try(&.value)
        end
      end
    end

    cost, nxtcost = nxtcost, cost

    next unless k == 2 || k == 25

    lines.each do |line|
      sum = 0_i64
      s = 10
      line.each_char do |ch|
        t = case ch
            when '0'..'9' then ch.to_i
            when 'A'      then 10
            else               raise "Invalid character #{ch}"
            end

        sum += solve(q, s, t, num_dists, cost, &->try_num_press(Int32, Button))
        s = t
      end

      if k == 2
        part1 += sum * line[/[1-9]\d*/].to_i
      else
        part2 += sum * line[/[1-9]\d*/].to_i64
      end
    end
  end

  {part1, part2}
end
