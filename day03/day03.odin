package day03

import "../shared"

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:os"
import "core:strconv"
import "core:strings"

// INPUT_FILE_PATH :: "sample.input"
INPUT_FILE_PATH :: "input.input"

main :: proc() {
	shared.time_proc()

	input := os.read_entire_file(INPUT_FILE_PATH) or_else panic("Failed to read input")
	defer delete(input)

	part_one_result: u64 = 0
	part_two_result: u64 = 0

	line_iter := string(input)
	for line in strings.split_lines_iterator(&line_iter) {
		part_one_result += get_line_joltage(line, 2)
		part_two_result += get_line_joltage(line, 12)
	}

	fmt.printfln("Part 1: %d\nPart 2: %d", part_one_result, part_two_result)
}

get_line_joltage :: proc(line: string, remaining_digits: u64) -> u64 {

	if remaining_digits == 0 {return 0}

	max_digit: u64
	max_digit_index: int

	for c, i in line {
		digit := u64(c - '0')

		if digit > max_digit {
			max_digit = digit
			max_digit_index = i
		}

		if remaining_digits >= u64(len(line) - i) {
			break
		}
	}

	sum: u64 =
		max_digit * pow_u64(10, remaining_digits - 1) +
		get_line_joltage(line[max_digit_index + 1:], remaining_digits - 1)

	return sum
}

pow_u64 :: proc(x, y: u64) -> (z: u64) {
	z = 1
	for _ in 0 ..< y {
		z *= x
	}
	return
}
