package computer

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type Computer struct {
	ip           int
	instructions []int
	halted       bool
	input        int
	output       int
}

type OpCode struct {
	opcode  int
	p1_mode int
	p2_mode int
	p3_mode int
}

func Goo() int {
	return 43
}

func MakeOpCode(i int) OpCode {
	//i := 12345
	//i = 1002
	s := fmt.Sprintf("%05d", i)
	//fmt.Println(s[3:5])
	opcode, _ := strconv.Atoi(s[3:5])
	//fmt.Println("opcode", opcode)
	p3_mode, _ := strconv.Atoi(s[0:1])
	p2_mode, _ := strconv.Atoi(s[1:2])
	p1_mode, _ := strconv.Atoi(s[2:3])
	//fmt.Println(p1_mode, p2_mode, p3_mode)
	return OpCode{opcode, p1_mode, p2_mode, p3_mode}
}

func MakeComputer() Computer {
	return Computer{}
}

func (c *Computer) GetOutput() int {
	return c.output
}
func (c *Computer) SetInput(input int) {
	c.input = input
}
func (c *Computer) GetInstr(pos int) int {
	return c.instructions[pos]
}

func (c *Computer) SetInstr(v int, pos int) {
	c.instructions[pos] = v
}

func (c *Computer) Halted() bool {
	return c.halted
}

func (c *Computer) OneCycle() {
	currentInstruction := MakeOpCode(c.instructions[c.ip])
	if currentInstruction.opcode == 1 {
		arg1 := c.instructions[c.ip+1]
		arg2 := c.instructions[c.ip+2]
		res := c.instructions[c.ip+3] // never immediate

		realarg1 := -1
		if currentInstruction.p1_mode == 0 {
			realarg1 = c.instructions[arg1]
		} else {
			realarg1 = arg1
		}
		realarg2 := -1
		if currentInstruction.p2_mode == 0 {
			realarg2 = c.instructions[arg2]
		} else {
			realarg2 = arg2
		}

		realres := res
		c.instructions[realres] = realarg1 + realarg2
		c.ip += 4
	}
	if currentInstruction.opcode == 2 {
		arg1 := c.instructions[c.ip+1]
		arg2 := c.instructions[c.ip+2]
		res := c.instructions[c.ip+3] // never immediate

		realarg1 := -1
		if currentInstruction.p1_mode == 0 {
			realarg1 = c.instructions[arg1]
		} else {
			realarg1 = arg1
		}
		realarg2 := -1
		if currentInstruction.p2_mode == 0 {
			realarg2 = c.instructions[arg2]
		} else {
			realarg2 = arg2
		}

		realres := res
		c.instructions[realres] = realarg1 * realarg2
		c.ip += 4
	}
	if currentInstruction.opcode == 3 {
		arg1 := c.instructions[c.ip+1]
		if currentInstruction.p1_mode == 0 {
			c.instructions[arg1] = c.input
		} else {
			panic("INVALID MODE INSTR: INPUT")
		}

		c.ip += 2
	}
	if currentInstruction.opcode == 4 {
		arg1 := c.instructions[c.ip+1]
		if currentInstruction.p1_mode == 0 {
			// output the value at arg1
			c.output = c.instructions[arg1]
		} else {
			c.output = arg1
		}
		fmt.Println("OUTPUT SET TO:", c.output)
		c.ip += 2
	}
	if currentInstruction.opcode == 99 {
		c.halted = true
		c.ip++
	}
}

func (c *Computer) ReadFromString(s string) {
	tmpdata := strings.Split(s, ",")
	finalarray := make([]int, len(tmpdata))
	for i := 0; i < len(tmpdata); i++ {
		junk, _ := strconv.Atoi(tmpdata[i])
		finalarray[i] = junk
	}
	c.instructions = finalarray
}

func (c *Computer) ReadFromFile(filename string) {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	tmp := string(data)
	tmpdata := strings.Split(tmp, ",")
	finalarray := make([]int, len(tmpdata))
	for i := 0; i < len(tmpdata); i++ {
		junk, _ := strconv.Atoi(tmpdata[i])
		finalarray[i] = junk
	}
	c.instructions = finalarray

}
