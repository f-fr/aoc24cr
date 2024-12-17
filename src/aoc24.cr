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

require "option_parser"
require "benchmark"
require "./aoc"
require "./days/*"

abstract class DayRunner
  abstract def day : Int32
  abstract def run(input : IO)
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

      def run(input : IO)
        {{name}}(input)
      end
    end
    days << Day{{day}}v{{version}}Runner.new
  {% end %}
{% end %}

days.sort_by! { |r| {r.day, r.version}.as({Int32, Int32}) }

version = nil
refresh_table = false

OptionParser.parse do |parser|
  parser.banner = "Usage: aoc [parameters] [DAY]"
  parser.on("-v VERSION", "--version=VERSION", "Run only specific version") { |v| version = v.to_i }
  parser.on("-r", "--refresh-table", "Refresh README.md table") { refresh_table = true }
  parser.on("-h", "--help", "Show this help") { puts parser; exit }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option"
    STDERR.puts parser
    exit(1)
  end
end

day = ARGV.shift?.try(&.to_i)

if table = refresh_table ? String::Builder.new : nil
  line = "| day | version | %-17s | %-15s | time (ms)| mem (kb) |" % {"part1", "part2"}
  table << "  " << line << "\n"
  table << "  |" << line.split('|', remove_empty: true).map_with_index do |s, i|
    if i <= 1
      ":" + "-" * (s.size - 2) + ":"
    else
      "-" * (s.size - 1) + ":"
    end
  end.join('|') << "|\n"
end

times = Hash(Int32, Float64).new(Float64::INFINITY)
days.each do |runner|
  next unless day.nil? || runner.day == day
  next unless version.nil? || runner.version == version
  File.open("input/%02d/input1.txt" % {runner.day}, "r") do |file|
    result = {0i64, 0i64}
    time = 0.0
    mem = Benchmark.memory {
      time = Benchmark.measure { result = runner.run(file) }.real
    }

    unless table
      puts "day: %2d %-3s part1: %17s  part2: %16s  time:%.3f  mem:%8.2fK" % {
        runner.day,
        runner.version == 1 ? "" : "v#{runner.version}",
        result[0].to_s, result[1].to_s,
        time,
        mem / 1024,
      }
    else
      table << "  | %3d | %7d | %17s | %15s | %8.3f | %8.2f |\n" % {
        runner.day,
        runner.version,
        result[0].to_s, result[1].to_s,
        time,
        mem / 1024,
      }
    end

    times.update(runner.day) { |v| {v, time}.min }
  end
end
total_time = times.each_value.sum

unless table
  puts "Total time: %.3f" % {total_time}
else
  cpu = if Crystal::TARGET_TRIPLE.starts_with?("x86_64")
          "AMD Ryzen 5 Pro 7530U"
        else
          "RasPi2 ARMv7 Processor rev 5"
        end
  table << "\n  Total time: %.3f\n\n" % {total_time}
  table << "  **#{cpu}**"

  readme = File.read_lines("README.md")
  tblend = readme.index(&.strip.starts_with?("**#{cpu}"))
  raise "No table found in README.md" unless tblend
  tblbeg = tblend - 1

  # skip empty lines and total time
  while tblbeg > 0 && (readme[tblbeg].strip.empty? || readme[tblbeg].strip.starts_with?("Total time:"))
    tblbeg -= 1
  end

  # skip table
  if tblbeg > 0 && readme[tblbeg].strip.starts_with?('|')
    tblbeg -= 1
    while tblbeg > 0 && readme[tblbeg].strip.starts_with?('|')
      tblbeg -= 1
    end
    tblbeg += 1
  else
    # no real table found, insert an empty line
    tblbeg += 1
    readme.insert(tblbeg, "")
    tblbeg += 1
    tblend += 1
  end

  # remove old table except for caption
  readme.delete_at(tblbeg..tblend)

  # insert new table
  readme.insert_all(tblbeg, table.to_s.split("\n"))
  File.write("README.md", readme.join("\n"))
end
