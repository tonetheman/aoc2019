package main

import (
	"fake/computer"
	"fmt"
	"io/ioutil"
)

const dbg = false

func testp(ivalues []int, program string) int {
	return testit(ivalues[0], ivalues[1], ivalues[2],
		ivalues[3], ivalues[4], program)
}

func testit(i1, i2, i3, i4, i5 int, program string) int {
	//fmt.Println("checking", i1, i2, i3, i4, i5)
	ampA := computer.MakeComputer()
	ampA.ReadFromString(program)
	ampA.SetInput(i1)
	ampA.SetInput(0)
	ampAOutput := make(chan int, 1)
	ampA.SetOutputChannel(ampAOutput)
	currentOutput := -1
	for !ampA.Halted() {
		ampA.OneCycle()
		select {
		case currentOutput = <-ampA.Output:
			//fmt.Println("got an output!", currentOutput)
			break
		default:
			//fmt.Println("no output yet a")
		}
	}
	//fmt.Println("ampB started")
	ampB := computer.MakeComputer()
	ampB.ReadFromString(program)
	ampB.SetInput(i2)
	ampB.SetInput(currentOutput)
	ampBOutput := make(chan int, 1)
	ampB.SetOutputChannel(ampBOutput)
	for !ampB.Halted() {
		ampB.OneCycle()
		select {
		case currentOutput = <-ampB.Output:
			//fmt.Println("got output b", currentOutput)
			break
		default:
			//fmt.Println("no output yet b")
		}
	}
	//fmt.Println("ampC started")
	ampC := computer.MakeComputer()
	ampC.ReadFromString(program)
	ampC.SetInput(i3)
	ampC.SetInput(currentOutput)
	ampCOutput := make(chan int, 1)
	ampC.SetOutputChannel(ampCOutput)
	for !ampC.Halted() {
		ampC.OneCycle()
		select {
		case currentOutput = <-ampC.Output:
			//fmt.Println("got output c", currentOutput)
			break
		default:
			//fmt.Println("no output yet c")
		}
	}
	//fmt.Println("ampD started")
	ampD := computer.MakeComputer()
	ampD.ReadFromString(program)
	ampD.SetInput(i4)
	ampD.SetInput(currentOutput)
	ampDOutput := make(chan int, 1)
	ampD.SetOutputChannel(ampDOutput)
	for !ampD.Halted() {
		ampD.OneCycle()
		select {
		case currentOutput = <-ampD.Output:
			//fmt.Println("got output d", currentOutput)
			break
		default:
			//fmt.Println("no output yet d")
		}
	}
	//fmt.Println("ampE started")
	ampE := computer.MakeComputer()
	ampE.ReadFromString(program)
	ampE.SetInput(i5)
	ampE.SetInput(currentOutput)
	ampEOutput := make(chan int, 1)
	ampE.SetOutputChannel(ampEOutput)
	for !ampE.Halted() {
		ampE.OneCycle()
		select {
		case currentOutput = <-ampE.Output:
			//fmt.Println("got output e", currentOutput)
			break
		default:
			//fmt.Println("no output yet e")
		}
	}
	//fmt.Println("final output", currentOutput)
	return currentOutput
}

func part2_testit(i1, i2, i3, i4, i5 int, program string) int {
	fmt.Println("checking", i1, i2, i3, i4, i5)

	ampA := computer.MakeComputer()
	ampA.ReadFromString(program)
	ampAOutput := make(chan int, 1)
	ampA.SetOutputChannel(ampAOutput)

	ampB := computer.MakeComputer()
	ampB.ReadFromString(program)
	ampBOutput := make(chan int, 1)
	ampB.SetOutputChannel(ampBOutput)

	ampC := computer.MakeComputer()
	ampC.ReadFromString(program)
	ampCOutput := make(chan int, 1)
	ampC.SetOutputChannel(ampCOutput)

	ampD := computer.MakeComputer()
	ampD.ReadFromString(program)
	ampDOutput := make(chan int, 1)
	ampD.SetOutputChannel(ampDOutput)

	ampE := computer.MakeComputer()
	ampE.ReadFromString(program)
	ampEOutput := make(chan int, 1)
	ampE.SetOutputChannel(ampEOutput)

	currentOutput := 0
outer:
	for {
		fmt.Println("ampA started", i1, currentOutput)
		ampA.SetDebug(true)
		ampA.SetInput(i1)
		ampA.SetInput(currentOutput)
		fmt.Println("added inputs into ampA")
	innera:
		for !ampA.Halted() {
			fmt.Println("before one cycle ampA")
			ampA.OneCycle()
			select {
			case currentOutput = <-ampA.Output:
				//fmt.Println("got an output!", currentOutput)
				//ampA.EmptyInput() // do this in case we did not read 2 values
				break innera
			default:
				//fmt.Println("no output yet a")
			}
			//fmt.Println(ampA)
		}
		fmt.Println("now going to check if ampA halted")
		if ampA.Halted() {
			fmt.Println("ampA really halted")
			break outer
		}
		fmt.Println("ampB started", i2, currentOutput)
		ampB.SetDebug(true)
		ampB.SetInput(i2)
		ampB.SetInput(currentOutput)
	innerb:
		for !ampB.Halted() {
			ampB.OneCycle()
			select {
			case currentOutput = <-ampB.Output:
				//fmt.Println("got output b", currentOutput)
				//ampB.EmptyInput()
				break innerb
			default:
				//fmt.Println("no output yet b")
			}
		}
		if ampB.Halted() {
			fmt.Println("ampB really halted")
			break outer
		}
		fmt.Println("ampC started", i3, currentOutput)
		ampC.SetInput(i3)
		ampC.SetInput(currentOutput)
	innerc:
		for !ampC.Halted() {
			ampC.OneCycle()
			select {
			case currentOutput = <-ampC.Output:
				//ampC.EmptyInput()
				//fmt.Println("got output c", currentOutput)
				break innerc
			default:
				//fmt.Println("no output yet c")
			}
		}
		if ampC.Halted() {
			fmt.Println("ampC really halted")
			break outer
		}
		fmt.Println("ampD started", i4, currentOutput)
		ampD.SetInput(i4)
		ampD.SetInput(currentOutput)
	innerd:
		for !ampD.Halted() {
			ampD.OneCycle()
			select {
			case currentOutput = <-ampD.Output:
				//ampD.EmptyInput()
				//fmt.Println("got output d", currentOutput)
				break innerd
			default:
				//fmt.Println("no output yet d")
			}
		}
		if ampD.Halted() {
			fmt.Println("ampD really halted")
			break outer
		}
		fmt.Println("ampE started", i5, currentOutput)
		ampE.SetDebug(true)
		ampE.SetInput(i5)
		ampE.SetInput(currentOutput)
	innere:
		for !ampE.Halted() {
			ampE.OneCycle()
			select {
			case currentOutput = <-ampE.Output:
				//ampE.EmptyInput()
				//fmt.Println("got output e", currentOutput)
				break innere
			default:
				//fmt.Println("no output yet e")
			}
		}
		if ampE.Halted() {
			fmt.Println("ampE really halted")
			break outer
		}
	}
	fmt.Println("final output", currentOutput)
	return currentOutput
}

func permutations(arr []int) [][]int {
	var helper func([]int, int)
	res := [][]int{}

	helper = func(arr []int, n int) {
		if n == 1 {
			tmp := make([]int, len(arr))
			copy(tmp, arr)
			res = append(res, tmp)
		} else {
			for i := 0; i < n; i++ {
				helper(arr, n-1)
				if n%2 == 1 {
					tmp := arr[i]
					arr[i] = arr[n-1]
					arr[n-1] = tmp
				} else {
					tmp := arr[0]
					arr[0] = arr[n-1]
					arr[n-1] = tmp
				}
			}
		}
	}
	helper(arr, len(arr))
	return res
}

func test1() {
	program := "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
	check := permutations([]int{0, 1, 2, 3, 4})
	bestone := -1
	for _, v := range check {
		res := testp(v, program)
		if res > bestone {
			bestone = res
		}
	}
	fmt.Println("bestone", bestone)
}

func test2() {
	program := "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"
	check := permutations([]int{0, 1, 2, 3, 4})
	bestone := -1
	bestindex := -1
	for i, v := range check {
		res := testp(v, program)
		if res > bestone {
			bestone = res
			bestindex = i
		}
	}
	fmt.Println("bestone", bestone, check[bestindex])
}

func test3() {
	program := "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"
	check := permutations([]int{0, 1, 2, 3, 4})
	bestone := -1
	bestindex := -1
	for i, v := range check {
		res := testp(v, program)
		if res > bestone {
			bestone = res
			bestindex = i
		}
	}
	fmt.Println("bestone", bestone, check[bestindex])
}

func part1() {
	data, err := ioutil.ReadFile("data.txt")
	if err != nil {
		panic(err)
	}
	program := string(data)
	check := permutations([]int{0, 1, 2, 3, 4})
	bestone := -1
	bestindex := -1
	for i, v := range check {
		res := testp(v, program)
		if res > bestone {
			bestone = res
			bestindex = i
		}
	}
	fmt.Println("bestone", bestone, check[bestindex])

}

func main() {
	program := "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
	part2_testit(9, 8, 7, 6, 5, program)
}
