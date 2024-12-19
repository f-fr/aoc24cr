# aoc24cr
My Advent of Code 2024 solutions in Crystal

## Running times

The following tables list the running times for all days on different
platforms (x86_64, raspi2). The total running time is the sum of the
*fastest* version for each day.

  | day | version |             part1 |           part2 | time (ms) | mem (kb)|
  |:---:|:-------:|------------------:|----------------:|----------:|---------:
  |   1 |       1 |           1223326 |        21070419 |     0.000 |  335.234|
  |   2 |       1 |               432 |             488 |     0.001 |  767.219|
  |   2 |       2 |               432 |             488 |     0.000 |  418.266|
  |   3 |       1 |         185797128 |        89798695 |     0.000 |  154.266|
  |   4 |       1 |              2534 |            1866 |     0.001 |   85.328|
  |   4 |       2 |              2534 |            1866 |     0.001 |   81.422|
  |   5 |       1 |              5651 |            4743 |     0.000 |  413.781|
  |   5 |       2 |              5651 |            4743 |     0.000 |  367.094|
  |   6 |       1 |              4982 |            1663 |     0.009 |  970.547|
  |   6 |       2 |              4982 |            1663 |     0.004 | 1127.219|
  |   7 |       1 |    66343330034722 | 637696070419031 |     0.001 |  768.859|
  |   8 |       1 |               354 |            1263 |     0.000 |  155.734|
  |   9 |       1 |     6461289671426 |   6488291456470 |     0.001 |  429.641|
  |  10 |       1 |               617 |            1477 |     0.000 |   96.703|
  |  11 |       1 |            235850 | 279903140844645 |     0.005 |  771.797|
  |  12 |       1 |           1370100 |          818286 |     0.001 |  393.891|
  |  13 |       1 |             27105 | 101726882250942 |     0.001 |  447.562|
  |  14 |       1 |         218619120 |            7055 |     0.041 |  520.547|
  |  14 |       2 |         218619120 |            7055 |     0.000 |  409.844|
  |  15 |       1 |           1406392 |         1429013 |     0.001 |  425.250|
  |  15 |       2 |           1406392 |         1429013 |     0.001 |  329.953|
  |  16 |       1 |             98484 |             531 |     0.002 | 1048.000|
  |  16 |       2 |             98484 |             531 |     0.007 | 3231.812|
  |  17 |       1 | 2,3,4,7,5,7,3,0,7 | 190384609508367 |     0.000 |   49.000|
  |  18 |       1 |               252 |            5,60 |     0.001 |  785.312|

  Total time (ms): 0.018

  | day | version |             part1 |           part2 | time (ms) | mem (kb)|
  |:---:|:-------:|------------------:|----------------:|----------:|---------:
  |   1 |       1 |           1223326 |        21070419 |     0.000 |  335.234|
  |   2 |       1 |               432 |             488 |     0.001 |  767.219|
  |   2 |       2 |               432 |             488 |     0.000 |  418.266|
  |   3 |       1 |         185797128 |        89798695 |     0.000 |  154.266|
  |   4 |       1 |              2534 |            1866 |     0.001 |   85.328|
  |   4 |       2 |              2534 |            1866 |     0.001 |   81.422|
  |   5 |       1 |              5651 |            4743 |     0.000 |  413.781|
  |   5 |       2 |              5651 |            4743 |     0.000 |  367.094|
  |   6 |       1 |              4982 |            1663 |     0.009 |  970.547|
  |   6 |       2 |              4982 |            1663 |     0.003 | 1127.219|
  |   7 |       1 |    66343330034722 | 637696070419031 |     0.001 |  768.859|
  |   8 |       1 |               354 |            1263 |     0.000 |  155.734|
  |   9 |       1 |     6461289671426 |   6488291456470 |     0.001 |  429.641|
  |  10 |       1 |               617 |            1477 |     0.000 |   97.578|
  |  11 |       1 |            235850 | 279903140844645 |     0.005 |  771.797|
  |  12 |       1 |           1370100 |          818286 |     0.001 |  393.031|
  |  13 |       1 |             27105 | 101726882250942 |     0.000 |  446.484|
  |  14 |       1 |         218619120 |            7055 |     0.041 |  519.703|
  |  14 |       2 |         218619120 |            7055 |     0.000 |  412.875|
  |  15 |       1 |           1406392 |         1429013 |     0.001 |  424.688|
  |  15 |       2 |           1406392 |         1429013 |     0.001 |  326.453|
  |  16 |       1 |             98484 |             531 |     0.003 | 1048.172|
  |  16 |       2 |             98484 |             531 |     0.008 | 3231.656|
  |  17 |       1 | 2,3,4,7,5,7,3,0,7 | 190384609508367 |     0.000 |   48.938|
  |  18 |       1 |               252 |            5,60 |     0.001 |  787.016|

  Total time (ms): 0.018

  | day | version |             part1 |           part2 | time (ms) | mem (kb)|
  |:---:|:-------:|------------------:|----------------:|----------:|---------:
  |   1 |       1 |           1223326 |        21070419 |     0.000 |  338.891|
  |   2 |       1 |               432 |             488 |     0.001 |  768.344|
  |   2 |       2 |               432 |             488 |     0.000 |  417.531|
  |   3 |       1 |         185797128 |        89798695 |     0.000 |  156.672|
  |   4 |       1 |              2534 |            1866 |     0.001 |   85.328|
  |   4 |       2 |              2534 |            1866 |     0.001 |   81.422|
  |   5 |       1 |              5651 |            4743 |     0.000 |  415.484|
  |   5 |       2 |              5651 |            4743 |     0.000 |  366.078|
  |   6 |       1 |              4982 |            1663 |     0.009 |  970.766|
  |   6 |       2 |              4982 |            1663 |     0.004 | 1128.141|
  |   7 |       1 |    66343330034722 | 637696070419031 |     0.001 |  768.875|
  |   8 |       1 |               354 |            1263 |     0.000 |  155.500|
  |   9 |       1 |     6461289671426 |   6488291456470 |     0.001 |  429.859|
  |  10 |       1 |               617 |            1477 |     0.000 |   96.781|
  |  11 |       1 |            235850 | 279903140844645 |     0.005 |  771.797|
  |  12 |       1 |           1370100 |          818286 |     0.001 |  393.625|
  |  13 |       1 |             27105 | 101726882250942 |     0.000 |  443.969|
  |  14 |       1 |         218619120 |            7055 |     0.041 |  519.812|
  |  14 |       2 |         218619120 |            7055 |     0.000 |  415.141|
  |  15 |       1 |           1406392 |         1429013 |     0.001 |  430.562|
  |  15 |       2 |           1406392 |         1429013 |     0.001 |  327.266|
  |  16 |       1 |             98484 |             531 |     0.003 | 1048.031|
  |  16 |       2 |             98484 |             531 |     0.007 | 3231.812|
  |  17 |       1 | 2,3,4,7,5,7,3,0,7 | 190384609508367 |     0.000 |   45.000|
  |  18 |       1 |               252 |            5,60 |     0.001 |  788.062|
  |  18 |       2 |               252 |            5,60 |     0.001 |  987.234|
  |  18 |       3 |               252 |            5,60 |     0.001 |  770.453|
  |  19 |       1 |               304 | 705756472327497 |     0.001 |  326.969|

  Total time (ms): 0.019

  **AMD Ryzen 5 Pro 7530U**

  | day | version |             part1 |           part2 | time (ms) | mem (kb)|
  |:---:|:-------:|------------------:|----------------:|----------:|---------:
  |   1 |       1 |           1223326 |        21070419 |     0.013 |  279.469|
  |   2 |       1 |               432 |             488 |     0.023 |  540.430|
  |   2 |       2 |               432 |             488 |     0.010 |  318.188|
  |   3 |       1 |         185797128 |        89798695 |     0.005 |  108.156|
  |   4 |       1 |              2534 |            1866 |     0.022 |   84.117|
  |   4 |       2 |              2534 |            1866 |     0.020 |   82.430|
  |   5 |       1 |              5651 |            4743 |     0.011 |  339.961|
  |   5 |       2 |              5651 |            4743 |     0.009 |  283.008|
  |   6 |       1 |              4982 |            1663 |     0.153 |  957.828|
  |   6 |       2 |              4982 |            1663 |     0.063 | 1105.156|
  |   7 |       1 |    66343330034722 | 637696070419031 |     0.048 |  510.234|
  |   8 |       1 |               354 |            1263 |     0.002 |  143.125|
  |   9 |       1 |     6461289671426 |   6488291456470 |     0.012 |  428.930|
  |  10 |       1 |               617 |            1477 |     0.002 |   93.242|
  |  11 |       1 |            235850 | 279903140844645 |     0.122 |  768.797|
  |  12 |       1 |           1370100 |          818286 |     0.012 |  384.898|
  |  13 |       1 |             27105 | 101726882250942 |     0.019 |  311.148|
  |  14 |       1 |         218619120 |            7055 |     1.016 |  381.070|
  |  14 |       2 |         218619120 |            7055 |     0.020 |  254.039|
  |  15 |       1 |           1406392 |         1429013 |     0.010 |  387.914|
  |  15 |       2 |           1406392 |         1429013 |     0.014 |  301.492|
  |  16 |       1 |             98484 |             531 |     0.060 | 1026.203|
  |  16 |       2 |             98484 |             531 |     0.134 | 3233.836|
  |  17 |       1 | 2,3,4,7,5,7,3,0,7 | 190384609508367 |     0.001 |   35.648|
  |  18 |       1 |               252 |            5,60 |     0.018 |  595.844|

  Total time (ms): 0.446

  | day | version |             part1 |           part2 | time (ms) | mem (kb)|
  |:---:|:-------:|------------------:|----------------:|----------:|---------:
  |   1 |       1 |           1223326 |        21070419 |     0.014 |  279.469|
  |   2 |       1 |               432 |             488 |     0.028 |  540.430|
  |   2 |       2 |               432 |             488 |     0.015 |  318.188|
  |   3 |       1 |         185797128 |        89798695 |     0.008 |  108.156|
  |   4 |       1 |              2534 |            1866 |     0.023 |   84.117|
  |   4 |       2 |              2534 |            1866 |     0.020 |   82.430|
  |   5 |       1 |              5651 |            4743 |     0.011 |  339.961|
  |   5 |       2 |              5651 |            4743 |     0.009 |  283.008|
  |   6 |       1 |              4982 |            1663 |     0.156 |  957.828|
  |   6 |       2 |              4982 |            1663 |     0.063 | 1105.156|
  |   7 |       1 |    66343330034722 | 637696070419031 |     0.048 |  510.234|
  |   8 |       1 |               354 |            1263 |     0.002 |  143.125|
  |   9 |       1 |     6461289671426 |   6488291456470 |     0.012 |  428.930|
  |  10 |       1 |               617 |            1477 |     0.002 |   93.242|
  |  11 |       1 |            235850 | 279903140844645 |     0.122 |  768.797|
  |  12 |       1 |           1370100 |          818286 |     0.013 |  384.898|
  |  13 |       1 |             27105 | 101726882250942 |     0.020 |  311.148|
  |  14 |       1 |         218619120 |            7055 |     1.017 |  381.070|
  |  14 |       2 |         218619120 |            7055 |     0.020 |  254.039|
  |  15 |       1 |           1406392 |         1429013 |     0.010 |  387.914|
  |  15 |       2 |           1406392 |         1429013 |     0.014 |  301.492|
  |  16 |       1 |             98484 |             531 |     0.062 | 1026.203|
  |  16 |       2 |             98484 |             531 |     0.137 | 3233.836|
  |  17 |       1 | 2,3,4,7,5,7,3,0,7 | 190384609508367 |     0.001 |   35.648|
  |  18 |       1 |               252 |            5,60 |     0.020 |  595.844|

  Total time (ms): 0.460

  | day | version |             part1 |           part2 | time (ms) | mem (kb)|
  |:---:|:-------:|------------------:|----------------:|----------:|---------:
  |   1 |       1 |           1223326 |        21070419 |     0.012 |  279.625|
  |   2 |       1 |               432 |             488 |     0.027 |  536.711|
  |   2 |       2 |               432 |             488 |     0.015 |  320.039|
  |   3 |       1 |         185797128 |        89798695 |     0.005 |  110.094|
  |   4 |       1 |              2534 |            1866 |     0.022 |   86.195|
  |   4 |       2 |              2534 |            1866 |     0.021 |   78.570|
  |   5 |       1 |              5651 |            4743 |     0.011 |  340.953|
  |   5 |       2 |              5651 |            4743 |     0.008 |  277.688|
  |   6 |       1 |              4982 |            1663 |     0.149 |  857.719|
  |   6 |       2 |              4982 |            1663 |     0.061 | 1009.531|
  |   7 |       1 |    66343330034722 | 637696070419031 |     0.049 |  514.945|
  |   8 |       1 |               354 |            1263 |     0.002 |  146.070|
  |   9 |       1 |     6461289671426 |   6488291456470 |     0.012 |  428.977|
  |  10 |       1 |               617 |            1477 |     0.002 |   92.539|
  |  11 |       1 |            235850 | 279903140844645 |     0.122 |  768.797|
  |  12 |       1 |           1370100 |          818286 |     0.012 |  344.773|
  |  13 |       1 |             27105 | 101726882250942 |     0.020 |  302.977|
  |  14 |       1 |         218619120 |            7055 |     1.024 |  358.844|
  |  14 |       2 |         218619120 |            7055 |     0.018 |  259.172|
  |  15 |       1 |           1406392 |         1429013 |     0.011 |  382.047|
  |  15 |       2 |           1406392 |         1429013 |     0.013 |  297.422|
  |  16 |       1 |             98484 |             531 |     0.059 |  890.250|
  |  16 |       2 |             98484 |             531 |     0.133 | 3220.648|
  |  17 |       1 | 2,3,4,7,5,7,3,0,7 | 190384609508367 |     0.001 |   35.648|
  |  18 |       1 |               252 |            5,60 |     0.018 |  604.305|
  |  18 |       2 |               252 |            5,60 |     0.019 |  686.352|
  |  18 |       3 |               252 |            5,60 |     0.019 |  629.531|
  |  19 |       1 |               304 | 705756472327497 |     0.011 |  241.203|

  Total time (ms): 0.459

  **RasPi2 ARMv7 Processor rev 5**
