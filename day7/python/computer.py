import sys
import queue

class OpCode:
    def __init__(self,opcode,p1mode,p2mode,p3mode):
        self.opcode = opcode
        self.p1mode = p1mode
        self.p2mode = p2mode
        self.p3mode = p3mode
    def pm(self,v):
        if v==0:
            return "p"
        elif v==1:
            return "i"
        else:
            return "?"
    def __repr__(self):
        return "{0} {1} {2} {3}".format(self.opcode,self.pm(self.p1mode),
            self.pm(self.p2mode),self.pm(self.p3mode))

class Computer:
    def __init__(self):
        self.ip = 0
        self.halt = False
        self.input = queue.Queue()
        self.memory = []
        self.output = None
        self.debug = False
        self.did_output_this_cycle = False
        for i in range(1024):
            self.memory.append(0)
    def dbg(self,*args):
        if not self.debug:
            return
        for a in args:
            print(str(a),end=" ")
        print()
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
        self.dbg("DBG:ADD",instr,arg1,arg2,arg3,realarg1,realarg2)
        self.memory[arg3] = realarg1 + realarg2
        self.ip = self.ip + 4

    def handle_mult(self,instr):
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
        self.dbg("DBG:MULT",instr,arg1,arg2,arg3,realarg1,realarg2)

        self.memory[arg3] = realarg1 * realarg2
        self.ip = self.ip + 4

    def take_input(self,input_value):
        self.input.put(input_value)

    def handle_input(self,instr):
        arg1 = self.memory[self.ip+1]
        if instr.p1mode!=0:
            print("ERR:p1mode is not 0 on input")
            sys.exit(0)
        input_value = self.input.get()
        self.dbg("DBG:INP",arg1,input_value)
        self.memory[arg1] = input_value
        self.ip = self.ip + 2

    def handle_output(self,instr):
        arg1 = self.memory[self.ip+1]
        if instr.p1mode == 0:
            self.output = self.memory[arg1]
        else:
            self.output = arg1
        self.dbg("DBG:OUT",instr,self.output)
        self.ip = self.ip + 2
        self.did_output_this_cycle = True

    def handle_term(self,instr):
        self.dbg("DBG:halt called")
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

        self.dbg("DBG:JMPTRUE",instr,arg1,arg2,realarg1,realarg2)

        if realarg1 != 0:
            self.ip = realarg2
        else:
            self.ip = self.ip + 3

    def handle_jmp_if_false(self,instr):
        # self.dbg("DBG:JMPFALSE")
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
        self.dbg("DBG:JMPFALSE",arg1,arg2,realarg1,realarg2)
        if realarg1 == 0:
            self.ip = realarg2
        else:
            self.ip = self.ip + 3

    def handle_less_than(self,instr):
        self.dbg("DBG:handle_less")
        arg1 = self.memory[self.ip+1]
        arg2 = self.memory[self.ip+2]
        arg3 = self.memory[self.ip+3]

        realarg1 = -1
        realarg2 = -1
        
        if instr.p1mode ==0:
            realarg1 = self.memory[arg1]
        else:
            realarg1 = arg1
        if instr.p2mode == 0:
            realarg2 = self.memory[arg2]
        else:
            realarg2 = arg2
        
        if instr.p3mode!=0:
            print("p3mode not zero stopping")
            sys.exit(-1)

        if realarg1 < realarg2:
            self.memory[arg3] = 1
        else:
            self.memory[arg3] = 0

        self.ip = self.ip + 4
    
    def handle_equals(self,instr):
        self.dbg("handle_eq")
        arg1 = self.memory[self.ip+1]
        arg2 = self.memory[self.ip+2]
        arg3 = self.memory[self.ip+3]
        # print("DBG:equals:args",arg1,arg2,arg3)
        realarg1 = -1
        realarg2 = -1
        
        if instr.p1mode ==0:
            realarg1 = self.memory[arg1]
        else:
            realarg1 = arg1
        if instr.p2mode == 0:
            realarg2 = self.memory[arg2]
        else:
            realarg2 = arg2

        if instr.p3mode != 0:
            print("p3mode on 8 bad")
            sys.exit(0)

        # print("\tDBG:equals:realargs",realarg1,realarg2)
        if realarg1 == realarg2:
            # print("\tDBG:writing a 1 to pos",arg3)
            self.memory[arg3] = 1
        else:
            self.memory[arg3] = 0

        self.ip = self.ip + 4

    def cycle(self):
        if self.halt:
            print("WARN:comp is halted not executing cycle")
            return
        
        self.did_output_this_cycle = False

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
        else:
            print("UNKNOWN instruction",self.ip,self.memory[self.ip:self.ip+8])
            sys.exit(-1)

    def check_memory(self,inc_mem):
        index = 0
        for i in inc_mem:
            if self.memory[index] != i:
                return False
            index = index + 1
        return True

    def clear_input(self):
        while not self.input.empty():
            self.input.get()
            
    def check_memory_pos(self,pos,value):
        if self.memory[pos] == value:
            print("pass")
        else:
            print("fail")

    def run(self):
        while True:
            self.cycle()
            if self.halt:
                print("normal halt")
                break

    def __repr__(self):
        ts = ""
        ts = ts + "ip: " + str(self.ip)
        ts = ts + "\n"
        for i in range(32):
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
    comp = Computer()
    comp.loads("3,9,8,9,10,9,4,9,99,-1,8")
    print("loaded")
    print("3,9,8,9,10,9,4,9,99,-1,8")
    comp.take_input(8)
    while True:
        print("-------------------")
        print(comp)
        comp.cycle()
        if comp.halt:
            print("halting normally")
            break
    print("comp output is",comp.output)
    if comp.output==1:
        print("passed")
    else:
        print("failed")

def unit_test3():
    comp = Computer()
    comp.loads("3,9,7,9,10,9,4,9,99,-1,8")
    comp.take_input(7)
    while True:
        comp.cycle()
        if comp.halt:
            print("halting normally")
            break
    print("comp output is",comp.output)

def unit_test4():
    comp = Computer()
    comp.loads("3,3,1108,-1,8,3,4,3,99")
    comp.take_input(8)
    while True:
        comp.cycle()
        if comp.halt:
            print("halting normally")
            break
    print("comp output is",comp.output)

def unit_test5():
    comp = Computer()
    comp.loads("3,3,1107,-1,8,3,4,3,99")
    comp.take_input(7)
    while True:
        comp.cycle()
        if comp.halt:
            print("halting normally")
            break
    print("comp output is",comp.output)

def unit_test6():
    comp = Computer()
    comp.loads("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9")
    comp.take_input(100)
    while True:
        print("-------------------")
        print(comp)
        comp.cycle()
        if comp.halt:
            print("halting normally")
            break
    print("comp output is",comp.output)

def unit_test7():
    comp = Computer()
    comp.loads("3,3,1105,-1,9,1101,0,0,12,4,12,99,1")
    comp.take_input(10)
    while True:
        comp.cycle()
        if comp.halt:
            print("halting normally")
            break
    print("comp output is",comp.output)

def unit_test8():
    def runone(input_number):
        comp = Computer()
        comp.loads("""3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
    1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
    999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99""")
        comp.take_input(input_number)
        while True:
            comp.cycle()
            if comp.halt:
                print("halting normally")
                break
        print("comp output is",comp.output)
    for i in range(10):
        print("running",i)
        runone(i)

def all_unit_tests():
    unit_test1("1,9,10,3,2,3,11,0,99,30,40,50",[3500,9,10,70,2,3,11,0,99,30,40,50])
    unit_test1("1,0,0,0,99",[2,0,0,0,99])
    unit_test1("2,3,0,3,99",[2,3,0,6,99])
    unit_test1("2,4,4,5,99,0", [2,4,4,5,99,9801])
    unit_test1("1,1,1,4,99,5,6,0,99",[30,1,1,4,2,5,6,0,99])
    unit_test1("1002,4,3,4,33",[1002,4,3,4,99])
    unit_test2()

# all_unit_tests()
# unit_test8()
