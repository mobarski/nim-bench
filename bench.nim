import std/monotimes
import std/strformat
import std/math

proc format_us(us:float64): string =
    if us < 1000:
        result = "{us:0.2f} µs".fmt
    elif us < 1000*1000:
        result = "{us/1000:0.2f} ms".fmt
    else:
        result = "{us/1000/1000:0.2f} s".fmt

proc format_ops(us, n:float64, item_label="item"): string =
    let ops : float64 = n / us * 1000*1000
    if ops < 1:
        let spo : float64 = us / n / (1000*1000)
        result = "{spo:0.2f} s/{item_label}".fmt
    elif ops < 10:
        result = "{ops:0.2f} {item_label}s/s".fmt
    elif ops < 100:
        result = "{ops:0.1f} {item_label}s/s".fmt
    elif ops < 1000:
        result = "{ops.int:d} {item_label}s/s".fmt
    elif ops < 10*1000:
        result = "{ops/1000:0.2f}K {item_label}s/s".fmt
    elif ops < 100*1000:
        result = "{ops/1000:0.1f}K {item_label}s/s".fmt
    elif ops < 1000*1000:
        result = "{int(ops/1000):d}K {item_label}s/s".fmt
    elif ops < 10*1000*1000:
        result = "{ops/1000/1000:0.2f}M {item_label}s/s".fmt
    elif ops < 100*1000*1000:
        result = "{ops/1000/1000:0.1f}M {item_label}s/s".fmt
    elif ops < 1000*1000*1000:
        result = "{int(ops/1000/1000):d}M {item_label}s/s".fmt
    else:
        result = "{ops/1000/1000/1000:0.2f}G {item_label}s/s".fmt

proc output(text: string) =
    stderr.write_line(text)

type Bench* = object
    label: string
    times: seq[MonoTime]
    items: seq[int]

proc new_bench*(label="Benchmark"): Bench =
    result.label = label
    result.times.add(get_mono_time())

proc done*(self: var Bench, items=1) =
    self.times.add(get_mono_time())
    self.items.add(items)

proc show*(self: Bench, item="item", skip=0) =
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
    output self.label & ":"
    if runs==1:
        output "  Time: {format_us(avg_us)}".fmt
        output "  Rate: {format_ops(avg_us, avg_items)}".fmt
    else:
        output "  Time (avg ± stdev): {format_us(avg_us)} ± {format_us(dev_us)}".fmt
        output "  Time (min … max):   {format_us(min_us)} … {format_us(max_us)}".fmt
        output "  Rate (avg): {format_ops(avg_us, avg_items, item_label=item)}".fmt
    output "  Runs: {runs}".fmt

# === TESTS ===

import std/os

proc test1() =
    var b = new_bench("Test benchmark")
    for i in 1..1000:
        sleep(1)
        b.done(10000000)
    b.show(item="run")

if is_main_module:
    test1()

