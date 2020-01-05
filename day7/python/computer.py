import sys

class OpCode:
    def __init__(self,opcode,p1mode,p2mode,p3mode):
        self.opcode = opcode
        self.p1mode = p1mode
        self.p2mode = p2mode
        self.p3mode = p3mode
    def __repr__(self):
        return "{0} {1} {2} {3}".format(self.opcode,self.p1mode,self.p2mode,self.p3mode)

class Computer:
    def __init__(self):
        self.ip = 0
        self.halt = False
        self.input = []
        self.memory = []
        self.output = None
        for i in range(1024):
            self.memory.append(0)
    def loads(self,s):
        data = s.split(",")
        for i in range(len(data)):
            d = int(data[i])
            self.memory[i] = d
    def decode_instr(self,v):
        tmp = "{0:05d}".format(v)
        opcode = tmp[3:5]
        p1mode = tmp[2]
        p2mode = tmp[1]
        p3mode = tmp[0]
        # print(tmp[3:5])
        return OpCode(int(tmp[3:5],base=10), int(tmp[2]), int(tmp[1]), int(tmp[0]))
    def handle_add(self,instr):
        # print("DBG:ADD",instr)
        arg1 = self.memory[self.ip+1]
        arg2 = self.memory[self.ip+2]
        arg3 = self.memory[self.ip+3]
        realarg1 = -1
        if instr.p1mode==0:
            realarg1 = self.memory[arg1]
        else:
            realarg1 = arg1
        realarg2 = -1
        if instr.p2mode == 0:
            realarg2 = self.memory[arg2]
        else:
            realarg2 = arg2
        if instr.p3mode!=0:
            print("ERR: invalid p3mode in ADD")
            sys.exit(0)
        self.memory[arg3] = realarg1 + realarg2
        self.ip = self.ip + 4

    def handle_mult(self,instr):
        # print("DBG:MULT",instr)
        arg1 = self.memory[self.ip+1]
        arg2 = self.memory[self.ip+2]
        arg3 = self.memory[self.ip+3]
        realarg1 = -1
        if instr.p1mode==0:
            realarg1 = self.memory[arg1]
        else:
            realarg1 = arg1
        realarg2 = -1
        if instr.p2mode == 0:
            realarg2 = self.memory[arg2]
        else:
            realarg2 = arg2
        if instr.p3mode!=0:
            print("ERR: invalid p3mode in MULT")
            sys.exit(0)
        self.memory[arg3] = realarg1 * realarg2
        self.ip = self.ip + 4

    def take_input(self,input_value):
        self.input.append(input_value)

    def handle_input(self,instr):
        arg1 = self.memory[self.ip+1]
        if instr.p1mode!=0:
            print("ERR:p1mode is not 0 on input")
            sys.exit(0)
        self.memory[arg1] = self.input.pop()
        self.ip = self.ip + 2

    def handle_output(self,instr):
        arg1 = self.memory[self.ip+1]
        if instr.p1mode == 0:
            self.output = self.memory[arg1]
        else:
            self.output = arg1
        self.ip = self.ip + 2

    def handle_term(self,instr):
        # print("DBG:halt called")
        self.halt = True

    def handle_jmp_if_true(self,instr):
        arg1 = self.memory[self.ip+1]
        arg2 = self.memory[self.ip+2]
        realarg1 = -1
        if instr.p1mode==0:
            realarg1 = self.memory[arg1]
        else:
            realarg1 = arg1
        realarg2 = -1
        if instr.p2mode == 0:
            realarg2 = self.memory[arg2]
        else:
            realarg2 = arg2

        if realarg1 != 0:
            self.ip = arg2
        else:
            self.ip = self.ip + 3

    def handle_jmp_if_false(self,instr):
        arg1 = self.memory[self.ip+1]
        arg2 = self.memory[self.ip+2]
        realarg1 = -1
        if instr.p1mode==0:
            realarg1 = self.memory[arg1]
        else:
            realarg1 = arg1
        realarg2 = -1
        if instr.p2mode == 0:
            realarg2 = self.memory[arg2]
        else:
            realarg2 = arg2

        if realarg1 == 0:
            self.ip = arg2
        else:
            self.ip = self.ip + 3

    def handle_less_than(self,instr):
        arg1 = self.memory[self.ip+1]
        arg2 = self.memory[self.ip+2]
        arg3 = self.memory[self.ip+3]

        realarg1 = -1
        realarg2 = -1
        realarg3 = -1

        if instr.p1mode ==0:
            realarg1 = self.memory[arg1]
        else:
            realarg1 = arg1
        if instr.p2mode == 0:
            realarg2 = self.memory[arg2]
        else:
            realarg2 = arg2
        if instr.p3mode == 0:
            realarg3 = self.memory[arg3]
        else:
            realarg3 = arg3

        if realarg1 < realarg2:
            self.memory[realarg3] = 1
        else:
            self.memory[realarg3] = 0

        self.ip = self.ip + 4
    
    def handle_equals(self,instr):
        arg1 = self.memory[self.ip+1]
        arg2 = self.memory[self.ip+2]
        arg3 = self.memory[self.ip+3]

        realarg1 = -1
        realarg2 = -1
        realarg3 = -1

        if instr.p1mode ==0:
            realarg1 = self.memory[arg1]
        else:
            realarg1 = arg1
        if instr.p2mode == 0:
            realarg2 = self.memory[arg2]
        else:
            realarg2 = arg2
        if instr.p3mode == 0:
            realarg3 = self.memory[arg3]
        else:
            realarg3 = arg3

        if realarg1 == realarg2:
            self.memory[realarg3] = 1
        else:
            self.memory[realarg3] = 0

        self.ip = self.ip + 4

    def cycle(self):
        if self.halt:
            print("WARN:comp is halted not executing cycle")

        instr = self.decode_instr(self.memory[self.ip])
        if instr.opcode == 1:
            self.handle_add(instr)
        elif instr.opcode ==2:
            self.handle_mult(instr)
        elif instr.opcode == 3:
            self.handle_input(instr)
        elif instr.opcode == 4:
            self.handle_output(instr)
        elif instr.opcode == 5:
            self.handle_jmp_if_true(instr)
        elif instr.opcode == 6:
            self.handle_jmp_if_false(instr)
        elif instr.opcode == 7:
            self.handle_less_than(instr)
        elif instr.opcode == 8:
            self.handle_equals(instr)
        elif instr.opcode == 99:
            self.handle_term(instr)

    def check_memory(self,inc_mem):
        index = 0
        for i in inc_mem:
            if self.memory[index] != i:
                return False
            index = index + 1
        return True

    def __repr__(self):
        ts = ""
        ts = ts + "ip: " + str(self.ip)
        ts = ts + "\n"
        for i in range(len(self.memory)):
            ts = ts + " " + str(self.memory[i])
        
        return ts

def unit_test1(input,correct):
    comp = Computer()
    comp.loads(input)
    while True:
        # print(comp)
        comp.cycle()
        if comp.halt:
            # print("main loop halt caught stopping computer")
            break
    if comp.check_memory(correct):
        print("passed")
    else:
        print("failed")

def unit_test2():
    import time
    comp = Computer()
    comp.loads("3,9,8,9,10,9,4,9,99,-1,8")
    comp.take_input(8)
    while True:
        print(comp.ip)
        print(comp)
        comp.cycle()
        if comp.halt:
            break
        time.sleep(1)
    if comp.output==1:
        print("passed")
    else:
        print("failed")

def all_unit_tests():
    unit_test1("1,9,10,3,2,3,11,0,99,30,40,50",[3500,9,10,70,2,3,11,0,99,30,40,50])
    unit_test1("1,0,0,0,99",[2,0,0,0,99])
    unit_test1("2,3,0,3,99",[2,3,0,6,99])
    unit_test1("2,4,4,5,99,0", [2,4,4,5,99,9801])
    unit_test1("1,1,1,4,99,5,6,0,99",[30,1,1,4,2,5,6,0,99])
    unit_test1("1002,4,3,4,33",[1002,4,3,4,99])
    unit_test2()

all_unit_tests()