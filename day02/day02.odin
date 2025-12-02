package day02

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

	buffer: [128]u8

	part_one: uint = 0
	part_two: uint = 0

	iter := strings.trim(string(input), "\r\n")
	for range in strings.split_iterator(&iter, ",") {
		last_str := range
		first_str := strings.split_iterator(&last_str, "-") or_else panic("Failed to parse input")

		first := strconv.parse_uint(first_str) or_else panic("Failed to parse input")
		last := strconv.parse_uint(last_str) or_else panic("Failed to parse input")

		for id in first ..= last {
			id_str := fmt.bprint(buffer[0:], id)

			digits := len(id_str)

			if digits % 2 == 0 && strings.compare(id_str[0:digits / 2], id_str[digits / 2:]) == 0 {
				part_one += id
			}

			if is_repeating_sequence(id_str) {
				part_two += id
			}
		}
	}

	fmt.printfln("Part 1: %d\nPart 2: %d", part_one, part_two)
}

is_repeating_sequence :: proc(str: string) -> bool {
	pattern_len: for l in 1 ..= (len(str) / 2) {
		if len(str) % l != 0 {continue}

		key := str[0:l]

		for i in 1 ..< len(str) / l {
			sub := str[i * l:(i + 1) * l]

			if strings.compare(key, sub) != 0 {
				continue pattern_len
			}
		}

		return true
	}

	return false
}
