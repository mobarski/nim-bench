# Bench

Simple benchmarking module for Nim.

## Example

```nim
import bench
import std/os

var b = new_bench("Test benchmark")
for i in 1..1000:
    sleep(1)
    b.done
b.report(item="run")
```

**output:**

```
Test benchmark:
  Time (avg ± stdev): 1.11 ms ± 0.14 µs
  Time (min … max):   1.05 ms … 1.18 ms
  Rate (avg): 899 runs/s
  Runs: 1000
```



## Installation

`nimble install https://github.com/mobarski/nim-bench`



## API



#### new_bench

`new_bench(label="Benchmark"): Bench`

Create new benchmark object with a given label.



#### done

`done(self: var Bench, items=1) `

Register successful run, which processed some items.



#### report

`report(self: Bench, item="item", skip=0)`

Print the statistics. You can skip some initial runs.



## Similar projects

- [stopwatch](https://gitlab.com/define-private-public/stopwatch)
- [timeit](https://github.com/ringabout/timeit)
- [criterion](https://github.com/disruptek/criterion)
- [nimbench](https://github.com/ivankoster/nimbench)

