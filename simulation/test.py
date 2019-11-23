import numpy as np

def __g__(x, y):
    return 0.9375 * np.sign(x) * np.sign(y) * np.min([np.abs(x), np.abs(y)])

def __L1__(x, y, z):
    tmp = y + z
    return __g__(x, tmp)

def __L2__(x, y, z):
    tmp = __g__(x, y)
    return tmp + z

def __R1__(x, y, z):
    tmp = y + z
    return __g__(x, tmp)

def __R2__(x, y, z):
    tmp = __g__(x, y)
    return tmp + z

def __LChange__(arr):
    n = len(arr)
    tmp = np.zeros(n)
    for i in range(n):
        idx = (i * 2) % n + (i * 2) / n
        tmp[i] = arr[int(idx)] 
    return tmp

def __RChange__(arr):
    n = len(arr)
    tmp = np.zeros(n)
    for i in range(int(n / 2)):
       tmp[i * 2] = arr[i]
       tmp[i * 2 + 1] = arr[i + int(n / 2)] 
    return tmp

reg = []
_N = 8
_Step = 3
_L = [1, -1, -1, 1, -1, 1, 1,-1]
_F = [np.inf,np.inf,np.inf,0,np.inf,0,0,0]

def __read1024_2():
    global _L, _F
    _L = np.loadtxt("1024_llr_2.txt")
    _F = np.loadtxt("1024_frozen.txt")

def __read1024():
    global _L, _F
    _L = np.loadtxt("1024_llr.txt")
    _F = np.loadtxt("1024_frozen.txt")

def __read16():
    global _L, _F
    _L = np.loadtxt("16_llr.txt")
    _F = np.loadtxt("16_frozen.txt")

def __init():
    global reg
    global _N, _Step
    _N = len(_L)
    _Step = int(np.log2(_N))
    reg = np.zeros((_N, _Step + 1,2))
    reg[:, _Step, 0] = _L
    reg[:,0,1] = _F

def __LCalculate(stage):
    stage = _Step - stage
    global reg
    tmp = __RChange__(reg[:,stage-1,1])
    for i in range(int(_N / 2)):
        row = i * 2
        col = stage
        #reg[i * 2][stage - 1][0]     = __L1__(reg[row][col][0], reg[row + 1][col - 1][1], reg[row + 1][col][0])
        #reg[i * 2 + 1][stage - 1][0] = __L2__(reg[row][col - 1][1], reg[row][col][0], reg[row + 1][col][0])
        reg[i * 2][stage - 1][0]     = __L1__(reg[row][col][0], tmp[row + 1], reg[row + 1][col][0])
        reg[i * 2 + 1][stage - 1][0] = __L2__(tmp[row], reg[row][col][0], reg[row + 1][col][0])
    reg[:,stage - 1,0] = __LChange__(reg[:,stage - 1, 0])

def __RCalculate(stage):
    global reg
    tmp = __RChange__(reg[:,stage,1])
    for i in range(int(_N / 2)):
        row = i * 2
        col = stage
        #reg[i * 2][stage + 1][1]     = __R1__(reg[row][col][1], reg[row + 1][col][1], reg[row + 1][col + 1][0])
        #reg[i * 2 + 1][stage + 1][1] = __R2__(reg[row][col][1], reg[row][col + 1][0], reg[row + 1][col][1])
        reg[i * 2][stage + 1][1]     = __R1__(tmp[row], tmp[row + 1], reg[row + 1][col + 1][0])
        reg[i * 2 + 1][stage + 1][1] = __R2__(tmp[row], reg[row][col + 1][0], tmp[row + 1])

def bp_decoder():
    global reg
    for i in range(_Step):
        __LCalculate(i)
    print(reg[:,:,0])
    for i in range(_Step):
        __RCalculate(i)
    print(reg[:,:,1])
