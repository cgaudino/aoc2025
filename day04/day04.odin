package day04

import "../shared"

import "core:fmt"
import "core:os"
import "core:strings"

// INPUT_FILE_PATH :: "sample.input"
INPUT_FILE_PATH :: "input.input"

main :: proc() {
	shared.time_proc()

	input := os.read_entire_file(INPUT_FILE_PATH) or_else panic("Failed to read input")
	defer delete(input)

	num_columns := strings.index_byte(string(input), '\n')

	part_one_result := 0
	part_two_result := 0

	// Part 1
	for char, index in input {
		if char != '@' {continue}

		num_neighbor_rolls := 0

		pos := to_pos(index, num_columns)
		for x in -1 ..= 1 {
			for y in -1 ..= 1 {
				offset := [2]int{x, y}
				neighbor := pos + offset
				if offset == {0, 0} || is_off_grid(neighbor, num_columns, len(input)) {continue}
				neighbor_index := to_index(neighbor, num_columns)

				if input[neighbor_index] == '@' {
					num_neighbor_rolls += 1
				}
			}
		}

		if num_neighbor_rolls < 4 {
			part_one_result += 1
		}
	}

	// Part 2
	for {
		num_removed := 0

		for char, index in input {
			if char != '@' {continue}

			num_neighbor_rolls := 0

			pos := to_pos(index, num_columns)
			for x in -1 ..= 1 {
				for y in -1 ..= 1 {
					offset := [2]int{x, y}
					neighbor := pos + offset
					if offset == {0, 0} ||
					   is_off_grid(neighbor, num_columns, len(input)) {continue}
					neighbor_index := to_index(neighbor, num_columns)

					if input[neighbor_index] == '@' {
						num_neighbor_rolls += 1
					}
				}
			}

			if num_neighbor_rolls < 4 {
				part_two_result += 1
				num_removed += 1
				input[index] = '.'
			}
		}

		if num_removed == 0 {break}
	}

	fmt.printfln("Part 1: %d\nPart 2: %d", part_one_result, part_two_result)
}

to_index :: proc(pos: [2]int, columns: int) -> int {
	return pos.y * (columns + 1) + pos.x
}

to_pos :: proc(index: int, columns: int) -> [2]int {
	return {index % (columns + 1), index / (columns + 1)}
}

is_off_grid :: proc(pos: [2]int, columns: int, len: int) -> bool {
	return pos.x < 0 || pos.y < 0 || pos.x >= columns || to_index(pos, columns) >= len
}
