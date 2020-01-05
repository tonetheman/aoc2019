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
	input        chan int
	Output       chan int
	debug        bool
	inputCount   int
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
	s := fmt.Sprintf("%05d", i)
	opcode, _ := strconv.Atoi(s[3:5])
	p3_mode, _ := strconv.Atoi(s[0:1])
	p2_mode, _ := strconv.Atoi(s[1:2])
	p1_mode, _ := strconv.Atoi(s[2:3])
	return OpCode{opcode, p1_mode, p2_mode, p3_mode}
}

func MakeComputer() Computer {
	computer := Computer{}
	computer.input = make(chan int, 20)
	return computer
}
func (c *Computer) GetInputCount() int {
	return c.inputCount
}
func (c *Computer) SetDebug(v bool) {
	c.debug = v
}
func (c *Computer) SetOutputChannel(o chan int) {
	c.Output = o
}
func (c *Computer) GetOutput() int {
	return <-c.Output
}
func (c *Computer) SetInput(input int) {
	// just send the input to the channel
	c.inputCount++
	c.input <- input
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

func (c *Computer) EmptyInput() {
	// empty the input
	// might have 2 things run this twice
	select {
	case _ = <-c.input:
		if c.debug {
			fmt.Println("DBG:EmptyInput drained")
		}

	default:
	}
	// and again
	select {
	case _ = <-c.input:
		if c.debug {
			fmt.Println("DBG:EmptyInput drained")
		}
	default:
	}

}

func (c *Computer) OneCycle() {
	currentInstruction := MakeOpCode(c.instructions[c.ip])
	if currentInstruction.opcode == 1 {
		if c.debug {
			fmt.Println("DBG:ADD")
		}
		if currentInstruction.p3_mode != 0 {
			panic("GOT AN ADD WITH INVALID STORE")
		}
		arg1 := c.instructions[c.ip+1]
		arg2 := c.instructions[c.ip+2]
		res := c.instructions[c.ip+3] // never immediate
		if c.debug {
			fmt.Println("\tDBG:ADD:args", arg1, arg2, res)
			fmt.Println("\tDBG:ADD:modes",
				currentInstruction.p1_mode, currentInstruction.p2_mode,
				currentInstruction.p3_mode)
		}
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
		if c.debug {
			fmt.Println("\tDBG:ADD:realargs", realarg1, realarg2, realres)
		}
		c.instructions[realres] = realarg1 + realarg2
		c.ip += 4
	}
	if currentInstruction.opcode == 2 {
		if c.debug {
			fmt.Println("DBG:MULT")
		}
		if currentInstruction.p3_mode != 0 {
			panic("GOT AN INVALID STORE ON MULT")
		}
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
		if c.debug {
			fmt.Println("DBG:INPUT")
		}
		arg1 := c.instructions[c.ip+1]
		if currentInstruction.p1_mode == 0 {
			// read from the input channel here
			select {
			case c.instructions[arg1] = <-c.input:
				c.inputCount--
				c.ip += 2
				if c.debug {
					fmt.Println("\tDBG:INPUT instr and val", arg1, c.instructions[arg1])
				}
			default:
				// asked for a read but nothing was there
				// need to block and do nothing
				// the IP should remain where it is
			}

		} else {
			panic("INVALID MODE INSTR: INPUT")
		}

	}
	if currentInstruction.opcode == 4 {
		if c.debug {
			fmt.Println("DBG:OUTPUT")
		}
		arg1 := c.instructions[c.ip+1]
		if currentInstruction.p1_mode == 0 {
			// output the value at arg1
			if c.debug {
				fmt.Println("\tDBG:OUTPUT:p1mode0,", c.instructions[arg1])
			}
			c.ip += 2
			c.Output <- c.instructions[arg1]
		} else {
			if c.debug {
				fmt.Println("\tDBG:OUTPUT:p1mode1,", arg1)
			}
			c.ip += 2
			c.Output <- arg1
		}

	}
	if currentInstruction.opcode == 5 {
		// jmp if true
		arg1 := c.instructions[c.ip+1]
		arg2 := c.instructions[c.ip+2]

		if c.debug {
			fmt.Println("DBG:JMPTRUE", currentInstruction.p1_mode,
				currentInstruction.p2_mode, arg1, arg2)
		}

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
		if c.debug {
			fmt.Println("\tDBG:JMPTRUE:realargs", realarg1, realarg2)
		}
		if realarg1 != 0 {
			if c.debug {
				fmt.Println("\tDBG:JMPTRUE:arg1 was not zero setting ip to", realarg2)
			}
			c.ip = realarg2
		} else {
			if c.debug {
				fmt.Println("\tDBG:JMPTRUE:arg1 was zero setting ip+3")
			}
			c.ip += 3
		}
	}
	if currentInstruction.opcode == 6 {
		// jmp if false
		if c.debug {
			fmt.Println("DBG:JMPIFFALSE")
		}
		arg1 := c.instructions[c.ip+1]
		arg2 := c.instructions[c.ip+2]
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
		if realarg1 == 0 {
			c.ip = realarg2
		} else {
			c.ip += 3
		}
	}
	if currentInstruction.opcode == 7 {
		// less than
		if c.debug {
			fmt.Println("DBG:LESSTHAN")
		}
		arg1 := c.instructions[c.ip+1]
		arg2 := c.instructions[c.ip+2]
		arg3 := c.instructions[c.ip+3]
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
		if currentInstruction.p3_mode == 1 {
			panic("INVALID MODE FOR p3 less than")
		}
		if realarg1 < realarg2 {
			c.instructions[arg3] = 1
		} else {
			c.instructions[arg3] = 0
		}
		c.ip += 4
	}
	if currentInstruction.opcode == 8 {
		// equals
		if c.debug {
			fmt.Println("DBG:EQUALS")
		}
		arg1 := c.instructions[c.ip+1]
		arg2 := c.instructions[c.ip+2]
		arg3 := c.instructions[c.ip+3]
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
		if currentInstruction.p3_mode == 1 {
			panic("INVALID MODE FOR p3 equals")
		}
		if realarg1 == realarg2 {
			c.instructions[arg3] = 1
		} else {
			c.instructions[arg3] = 0
		}
		c.ip += 4
	}

	if currentInstruction.opcode == 99 {
		if c.debug {
			fmt.Println("HALT")
		}
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
