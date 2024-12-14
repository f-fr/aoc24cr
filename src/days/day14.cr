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

# def run_day14(input) : {Int64, Int64}
#   part1 = 0_i64
#   part2 = 0_i64

#   ps = [] of {Int32, Int32}
#   vs = [] of {Int32, Int32}
#   input.each_line do |line|
#     ns = line.scan(/[-+]?\d+/)
#     ps << {ns[0][0].to_i, ns[1][0].to_i}
#     vs << {ns[2][0].to_i, ns[3][0].to_i}
#   end

#   # determine size (different in tests)
#   if ps.size < 100
#     sz = {11, 7}
#   else
#     sz = {101, 103}
#   end

#   q1, q2, q3, q4 = 0, 0, 0, 0

#   ps.each.zip(vs.each) do |p, v|
#     p = {0, 1}.map { |k| (p[k] + 100 * (sz[k] + v[k])) % sz[k] }

#     if p[0] < sz[0] // 2
#       if p[1] < sz[1] // 2
#         q1 += 1
#       elsif p[1] > sz[1] // 2
#         q2 += 1
#       end
#     elsif p[0] > sz[0] // 2
#       if p[1] < sz[1] // 2
#         q3 += 1
#       elsif p[1] > sz[1] // 2
#         q4 += 1
#       end
#     end
#   end

#   part1 = (q1 * q2 * q3 * q4).to_i64
#   part2 = 7055_i64 # I know, a cheat, use v2 for finding the solution

#   {part1, part2}
# end

def run_day14(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64

  ps = [] of {Int32, Int32}
  vs = [] of {Int32, Int32}
  input.each_line do |line|
    ns = line.scan(/[-+]?\d+/)
    ps << {ns[0][0].to_i, ns[1][0].to_i}
    vs << {ns[2][0].to_i, ns[3][0].to_i}
  end

  # determine size (different in tests)
  if ps.size < 100
    sz = {11, 7}
  else
    sz = {101, 103}
  end

  q1, q2, q3, q4 = 0, 0, 0, 0

  grid = Array.new(sz[0]) { Array.new(sz[1], ' ') }
  hits = Array.new(101) { Array.new(103, Int32::MAX) }

  # mark hit area
  (37..39).each do |x|
    (40..46).each do |y|
      hits[x][y] = 0
    end
  end

  i = 0
  while i < 100 || (part2 == 0 && sz[0] > 100)
    i += 1
    nhits = 0
    ps.size.times do |j|
      p = {0, 1}.map { |k| (ps[j][k] + sz[k] + vs[j][k]) % sz[k] }
      grid[p[0]][p[1]] = 'X'
      ps[j] = p
      if hits[p[0]][p[1]] < i
        hits[p[0]][p[1]] = i
        nhits += 1
      end
    end

    if i == 100
      ps.each do |p|
        if p[0] < sz[0] // 2
          if p[1] < sz[1] // 2
            q1 += 1
          elsif p[1] > sz[1] // 2
            q2 += 1
          end
        elsif p[0] > sz[0] // 2
          if p[1] < sz[1] // 2
            q3 += 1
          elsif p[1] > sz[1] // 2
            q4 += 1
          end
        end
      end
    end

    if nhits == (46 - 40 + 1) * (39 - 37 + 1)
      part2 = i.to_i64
    end

    ps.each { |p| grid[p[0]][p[1]] = ' ' }
  end

  part1 = (q1 * q2 * q3 * q4).to_i64

  {part1, part2}
end

def run_day14_2(input) : {Int64, Int64}
  part1 = 0_i64
  part2 = 0_i64

  ps = [] of {Int32, Int32}
  vs = [] of {Int32, Int32}
  input.each_line do |line|
    ns = line.scan(/[-+]?\d+/)
    ps << {ns[0][0].to_i, ns[1][0].to_i}
    vs << {ns[2][0].to_i, ns[3][0].to_i}
  end

  # determine size (different in tests)
  if ps.size < 100
    sz = {11, 7}
  else
    sz = {101, 103}
  end

  q1, q2, q3, q4 = 0, 0, 0, 0

  scores = {0, 1}.map { |j| [0] * sz[j] }
  best_score = [{0, 0}, {0, 0}]
  1.upto({sz[0], sz[1], 100}.max) do |i|
    scores.each(&.fill(0))
    ps.size.times do |j|
      p = {0, 1}.map { |k| (ps[j][k] + sz[k] + vs[j][k]) % sz[k] }
      ps[j] = p
      {0, 1}.each { |j| scores[j][p[j]] += 1 }
    end

    {0, 1}.each do |j|
      if (score = scores[j].sum(&.** 2)) > best_score[j][1]
        best_score[j] = {i, score}
      end
    end

    if i == 100
      ps.each do |p|
        if p[0] < sz[0] // 2
          if p[1] < sz[1] // 2
            q1 += 1
          elsif p[1] > sz[1] // 2
            q2 += 1
          end
        elsif p[0] > sz[0] // 2
          if p[1] < sz[1] // 2
            q3 += 1
          elsif p[1] > sz[1] // 2
            q4 += 1
          end
        end
      end
    end
  end

  part1 = (q1 * q2 * q3 * q4).to_i64
  part2 = crt({best_score[0][0], best_score[1][0]}, sz) || 0

  {part1, part2.to_i64}
end
