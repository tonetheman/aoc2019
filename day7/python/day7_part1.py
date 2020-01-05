
import computer

data = open("day7_data.txt","r").read()

def check(i1,i2,i3,i4,i5):

    def runone(input_value,current_output):
        comp = computer.Computer()
        # comp.loads("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
        # comp.loads("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")
        # comp.loads("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0")
        comp.loads(data)
        comp.take_input(input_value)
        comp.take_input(current_output)
        comp.debug = True
        while True:
            comp.cycle()
            if comp.halt:
                print("normal halt")
                break
            if comp.did_output_this_cycle:
                print("did output stopping")
                break
        print(comp.output)
        # current_output = comp.output
        return comp.output

    f1 = runone(i1,0)
    f2 = runone(i2,f1)
    f3 = runone(i3,f2)
    f4 = runone(i4,f3)
    f5 = runone(i5,f4)
    print("final",f5)
    return f5


from itertools import permutations
perm = permutations([0,1,2,3,4])
maxval = -1
maxindex = -1
index = 0
junk = []
for p in perm:
    res = check(p[0],p[1],p[2],p[3],p[4])
    if res>maxval:
        maxval = res
        maxindex = index
    junk.append(p)
    index = index + 1

print("final",maxval,junk[maxindex])