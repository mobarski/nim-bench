# Bench

Simple benchmarking module for Nim.

## Example

```nim
import bench
import std/os

var b = new_bench("test benchmark")
for i in 1..1000:
    sleep(1)
    b.done
b.report
```

**output:**

```
test benchmark:
  Time (avg ± stdev): 1.1 ms ± 0.2 µs
  Time (min … max):   1.0 ms … 1.3 ms
  Rate (avg ± stdev): 0.9K items/s
  Runs: 1000
```



## Installation

`nimble install https://github.com/mobarski/nim-bench`



## API



#### new_bench

`new_bench(label=""): Bench`

Create new benchmark object with a given label.



#### done

`done(self: var Bench, items=1) `

Register successful run, which processed some items.



#### report

`report(self: Bench, skip=0)`

Print the statistics. You can skip some initial runs.



## Similar projects

- [stopwatch](https://gitlab.com/define-private-public/stopwatch)
- [timeit](https://github.com/ringabout/timeit)
- [criterion](https://github.com/disruptek/criterion)
- [nimbench](https://github.com/ivankoster/nimbench)

