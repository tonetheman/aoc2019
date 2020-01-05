

import computer

def check_mult():
    # ppp
    def test1():
        comp = computer.Computer()
        comp.loads("3,15,3,16,2,15,16,17,4,17,99")
        comp.take_input(100)
        comp.take_input(200)
        comp.debug = True
        comp.run()

        print(comp)
        print(comp.output,100*200)

    #ipp
    def test2():
        comp = computer.Computer()
        comp.loads("3,15,3,16,102,15,16,17,4,17,99")
        comp.take_input(100)
        comp.take_input(200)
        comp.debug = True
        comp.run()

        print(comp)
        comp.check_memory_pos(17,15*200)
        print(comp.output,15*200)

    #pip
    def test3():
        comp = computer.Computer()
        comp.loads("3,15,3,16,1002,15,16,17,99")
        comp.take_input(100)
        comp.take_input(200)
        comp.debug = True
        comp.run()

        print(comp)
        comp.check_memory_pos(17,100*16)

    #iip
    def test4():
        comp = computer.Computer()
        comp.loads("3,15,3,16,1102,15,16,17,4,17,99")
        comp.take_input(100)
        comp.take_input(200)
        comp.debug = True
        comp.run()

        print(comp)
        comp.check_memory_pos(17,15*16)
        print(comp.output,15*16)

    test1()
    test2()
    test3()
    test4()

def check_add():

    # ppp
    def test1():
        comp = computer.Computer()
        comp.loads("3,15,3,16,1,15,16,17,4,17,99")
        comp.take_input(40)
        comp.take_input(41)
        comp.debug = True
        comp.run()
        print(comp.output, 40+41)

    #pip
    def test2():
        comp = computer.Computer()
        comp.loads("3,15,3,16,1001,15,16,17,4,17,99")
        comp.take_input(40)
        comp.take_input(41)
        comp.debug = True
        comp.run()
        print(comp.output, 40+16)
    
    #ipp
    def test3():
        comp = computer.Computer()
        comp.loads("3,15,3,16,101,15,16,17,4,17,99")
        comp.take_input(40)
        comp.take_input(41)
        comp.debug = True
        comp.run()
        print(comp.output, 15+41)

    #iip
    def test4():
        comp = computer.Computer()
        comp.loads("3,15,3,16,1101,15,16,17,4,17,99")
        comp.take_input(40)
        comp.take_input(41)
        comp.debug = True
        comp.run()
        print(comp.output, 15+16)


    test1()
    test2()
    test3()
    test4()

def check_jmptrue():

    def test1():
        comp = computer.Computer()
        comp.loads("3,15,3,16,5,15,16,104,1000,99,4,2000,99")
        comp.take_input(1)
        comp.take_input(10)
        comp.debug = True
        comp.run()
        print("output is",comp.output)
    test1()

check_jmptrue()