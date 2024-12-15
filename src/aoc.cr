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

struct Pnt
  Up    = Pnt[-1, 0]
  Right = Pnt[0, 1]
  Down  = Pnt[1, 0]
  Left  = Pnt[0, -1]

  property i : Int32
  property j : Int32

  def initialize(@i : Int32, @j : Int32)
  end

  def self.[](i : Int32, j : Int32)
    new(i, j)
  end

  def <=>(other : Pnt)
    i == other.i && j == other.j
  end

  def +(other : Pnt)
    Pnt.new(i + other.i, j + other.j)
  end

  def -(other : Pnt)
    Pnt.new(i - other.i, j - other.j)
  end

  def up
    self + Up
  end

  def right
    self + Right
  end

  def down
    self + Down
  end

  def left
    self + Left
  end
end

# A simple grid class that can be indexed by `Pnt`.
class Grid(T)
  include Iterable({Int32, Int32, T})
  include Enumerable({Int32, Int32, T})

  def initialize(n : Int32, m : Int32, & : (Int32, Int32) -> T)
    @data = Array.new(n) { |i| Array.new(m) { |j| yield i, j } }
  end

  def initialize(n : Int32, m : Int32, value : T)
    @data = Array.new(n) { Array.new(m) { value.clone } }
  end

  def initialize(@data : Array(Array(T)))
  end

  def [](pos : Pnt) : T
    @data[pos.i][pos.j]
  end

  def []=(pos : Pnt, value : T)
    @data[pos.i][pos.j] = value
  end

  def [](i : Int32, j : Int32) : T
    @data[i][j]
  end

  def []=(i : Int32, j : Int32, value : T) : T
    @data[i][j] = value
  end

  # Access to a row
  def [](i : Int32) : Array(T)
    @data[i]
  end

  def n
    @data.size
  end

  def m
    @data[0]?.try(&.size) || 0
  end

  def find(value : T) : Pnt?
    each do |i, j, c|
      return Pnt[i, j] if c == value
    end
    nil
  end

  def each(& : {Int32, Int32, T} ->)
    @data.each_with_index do |row, i|
      row.each_with_index do |c, j|
        yield({i, j, c})
      end
    end
  end

  def each : Iterator({Int32, Int32, T})
    @data.each_with_index.flat_map do |row, i|
      row.each_with_index.map { |c, j| {i, j, c} }
    end
  end

  def map(& : (Int32, Int32, T) -> S) : Grid(S) forall S
    Grid(S).new(@data.map_with_index do |row, i|
      row.map_with_index do |c, j|
        yield i, j, c
      end
    end)
  end

  def each_row(& : Array(T) ->)
    @data.each { |row| yield row }
  end

  def each_row : Iterator(Array(T))
    @data.each
  end

  def self.read(input : IO) : Grid(Char)
    lines = input.each_line
    data = lines.take_while(&.empty?.!).map(&.chars).to_a
    Grid.new(data)
  end
end

def gcd_ext(a, b)
  r0 = a
  r1 = b
  s0 = 1
  s1 = 0
  t0 = 0
  t1 = 1
  while r1 != 0
    q = r0 // r1
    r2 = r0 % r1
    s2 = s0 - q * s1
    t2 = s0 - q * t1
    r0 = r1
    r1 = r2
    s0 = s1
    s1 = s2
    t0 = t1
    t1 = t2
  end
  {r0, s0, t0}
end

def crt(a : Indexable, m : Indexable)
  return nil if a.empty?

  return a[0] if a.size == 1

  a0 = a[0]
  m0 = m[0]

  (1...a.size).each do |i|
    g, s, _ = gcd_ext(m0, m[i])
    return nil if a0 % g != a[i] % g
    l = m0 * (m[i] // g)
    x = (a0 - (s * m0 * ((a0 - a[i]) // g))) % l
    a0 = x
    m0 = l
    # there should be a better way to ensure 0 <= a0 < m0
    while a0 < 0
      a0 += m0
    end
    while a0 >= m0
      a0 -= m0
    end
  end

  a0
end
