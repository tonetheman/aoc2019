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
	part1()
}
