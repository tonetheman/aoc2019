
def calc(n):
    return n/3-2

def part1():
    inf = open("data.txt","r")
    data = inf.readlines()
    inf.close()

    print data

    import string
    data = map(string.strip,data)

    print data

    data = map(int,data)
    print data

    total = 0
    for d in data:
        val = calc(d)
        total = total + val
    
    print total


def part2():
    inf = open("data.txt","r")
    data = inf.readlines()
    inf.close()

    print data

    import string
    data = map(string.strip,data)

    print data

    data = map(int,data)
    print data

    total = 0
    for d in data:
        tinysum = 0
        while True:
            val = calc(d)
            if val>0:
                tinysum = tinysum + val
                d = val
            else:
                break
        total = total + tinysum


    print total

part2()
