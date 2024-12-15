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
