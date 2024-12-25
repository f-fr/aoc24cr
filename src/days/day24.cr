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

private enum NodeType
  AND; OR; XOR; IN
end

private class Node
  property name : String
  property type : NodeType
  property input1 = -1
  property input2 = -1
  property outputs = [] of Int32

  def initialize(@name : String, @type : NodeType); end
end

def run_day24(input) : {UInt64, Int32}
  names = Hash(String, Int32).new
  nodes = [] of Node

  input.each_line do |line|
    break if line.empty?
    name, v = line.split(/\s*:\s*/)
    if u = names[name]?
      node = nodes[u]
    else
      names[name] = names.size
      node = Node.new(name, NodeType::IN)
      nodes << node
    end
    node.input1 = v == "1" ? 1 : 0
    node.input2 = node.input1
  end

  input.each_line do |line|
    raise "Invalid line: #{line}" unless line =~ /^\s*(\S+)\s+(AND|OR|XOR)\s+(\S+)\s*->\s*(\S+)\s*$/
    uname = $1
    op = $2
    vname = $3
    wname = $4
    u, v, w = {uname, vname, wname}.map do |name|
      if id = names[name]?
        id
      else
        names[name] = names.size
        node = Node.new(name, NodeType::IN)
        nodes << node
        names.size - 1
      end
    end

    nodes[u].outputs << w
    nodes[v].outputs << w

    nodes[w].type = case op
                    when "AND" then NodeType::AND
                    when "OR"  then NodeType::OR
                    when "XOR" then NodeType::XOR
                    else            raise "Invalid gate: #{op}"
                    end
    nodes[w].input1 = u
    nodes[w].input2 = v
  end
  n = names.size

  # topsort
  degs = nodes.map { |node| node.type.in? ? 0 : 2 }
  q = nodes.each_with_index.select(&.[0].type.in?).map(&.[1]).to_a
  toporder = [] of Int32
  n.times do
    raise "Loop detected" unless v = q.shift?
    toporder << v
    nodes[v].outputs.each do |w|
      degs[w] -= 1
      q << w if degs[w] == 0
    end
  end

  # evaluate in top order
  values = Array.new(n, false)
  toporder.each do |u|
    case nodes[u].type
    in NodeType::IN  then values[u] = nodes[u].input1 != 0
    in NodeType::AND then values[u] = values[nodes[u].input1] && values[nodes[u].input2]
    in NodeType::OR  then values[u] = values[nodes[u].input1] || values[nodes[u].input2]
    in NodeType::XOR then values[u] = values[nodes[u].input1] != values[nodes[u].input2]
    end
  end

  # collect the results
  res = nodes.each.zip(values.each).select(&.[0].name.starts_with?('z')).to_a
  res.sort_by!(&.[0].name)
  part1 = res.reverse_each.reduce(0_u64) { |acc, z| (acc << 1) | (z[1] ? 1 : 0) }

  {part1, 0}
end
