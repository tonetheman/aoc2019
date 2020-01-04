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

func test3() {
	program := "3,9,8,9,10,9,4,9,99,-1,8"
	computer := computer.MakeComputer()
	computer.ReadFromString(program)
	computer.SetInput(8)
	fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		fmt.Println(computer)
	}
	fmt.Println("output is set at", computer.GetOutput())
}

func test4() {
	program := "3,9,7,9,10,9,4,9,99,-1,8"
	computer := computer.MakeComputer()
	computer.ReadFromString(program)
	computer.SetInput(8)
	fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		fmt.Println(computer)
	}
	fmt.Println("output is set at", computer.GetOutput())
}

func test5() {
	program := "3,3,1108,-1,8,3,4,3,99"
	computer := computer.MakeComputer()
	computer.ReadFromString(program)
	computer.SetInput(800)
	fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		fmt.Println(computer)
	}
	fmt.Println("output is set at", computer.GetOutput())
}
func test6() {
	program := "3,3,1107,-1,8,3,4,3,99"
	computer := computer.MakeComputer()
	computer.ReadFromString(program)
	computer.SetInput(7)
	fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		fmt.Println(computer)
	}
	fmt.Println("output is set at", computer.GetOutput())
}

func test7() {
	program := "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
	computer := computer.MakeComputer()
	computer.ReadFromString(program)
	computer.SetInput(100)
	fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		fmt.Println(computer)
	}
	fmt.Println("output is set at", computer.GetOutput())
}

func test8() {
	program := "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
	computer := computer.MakeComputer()
	computer.ReadFromString(program)
	computer.SetInput(0)
	fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		fmt.Println(computer)
	}
	fmt.Println("output is set at", computer.GetOutput())
}

func part2() {
	computer := computer.MakeComputer()
	computer.ReadFromFile("data.txt")
	computer.SetInput(5)
	//fmt.Println(computer)
	for !computer.Halted() {
		computer.OneCycle()
		//fmt.Println(computer)
	}
	fmt.Println("output is set at", computer.GetOutput())
}

func main() {
	part2()
}
