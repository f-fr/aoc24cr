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
require "./days/*"

abstract class DayRunner
  abstract def day : Int32
  abstract def run(input : IO) : {Int64, Int64}
end

days = [] of DayRunner

# collect all runner methods
{% for m in @top_level.methods %}
  {% name = m.name %}
  {% if name =~ /^run_day(\d{2})(?:_\d+)?$/ %}
    {% day = name[7..7] == "0" ? name[8..8] : name[7..8] %}
    {% version = name =~ /\d+_\d+$/ ? name[10..] : 1 %}
    class Day{{day}}v{{version}}Runner < DayRunner
      def day : Int32
        {{day}}.to_i
      end

      def version : Int32
        {{version}}.to_i
      end

      def run(input : IO) : {Int64, Int64}
        {{name}}(input)
      end
    end
    days << Day{{day}}v{{version}}Runner.new
  {% end %}
{% end %}

days.sort_by! { |r| {r.day, r.version}.as({Int32, Int32}) }

times = Hash(Int32, Float64).new(Float64::INFINITY)
days.each do |runner|
  File.open("input/%02d/input1.txt" % {runner.day}, "r") do |file|
    result = {0i64, 0i64}
    time = 0.0
    mem = Benchmark.memory {
      time = Benchmark.measure { result = runner.run(file) }.real
    }
    puts "day: %2d %3s part1: %16d  part2: %16d  time:%.3f  mem:%8.2fK" % {
      runner.day,
      runner.version == 1 ? "" : "v#{runner.version}",
      result[0], result[1],
      time,
      mem / 1024,
    }
    times.update(runner.day) { |v| {v, time}.min }
  end
end
total_time = times.each_value.sum
puts "Total time: %.3f" % {total_time}
