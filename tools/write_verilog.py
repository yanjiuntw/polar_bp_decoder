#! /bin/python3

def __input(name, n):
    template = "    input  [SIZE - 1:0] " + name 
    for i in range(n):
        print(template + str(i) + ",")

def __output(name, n):
    template = "    output [SIZE - 1:0] " + name 
    for i in range(n):
        print(template + str(i) + ",")

def writeIO(n):
    __input("in", n)
    print()
    __output("out", n)

def __assign(name1, name2, n):
    for i in range(n):
        print("        assign " + name1 + "[" + str(i) + "] = " + name2  + str(i) + ";") 

def __rstMem(n):
    for i in range(n):
        template = "            mem["+str(i)+"][0][1] <= in"+str(i)+";"
        print(template)
    for i in range(n):
        template = "            mem["+str(i)+"][STEP][0] <= in"+str(i)+";"
        print(template)

def cal(s):
    sum = 0
    t = 0.5
    for i in range(len(s)):
        sum += t
        t /= 2
    return sum
