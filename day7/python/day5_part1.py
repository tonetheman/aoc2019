data = open("day5_data.txt","r").read()
import computer
comp = computer.Computer()
comp.loads(data)
comp.take_input(1)
while True:
    comp.cycle()
    if comp.halt:
        break
print(comp.output)