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

private class MaxClique
  @max_size = 0
  getter max_clq = [] of Int32

  def initialize(@adj : Array(Array(Int32)))
  end

  def solve
    @adj.each_with_index do |nodes, fst|
      search(fst, nodes, 0, nodes.size + 1, Array.new(nodes.size, true))
    end
  end

  private def search(fst : Int32, nodes : Array(Int32), idx : Int32, sz : Int32, mask : Array(Bool))
    return if sz <= @max_size
    if idx == nodes.size
      # found better solution
      @max_size = sz
      @max_clq = [fst]
      @max_clq.concat(mask.each_with_index.select(&.[0]).map { |_, i| nodes[i] })
      return
    end

    return search(fst, nodes, idx + 1, sz, mask) unless mask[idx]

    # the current node may be used or not, try both
    # we start with keeping node `u = nodes[idx]`
    u = nodes[idx]
    orig_mask = mask.dup
    orig_sz = sz
    # remove all nodes not adjacent to `u`
    nodes.each_with_index.skip(idx + 1).each do |v, i|
      if mask[i] && !@adj[u].bsearch(&.>= v).try(&.== v)
        mask[i] = false
        sz -= 1
      end
    end
    search(fst, nodes, idx + 1, sz, mask)
    # now try without `u`
    mask = orig_mask
    sz = orig_sz - 1
    mask[idx] = false
    search(fst, nodes, idx + 1, sz, mask)
    mask[idx] = true # don't forget to reset the mask
  end
end

def run_day23(input) : {Int32, String}
  names = [] of String
  nodes = {} of String => Int32
  edges = [] of {Int32, Int32}
  input.each_line do |line|
    u, v = line.split('-')
    u = nodes.put_if_absent(u) { |n| names << n; names.size - 1 }
    v = nodes.put_if_absent(v) { |n| names << n; names.size - 1 }
    edges << {u, v}
  end
  n = nodes.size

  adj = Array.new(n) { [] of Int32 }
  edges.each { |u, v| adj[u] << v; adj[v] << u }
  adj.each(&.sort!)
  t_nodes = names.each_with_index.select(&.[0].starts_with?('t')).map(&.[1]).to_set

  cnt1, cnt2, cnt3 = 0, 0, 0
  t_nodes.each do |u|
    adj[u].each_combination(2, true) do |e|
      v, w = e
      next unless adj[v].bsearch(&.>= w).try(&.== w)
      case
      when t_nodes.includes?(v) && t_nodes.includes?(w) then cnt3 += 1
      when t_nodes.includes?(v) || t_nodes.includes?(w) then cnt2 += 1
      else                                                   cnt1 += 1
      end
    end
  end

  part1 = cnt1 + cnt2 // 2 + cnt3 // 3

  mq = MaxClique.new(adj)
  mq.solve

  part2 = mq.max_clq.map { |u| names[u] }.sort!.join(",")

  {part1, part2}
end
