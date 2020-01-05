

data = open("day2_data.txt","r").read()
import computer
comp = computer.Computer()
comp.loads(data)
comp.memory[1] = 12
comp.memory[2] = 2
while True:
    comp.cycle()
    if comp.halt:
        break
print(comp.memory[0])