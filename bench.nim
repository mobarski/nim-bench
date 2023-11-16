import std/monotimes
import std/strformat
import std/math

proc format_us(us:float64): string =
    if us < 1000:
        result = "{us:0.1f} µs".fmt
    elif us < 1000*1000:
        result = "{us/1000:0.1f} ms".fmt
    else:
        result = "{us/1000/1000:0.1f} s".fmt

proc format_ops(us,n:float64): string =
    let ops : float64 = n / us * 1000*1000
    if ops < 100:
        result = "{ops:0.1f} items/s".fmt
    elif ops < 100*1000:
        result = "{ops/1000:0.1f}K items/s".fmt
    elif ops < 100*1000*1000:
        result = "{ops/1000/1000:0.1f}M items/s".fmt
    else:
        result = "{ops/1000/1000/1000:0.1f}G items/s".fmt

type Bench* = object
    label: string
    times: seq[MonoTime]
    items: seq[int]

proc new_bench*(label=""): Bench =
    result.label = label
    result.times.add(get_mono_time())

proc done(self: var Bench, items=1) =
    self.times.add(get_mono_time())
    self.items.add(items)

proc report(self: Bench, skip=0) =
    # === CALCULATE ===
    let runs = self.times.len - 1 - skip
    var run_duration: seq[int64]
    var total_ns: int64
    for i in 1+skip..runs:
        let ns = self.times[i].ticks - self.times[i-1].ticks
        run_duration.add(ns)
        total_ns += ns
    let avg_us : float64 = total_ns / runs / 1000
    #
    var dev_us : float64 = 0
    for d in run_duration:
        let diff : float64 = d/1000 - avg_us
        dev_us = diff*diff
    dev_us = sqrt(dev_us / runs.float64)
    #
    let min_us : float64 = run_duration.min / 1000
    let max_us : float64 = run_duration.max / 1000
    let avg_items : float64 = self.items.sum.float64 / runs.float64
    # === PRINT ===
    echo ""
    echo self.label, ":"
    if runs==1:
        echo "  Time: {format_us(avg_us)}".fmt
        echo "  Rate: {format_ops(avg_us, avg_items)}".fmt
    else:
        echo "  Time (avg ± stdev): {format_us(avg_us)} ± {format_us(dev_us)}".fmt
        echo "  Time (min … max):   {format_us(min_us)} … {format_us(max_us)}".fmt
        echo "  Rate (avg ± stdev): {format_ops(avg_us, avg_items)}".fmt
    echo "  Runs: {runs}".fmt
    echo ""

# === TESTS ===

import std/os

proc test1() =
    var b = new_bench("test benchmark")
    for i in 1..1000:
        sleep(1)
        b.done
    b.report

if is_main_module:
    test1()

