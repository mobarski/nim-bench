# Bench

Simple benchmarking module.

## Example

```nim
import bench

var b = new_bench("first benchmark")
for i in 0..10:
    echo "SOMETHING"
    b.done
b.report

```

**output:**
```
TODO
```



## Similar projects

- [stopwatch](https://gitlab.com/define-private-public/stopwatch)
- [timeit](https://github.com/ringabout/timeit)
- [criterion](https://github.com/disruptek/criterion)
- [nimbench](https://github.com/ivankoster/nimbench)

