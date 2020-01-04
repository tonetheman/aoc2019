package main

import (
	"fake/computer"
	"fmt"
	"strconv"
)

func test1() {
	program := "3,0,4,0,99"
	computer := computer.MakeComputer()
	computer.ReadFromString(program)
	computer.SetInput(43)
	fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		fmt.Println(computer)
	}
	fmt.Println("output is set at", computer.GetOutput())
}

func test2() {
	i := 12345
	//i = 1002
	s := fmt.Sprintf("%05d", i)
	fmt.Println(s[3:5])
	opcode, _ := strconv.Atoi(s[3:5])
	fmt.Println("opcode", opcode)
	p3_mode, _ := strconv.Atoi(s[0:1])
	p2_mode, _ := strconv.Atoi(s[1:2])
	p1_mode, _ := strconv.Atoi(s[2:3])
	fmt.Println(p1_mode, p2_mode, p3_mode)

}

func part1() {
	computer := computer.MakeComputer()
	computer.ReadFromFile("data.txt")
	computer.SetInput(1)
	//fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		//fmt.Println(computer)
	}
	fmt.Println("output is set at", computer.GetOutput())
}

func main() {
	part1()
}
