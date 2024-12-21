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

def try_press(but : Button, bctrl : Button) : Button?
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

def try_press(pos : Pnt, bctrl : Button) : Pnt?
  p = pos
  case bctrl
  in Button::Up    then p = pos.up
  in Button::Right then p = pos.right
  in Button::Down  then p = pos.down
  in Button::Left  then p = pos.left
  in Button::Act   then return pos
  end
  if 0 <= p.i <= 3 && 0 <= p.j <= 2 && p != Pnt[3, 0]
    p
  else
    nil
  end
end

def run_day21(input)
  lines = input.each_line.to_a
  part1 = 0_i64
  part2 = 0_i64

  cost = Array.new(5) { Array(Int64).new(5, 1) }
  nxtcost = Array.new(5) { Array(Int64).new(5, Int64::MAX) }

  q = PriQueue({Int64, Button, Button}).new
  dists = Hash({Button, Button}, Int64).new(Int64::MAX)

  1.upto(25) do |k|
    Button.each do |b1|
      Button.each do |b2|
        q.clear
        q.push({0_i64, b1, Button::Act})
        dists.clear
        dists[{b1, Button::Act}] = 1
        while cur = q.pop?
          d, cur_b, cur_bctrl = cur
          break if cur_b == b2 && cur_bctrl == Button::Act
          Button.each do |nxt_bctrl|
            c = cost[cur_bctrl.value][nxt_bctrl.value]
            nxt_b = try_press(cur_b, nxt_bctrl) || next
            if d + c < dists[{nxt_b, nxt_bctrl}]
              dists[{nxt_b, nxt_bctrl}] = d + c
              q.push({d + c, nxt_b, nxt_bctrl})
            end
          end
        end
        nxtcost[b1.value][b2.value] = dists[{cur_b, cur_bctrl}]
      end
    end

    cost, nxtcost = nxtcost, cost

    next unless k == 2 || k == 25

    num_q = PriQueue({Int64, Pnt, Button}).new
    num_dists = Hash({Pnt, Button}, Int64).new(Int64::MAX)

    lines.each do |line|
      sum = 0_i64
      cur = {Pnt[3, 2], Button::Act}
      line.each_char do |ch|
        t = case ch
            when '0' then Pnt[3, 1]
            when '1' then Pnt[2, 0]
            when '2' then Pnt[2, 1]
            when '3' then Pnt[2, 2]
            when '4' then Pnt[1, 0]
            when '5' then Pnt[1, 1]
            when '6' then Pnt[1, 2]
            when '7' then Pnt[0, 0]
            when '8' then Pnt[0, 1]
            when '9' then Pnt[0, 2]
            when 'A' then Pnt[3, 2]
            else          raise "Invalid character #{ch}"
            end

        num_q.clear
        num_q.push({0_i64, cur[0], cur[1]})
        num_dists.clear
        num_dists[cur] = 0
        while num_cur = num_q.pop?
          d, cur_pos, cur_bctrl = num_cur
          if cur_pos == t && cur_bctrl == Button::Act
            sum += d
            cur = {cur_pos, cur_bctrl}
            break
          end

          Button.each do |nxt_bctrl|
            c = cost[cur_bctrl.value][nxt_bctrl.value]
            nxt_pos = try_press(cur_pos, nxt_bctrl) || next
            if d + c < num_dists[{nxt_pos, nxt_bctrl}]
              num_dists[{nxt_pos, nxt_bctrl}] = d + c
              num_q.push({d + c, nxt_pos, nxt_bctrl})
            end
          end
        end
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
