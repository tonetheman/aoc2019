package main

import (
	"fake/computer"
	"fmt"
)

func runprogram(program string) {
	computer := computer.MakeComputer()
	computer.ReadFromString(program)
	fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		fmt.Println(computer)
	}
}

func test1() {
	program := "1,9,10,3,2,3,11,0,99,30,40,50"
	runprogram(program)
}

func test2() {
	program := "1,0,0,0,99"
	runprogram(program)
}

func test3() {
	program := "2,3,0,3,99"
	runprogram(program)
}

func test4() {
	program := "2,4,4,5,99,0"
	runprogram(program)
}

func test5() {
	program := "1,1,1,4,99,5,6,0,99"
	runprogram(program)
}

func part1() {
	computer := computer.MakeComputer()
	computer.ReadFromFile("./data.txt")
	// replace per part1
	computer.SetInstr(12, 1)
	computer.SetInstr(2, 2)

	fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		fmt.Println(computer)
	}

	fmt.Println("ANSWER:", computer.GetInstr(0))
}

func part2() {
	for i := 0; i < 99; i++ {
		for j := 0; j < 99; j++ {
			computer := computer.MakeComputer()
			computer.ReadFromFile("./data.txt")
			// replace per part1
			computer.SetInstr(i, 1)
			computer.SetInstr(j, 2)

			//fmt.Println(computer)
			for !computer.Halted() {
				computer.OneCycle()
				//fmt.Println(computer)
			}

			if computer.GetInstr(0) == 19690720 {
				fmt.Println("GOT IT", i, j, (i*100)+j)
				break
			}

		}
	}
}

func main() {
	//part1()
	part2()
}
