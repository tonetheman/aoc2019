package computer

import (
	"io/ioutil"
	"strconv"
	"strings"
)

type Computer struct {
	ip           int
	instructions []int
	halted       bool
}

func Goo() int {
	return 43
}

func MakeComputer() Computer {
	return Computer{}
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
	currentInstruction := c.instructions[c.ip]
	if currentInstruction == 1 {
		arg1 := c.instructions[c.ip+1]
		arg2 := c.instructions[c.ip+2]
		res := c.instructions[c.ip+3]
		realarg1 := c.instructions[arg1]
		realarg2 := c.instructions[arg2]
		realres := res
		c.instructions[realres] = realarg1 + realarg2
		c.ip += 4
	}
	if currentInstruction == 2 {
		//fmt.Println("MULT", c.ip)
		arg1 := c.instructions[c.ip+1]
		arg2 := c.instructions[c.ip+2]
		res := c.instructions[c.ip+3]
		//fmt.Println(arg1, arg2, res)
		realarg1 := c.instructions[arg1]
		realarg2 := c.instructions[arg2]
		realres := res
		//fmt.Println(realarg1, realarg2, realres)
		c.instructions[realres] = realarg1 * realarg2
		c.ip += 4
	}
	if currentInstruction == 99 {
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
