package shared

import "core:fmt"
import "core:time"

@(deferred_out = time_proc_out)
time_proc :: proc() -> time.Tick {
	return time.tick_now()
}

@(private = "file")
time_proc_out :: proc(start: time.Tick) {
	fmt.printfln("\nElapsed: %v", time.tick_since(start))
}
