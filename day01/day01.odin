package day01

import "../shared"

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"

// INPUT_FILE_PATH :: "sample.input"
INPUT_FILE_PATH :: "input.input"

main :: proc() {
	shared.time_proc()

	input := os.read_entire_file(INPUT_FILE_PATH) or_else panic("Failed to read input")
	defer delete(input)

	val: int = 50
	part_one_result: int = 0
	part_two_result: int = 0

	line_iter := string(input)
	for line in strings.split_lines_iterator(&line_iter) {

		delta := strconv.parse_int(line[1:]) or_else panic("Failed to parse input")
		if line[0] == 'L' {delta *= -1}

		wraps, wrapped_val := math.floor_divmod(val + delta, 100)
		wraps = math.abs(wraps)

		if wrapped_val == 0 {
			part_one_result += 1
			if delta < 0 {
				part_two_result += 1
			}
		}

		if delta < 0 && val == 0 {
			wraps -= 1
		}

		part_two_result += wraps

		val = wrapped_val
	}

	fmt.printfln("Part 1: %d\nPart 2: %d", part_one_result, part_two_result)
}
