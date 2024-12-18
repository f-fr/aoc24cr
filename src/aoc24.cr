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

# run all days and collect results
times = Hash(Int32, Float64).new(Float64::INFINITY)
results = days.compact_map do |runner|
  next unless day.nil? || runner.day == day
  next unless version.nil? || runner.version == version
  File.open("input/%02d/input1.txt" % {runner.day}, "r") do |file|
    result = {0i64, 0i64}
    time = 0.0
    mem = Benchmark.memory {
      time = Benchmark.measure { result = runner.run(file) }.real
    }

    times.update(runner.day) { |v| {v, time}.min }

    {
      runner.day.to_s,
      runner.version.to_s,
      result[0].to_s, result[1].to_s,
      "%.3f" % {time},
      "%.3f" % {mem / 1024},
    }
  end
end

total_time = times.each_value.sum

# output the results
table_header = {"day", "version", "part1", "part2", "time (ms)", "mem (kb)"}
ws = results.map(&.map(&.size))
ws << table_header.map(&.size) if refresh_table
ws = ws.transpose.map { |col| {3, col.max}.max }

unless refresh_table
  fmt = "day: %#{ws[0]}s %-#{ws[1]}s part1: %#{ws[2]}s  part2: %#{ws[3]}s  time: %#{ws[4]}s  mem: %#{ws[5]}sK\n"
  results.each do |res|
    res = res.to_a
    res[1] = res[1] == "1" ? "" : "v#{res[1]}"
    printf fmt, res
  end
  puts "Total time: %.3f" % {total_time}
else
  cpu = if Crystal::TARGET_TRIPLE.starts_with?("x86_64")
          "AMD Ryzen 5 Pro 7530U"
        else
          "RasPi2 ARMv7 Processor rev 5"
        end

  readme = File.read_lines("README.md")
  re_table = /\s*\*\*#{Regex.literal(cpu)}/
  tblend = readme.index(&.strip.starts_with?(re_table))
  raise "No table found in README.md" unless tblend
  tblbeg = tblend - 1

  # skip empty lines and total time
  while tblbeg > 0 && (readme[tblbeg].strip.empty? || readme[tblbeg].starts_with?(/\s*Total time/))
    tblbeg -= 1
  end

  # skip table
  if tblbeg > 0 && readme[tblbeg].starts_with?(/\s*\|/)
    tblbeg -= 1
    while tblbeg > 0 && readme[tblbeg].starts_with?(/\s*\|/)
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

  File.open("README.md", "w") do |new_readme|
    # write part above table
    readme.each.first(tblbeg).each { |l| new_readme.puts l }

    fmt = "  | " + ws.map { |w| "%#{w}s" }.join(" | ") + "|\n"
    # write table header
    new_readme.printf fmt, table_header
    new_readme << "  "
    ws.each_with_index do |w, i|
      new_readme << "|" << (i <= 1 ? ':' : '-')
      w.times { new_readme << '-' }
      new_readme << ':'
    end
    new_readme << "\n"

    # write table header
    results.each { |res| new_readme.printf fmt, res }

    # write table footer
    new_readme.printf "\n  Total time (ms): %.3f\n\n" % {total_time}
    new_readme.puts "  **#{cpu}**"

    # write rest of file
    readme.each.skip(tblend + 1).each { |l| new_readme.puts l }
  end
end
