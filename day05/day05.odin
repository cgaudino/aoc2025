package day05

import "../shared"

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

// INPUT_FILE_PATH :: "sample.input"
INPUT_FILE_PATH :: "input.input"

main :: proc() {
	shared.time_proc()

	input := string(os.read_entire_file(INPUT_FILE_PATH) or_else panic("Failed to read input"))
	defer delete(input)

	break_index := strings.index(input, "\n\n")

	ranges_str := input[0:break_index]
	ids_str := input[break_index + 2:]

	ranges := make_dynamic_array([dynamic][2]int)
	for line in strings.split_lines_iterator(&ranges_str) {
		dash_index := strings.index(line, "-")
		if dash_index < 0 {panic("Failed to parse input")}

		lower := strconv.parse_int(line[0:dash_index]) or_else panic("Failed to parse input")
		upper := strconv.parse_int(line[dash_index + 1:]) or_else panic("Failed to parse input")

		append(&ranges, [2]int{lower, upper})
	}

	for {
		did_condense := false

		for i in 0 ..< len(ranges) {
			for j in (i + 1) ..< len(ranges) {
				if range_contains(ranges[i], ranges[j][0]) ||
				   range_contains(ranges[i], ranges[j][1]) ||
				   range_contains(ranges[j], ranges[i][0]) ||
				   range_contains(ranges[j], ranges[i][1]) {
					did_condense = true
					ranges[i] = range_combine(ranges[i], ranges[j])
					unordered_remove(&ranges, j)
				}
			}
		}

		if !did_condense {break}
	}

	part_one_result := 0
	part_two_result := 0

	for line in strings.split_lines_iterator(&ids_str) {
		id := strconv.parse_int(line) or_else panic("Failed to parse input")
		for range in ranges {
			if range_contains(range, id) {
				part_one_result += 1
				break
			}
		}
	}

	for range in ranges {
		part_two_result += range[1] - range[0] + 1
	}

	fmt.printfln("Part 1: %d\nPart 2: %d", part_one_result, part_two_result)
}

range_contains :: proc(range: [2]int, value: int) -> bool {
	return value >= range[0] && value <= range[1]
}

range_combine :: proc(a: [2]int, b: [2]int) -> [2]int {
	return [2]int{min(a[0], b[0]), max(a[1], b[1])}
}

min :: proc(a: int, b: int) -> int {
	if a < b {return a}
	return b
}

max :: proc(a: int, b: int) -> int {
	if a > b {return a}
	return b
}
