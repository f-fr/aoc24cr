# Copyright (c) 2021-2022, 2024 Frank Fischer <frank-fischer@shadow-soft.de>
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

class PriQueue(T)
  @heap : Array(T)

  def initialize(*, capacity = 0)
    @heap = Array(T).new(capacity)
  end

  def empty? : Bool
    @heap.empty?
  end

  def clear
    @heap.clear
  end

  def size : Int32
    @heap.size
  end

  def push(value : T) : Void
    @heap << value
    upheap(@heap.size - 1)
  end

  private def upheap(idx : Int32)
    heap = @heap
    i = idx
    value = heap[idx]
    while i > 0
      j = (i - 1) // 2
      break if heap[j] <= value
      heap[i] = heap[j]
      i = j
    end
    heap[i] = value
  end

  def min? : T?
    @heap.empty? ? nil : @heap[0]
  end

  def pop? : T?
    heap = @heap
    return nil if heap.empty?

    value = heap[0]

    last = heap.pop
    unless heap.empty?
      i = 0
      loop do
        j = 2*i + 1
        k = j + 1
        break if j >= heap.size
        j = k if k < heap.size && heap[k] < heap[j]
        break if heap[j] >= last
        heap[i] = heap[j]
        i = j
      end
      heap[i] = last
    end

    value
  end
end
