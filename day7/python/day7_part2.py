import computer

comp1 = computer.Computer()
comp1.loads("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")
comp2 = computer.Computer()
comp2.loads("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")
comp3 = computer.Computer()
comp3.loads("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")
comp4 = computer.Computer()
comp4.loads("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")
comp5 = computer.Computer()
comp5.loads("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")


i1 = 9
i2 = 8
i3 = 7
i4 = 6
i5 = 5
first_input = 0
someone_halted = False

while True:
    if someone_halted:
        break
    print("------------------------------------")
    # comp1.clear_input()
    comp1.take_input(i1)
    comp1.take_input(first_input)
    comp1.debug = True
    print("start:comp1:input",comp1.input.qsize())
    while True:
        comp1.cycle()
        if comp1.halt:
            print("normal halt")
            someone_halted = True
            break
        if comp1.did_output_this_cycle:
            print("did output stopping")
            break
    print(comp1.output)

    # comp2.clear_input()
    comp2.take_input(i2)
    comp2.take_input(comp1.output)
    comp2.debug = True
    while True:
        comp2.cycle()
        if comp2.halt:
            print("normal halt")
            someone_halted = True
            break
        if comp2.did_output_this_cycle:
            print("did output stopping")
            break
    print(comp2.output)

    # comp3.clear_input()
    comp3.take_input(i3)
    comp3.take_input(comp2.output)
    comp3.debug = True
    while True:
        comp3.cycle()
        if comp3.halt:
            print("normal halt")
            someone_halted = True
            break
        if comp3.did_output_this_cycle:
            print("did output stopping")
            break
    print(comp3.output)

    # comp4.clear_input()
    comp4.take_input(i4)
    comp4.take_input(comp3.output)
    comp4.debug = True
    while True:
        comp4.cycle()
        if comp4.halt:
            print("normal halt")
            someone_halted = True
            break
        if comp4.did_output_this_cycle:
            print("did output stopping")
            break
    print(comp4.output)

    # comp5.clear_input()
    comp5.take_input(i5)
    comp5.take_input(comp4.output)
    comp5.debug = True
    while True:
        comp5.cycle()
        if comp5.halt:
            print("normal halt")
            someone_halted = True
            break
        if comp5.did_output_this_cycle:
            print("did output stopping")
            break
    print(comp5.output)
    first_input = comp5.output

print("final output from comp5 is",comp5.output)
