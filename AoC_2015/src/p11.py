import re
import math
d = open("AoC_2015\data\p11_data.txt").read()
N = len(d)

def ROT(d,N):
    if d[-1] == 'z':
        zIdx = d.index('z')
        if zIdx > 0:
            d = d[0:zIdx-1] + chr(ord(d[zIdx-1])+1) + (N-zIdx) * 'a'
        else:
            d = N * 'a'
    else:
        d = d[0:-1] + chr(ord(d[-1])+1)
    return d

def RULE1(d,N):
    dAscii = [ord(letter) for letter in d]
    for i in range(N-2):
        if dAscii[i+1] == dAscii[i]+1 and dAscii[i+2] == dAscii[i+1]+1:
            return True 
    return False

def RULE2(d,N):
    dList = [m.group(0) for m in re.finditer(r"([\w])\1*", d)]
    count = 0
    for i in dList:
        count += math.floor(len(i)/2)
        if count >= 2:
            return True
    return False

def RULE3(d,N):
    idx = []
    if 'i' in d:
        idx.append(d.index('i'))
    if 'l' in d:
        idx.append(d.index('l'))
    if 'o' in d:
        idx.append(d.index('o'))
    idx = min(idx)
    return d[0:idx] + chr(ord(d[idx])+1) + (N-idx-1) * 'a'

def SOLVE(d,N):
    while 1:
        if 'i' in d or 'l' in d or 'o' in d:
            d = RULE3(d,N)
        if RULE1(d,N) and RULE2(d,N):
            return d
        else:
            d = ROT(d,N)

d = SOLVE(d,N)
print("PART 1:", d)
print("PART 2:", SOLVE(ROT(d,N),N))