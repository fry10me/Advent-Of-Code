import numpy as np
import itertools
import re
d = open('AoC_2015\data\p21_data.txt').read()

boss = [int(x) for x in re.findall('[0-9]+',d)]
weapons = np.array([[8,4,0],[10,5,0],[25,6,0],[40,7,0],[74,8,0]])
armours = np.array([[13,0,1],[31,0,2],[53,0,3],[75,0,4],[102,0,5]])
rings = np.array([[25,1,0],[50,2,0],[100,3,0],[20,0,1],[40,0,2],[80,0,3]])

def ISWIN(stats, boss):
    if boss[1] > stats[2]:
        turns = boss[0]/(boss[1] - stats[2])
    else:
        turns = boss[0]
    if stats[1] > boss[2]:
        ttWin = stats[0]/(stats[1] - boss[2])
    else:
        ttWin = stats[0]
    if ttWin <= turns:
        return True
    return False

setups = list()
armours = np.concatenate((armours,[[0,0,0]]),axis=0)
rings = np.concatenate((rings,[[0,0,0],[0,0,0]]),axis=0)
ringsComb = list(itertools.combinations([x for x in range(len(rings))], 2)) 
for w in weapons:
    for a in armours:
        for r in ringsComb:
            statsR = [rings[r[0]][0] + rings[r[1]][0], rings[r[0]][1] + rings[r[1]][1], rings[r[0]][2] + rings[r[1]][2]]
            statsSum = [a + b + c for a, b, c in zip(w,a,statsR)]
            setups.append(list([100] + statsSum))

setups = sorted(setups, key = lambda x: int(x[1]))
setups = list(setups for setups,_ in itertools.groupby(setups))
for s in setups:
    if ISWIN([s[0],s[2],s[3]], boss):
        print("PART 1:", s[1])
        break
        
setups = reversed(setups)
for s in setups:
    if not ISWIN([s[0],s[2],s[3]], boss):
        print("PART 2:", s[1])
        break