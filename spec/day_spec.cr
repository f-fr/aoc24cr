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

require "spec"
require "../src/days.cr"

{% for m in @top_level.methods %}
  {% name = m.name %}
  {% if name =~ /^run_day(\d{2})(?:_\d+)?$/ %}
    {% day = name[7..7] == "0" ? name[8..8] : name[7..8] %}
    {% version = name =~ /\d+_\d+$/ ? name[10..] : 1 %}
    describe "day #{{{day}}} v#{{{version}}}" do
      Dir["#{File.dirname(__FILE__)}/../input/%02d/test*.txt" % {{{day}}}].each do |testname|
        if File.basename(testname) =~ /test_part(\d+)/
          part = $1.to_i
          File.open(testname, "r") do |f|
            expected = f.read_line[/^EXPECTED:\s*(\d+)\s*$/,1].to_i64
            result = {{name}}(f)
            it "should correctly solve part #{part}" do
              result[part-1].should eq(expected)
            end
          end
        else
          File.open(testname, "r") do |f|
            next unless f.read_line =~ /^EXPECTED:\s*(\d+)\s+(\d+)\s*$/
            expected1 = $1.to_i64
            expected2 = $2.to_i64
            result1, result2 = {{name}}(f)
            it "should correctly solve part 1" do
              result1.should eq(expected1)
            end
            it "should correctly solve part 2" do
              result2.should eq(expected2)
            end
          end
        end
      end
    end
  {% end %}
{% end %}
