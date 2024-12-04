# /usr/bin/env crystal

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

require "benchmark"
require "./days"

abstract class DayRunner
  abstract def day : Int32
  abstract def run(input : IO) : {Int64, Int64}
end

days = [] of DayRunner

# collect all runner methods
{% for m in @top_level.methods %}
  {% if m.name.id.stringify =~ /^run_day(\d+)$/ %}
    class Day{{m.name}}Runner < DayRunner
      def day : Int32
        {{m.name.id.stringify}}[/0*(\d+)/,1].to_i
      end

      def run(input : IO) : {Int64, Int64}
        {{m.name}}(input)
      end
    end
    days << Day{{m.name}}Runner.new
  {% end %}
{% end %}

days.sort_by!(&.day)

total_time = 0
days.each do |runner|
  File.open("input/%02d/input1.txt" % {runner.day}, "r") do |file|
    result = {0i64, 0i64}
    bm = Benchmark.measure { result = runner.run(file) }
    puts "day: %2d     part1: %10d  part2: %10d   time:%.3f" % {runner.day, result[0], result[1], bm.real}
    total_time += bm.real
  end
end
puts "Total time: %.3f" % {total_time}
