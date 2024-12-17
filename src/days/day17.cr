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

private class VM
  getter prg
  property a : Int64 = 0
  property b : Int64 = 0
  property c : Int64 = 0

  def initialize(@prg : Array(UInt8))
    @ip = 0
  end

  private def combo(op : UInt8) : Int64
    case op
    when 0..3 then op.to_i64
    when 4    then @a
    when 5    then @b
    when 6    then @c
    else           raise "Invalid operand: #{op}"
    end
  end

  def run(stop_at_jump = false, & : UInt8 ->)
    ip = @ip
    prg = @prg
    while ip < prg.size
      case prg[ip]
      when 0 then @a = @a >> combo(prg[ip + 1])
      when 1 then @b ^= prg[ip + 1]
      when 2 then @b = combo(prg[ip + 1]) % 8
      when 3
        break if stop_at_jump
        if @a != 0
          ip = prg[ip + 1]
          next
        end
      when 4 then @b ^= @c
      when 5 then yield (combo(prg[ip + 1]) % 8).to_u8
      when 6 then @b = @a >> combo(prg[ip + 1])
      when 7 then @c = @a >> combo(prg[ip + 1])
      else        raise "Invalid opcode: #{prg[ip]}"
      end
      ip += 2
    end
  end

  def run
    outputs = [] of UInt8
    run { |value| outputs << value }
    outputs
  end
end

private def solve_part2(vm, idx = 0) : Array(Int64)
  rs = idx + 1 < vm.prg.size ? solve_part2(vm, idx + 1) : [0_i64]
  res = [] of Int64
  rs.each do |r|
    (0..7).each do |i|
      vm.a = (r << 3) | i
      vm.b = 0
      vm.c = 0
      vm.run(true) { |value| res << ((r << 3) | i) if value == vm.prg[idx] }
    end
  end
  res
end

def run_day17(input : IO) : {String, Int64}
  reg_a = (input.gets || "")[/\d+/].to_i64
  reg_b = (input.gets || "")[/\d+/].to_i64
  reg_c = (input.gets || "")[/\d+/].to_i64
  input.gets # empty line
  prg = (input.gets || "")[/:\s*(.*)/, 1].split(',').map(&.to_u8)

  vm = VM.new(prg)
  vm.a = reg_a
  vm.b = reg_b
  vm.c = reg_c

  part1 = vm.run.join(",")
  part2 = 0_i64
  part2 = solve_part2(vm)[0] if reg_a != 729 # skip in test case for part1

  {part1, part2}
end
