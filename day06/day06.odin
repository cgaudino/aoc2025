package day06

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

	last_line_idx := strings.index_any(input, "+*")
	values_str := input[0:last_line_idx]
	operators_str := input[last_line_idx:]

	part_one_result := 0
	operator_num := 0
	for operator in strings.fields_iterator(&operators_str) {
		op_func: proc(a: int, b: int) -> int
		switch operator {
		case "+":
			op_func = add
		case "*":
			op_func = mul
		case:
			panic("Failed to parse operator")
		}

		result := 0

		values_iter := values_str
		line_idx := 0
		for line in strings.split_lines_iterator(&values_iter) {
			line_iter := line
			for _ in 0 ..< operator_num {
				strings.fields_iterator(&line_iter)
			}

			value_str := strings.fields_iterator(&line_iter) or_else panic("Failed to parse")
			value := strconv.parse_int(value_str) or_else panic("Failed to parse")

			if line_idx == 0 {
				result = value
			} else {
				result = op_func(result, value)
			}

			line_idx += 1
		}


		part_one_result += result
		operator_num += 1
	}

	fmt.printfln("Part 1: %d\n", part_one_result)
}

add :: proc(a: int, b: int) -> int {return a + b}
mul :: proc(a: int, b: int) -> int {return a * b}
