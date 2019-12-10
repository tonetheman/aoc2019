# thoughts on part2

Amp A -run until first output
- stop machine and save state somewhere and return state and output

Amp B - take input just recv'd from (a) and run until first output
- stop machine and save state somewhere and return state and output

Amp C - take input just recv'd from (b) and run until first output
- stop machine and save state somewhere and return state and output

Amp D - take input from recv'd from (c) and run until first output
- stop maachine and save state somewhere and return state and output

Amp E - take input from recv'd from (d) and run until first output
- stop machine and save state somewhere and return state and output

Amp A - restore state and use input from (e)
- continue to run until output statement
- save state and return state and output

- eventually Amp E will halt with 99
