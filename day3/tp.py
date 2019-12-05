PORTAL = (0,0)

def dist(p1,p2):
    return abs(p1[0]-p2[0]) + abs(p1[1]-p2[1])

def genpoints(data,pathid):
    data = data.split(",")
    cp = (0,0) # current point
    points = set()
    points.add((0,0))
    for d in data:
        curx=cp[0]
        cury=cp[1]

        if d[0]=="U":
            dist = int(d[1:])
            for i in range(1,dist+1):
                points.add((curx,cury+i))
                cp = (curx,cury+i)
        elif d[0] == "R":
            dist = int(d[1:])
            for i in range(1,dist+1):
                points.add((curx+i,cury))
                cp = (curx+i,cury)
        elif d[0] == "L":
            dist = int(d[1:])
            for i in range(1,dist+1):
                points.add((curx-i,cury))
                cp = (curx-i,cury)
        elif d[0] == "D":
            dist = int(d[1:])
            for i in range(1,dist+1):
                points.add((curx,cury-i))
                cp = (curx,cury-i)
    return points


def doit(data1,data2):
    print "generating point..."
    points1 = genpoints(data1,1)
    points2 = genpoints(data2,2)

    res = points1 & points2
    answer = 999999999
    for p in res:
        if p == (0,0):
            continue
        di = dist(PORTAL,p)
        print p,di
        if di<answer:
            answer = di
    print answer

    """
    print "About to compare ..."
    answer = 99999999999
    for i in points1:
        for j in points2:
            if i==(0,0) and j==(0,0):
                continue
            if i==j:
                di = dist(PORTAL,i)
                if di<answer:
                    answer = di
                print "match",i,j, di
    print "final",answer
    """

def test():
    data1 = "U7,R6,D4,L4"
    data2= "R8,U5,L5,D3"
    doit(data1,data2)

def test1():
    data1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    data2 = "U62,R66,U55,R34,D71,R55,D58,R83"
    doit(data1,data2)

def test2():
    data1="R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    data2="U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    doit(data1,data2)

def part1():
    inf = open("data.txt","r")
    data1 = inf.readline()
    data2 = inf.readline()
    inf.close()
    import string
    data1 = string.strip(data1)
    data2 = string.strip(data2)
    doit(data1,data2)

part1()