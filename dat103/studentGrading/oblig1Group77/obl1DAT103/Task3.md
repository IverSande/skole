# Task 3 #

## First Come First Serve Scheduler ##

| Task | Time to Wait|
| :---: | :---: |
| T1  |  0 |
| T2  |  1 |
| T3  |  3 |
| T4  |  7 |
| T5  | 13 |
| T6  | 10 |
| T7  | 18 |
| T8  | 24 |
| T9  | 28 |
| T10 | 30 |
| **sum:** | 134 |

Algorithm 1:
`T (when scheduled) - T (when added)`

**ex:**
T4:
`7 - 0 = 7`
T6:
`21 - 11 = 10`

## Round Robin Scheduler ##

| Task | Wait steps | Time to Wait Sum |
| :---: | :---: | :---: |
| T1  | 0 | 0 |
| T2  | 1 | 1 |
| T3  | 3 + 7 | 10 |
| T4  | 6 + 5 | 11 |
| T5  | 9 + 17 + 8 | 34 |
| T6  | 5 + 13 + 7 | 25 |
| T7  | 8 + 13 | 21 |
| T8  | 11 + 13 | 24 |
| T9  | 24 | 24 |
| T10 | 26 | 26 |
| **sum:** |  | 176 |

Algorithm 2 - Wait step calculation:
`T (when scheduled) - T (when previously scheduled)`
The `T (when previously scheduled)` time should be the Time step when it was last scheduled before getting put back in queue.

Used together with algorithm from FCFS calculation.

Wait steps will then be:
`Algorithm 1 + Algorithm 2`
where Algorithm 2 will be repeated as many times as necessary.

**ex:**
T5:
`(9 - 0) + (28 - 9) + (38 - 30) = 9 + 17 + 8 = 34`
T8:
`(22 - 11) + (37 - 24) = 11 + 13 = 24`

## Answers ##

For the FCFS scheduler, task T10 had to wait the longest, for 30 steps, and task T1 waited the shortest, with 0 steps.

For the RR scheduler, task T5 waited the longest with 34 steps, and task T1 waited the shortest with 0 steps.

The average wait time for FCFS scheduler was **13.4**,
and the average for RR scheduler was **17.6**
