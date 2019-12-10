

import sys
    
instr = [1,10,11,12,99,0,0,0,0,0,2,3,9999]
input = []
output = []

ip = 0
while True:
    tmp_op = instr[ip]
    current_op = "%05d" % (tmp_op,)
    print "current op", current_op
    real_opcode = int(current_op[3:])
    param1mode = current_op[2]
    param2mode = current_op[1]
    param3mode = current_op[0]
    print "real op", real_opcode
    if real_opcode == 1:
        # add
        arg1 = instr[ip+1]
        arg2 = instr[ip+2]
        arg3 = instr[ip+3]
        if param1mode == 0: # position
            arg1 = instr[arg1]
        elif param1mode == 1: # immediate
            pass # do nothing
        if param2mode == 0: # position
            arg2 = instr[arg2]
        elif param2mode == 1: # immediate
            pass # do nothing
        print "add",arg1,arg2,arg3
        instr[arg3] = arg1 + arg2
        ip = ip + 4
    elif real_opcode == 2:
        # mult
        arg1 = instr[ip+1]
        arg2 = instr[ip+2]
        arg3 = instr[ip+3]

        ip = ip + 4 
    else:
        print "nope"
        print instr
        sys.exit(0)