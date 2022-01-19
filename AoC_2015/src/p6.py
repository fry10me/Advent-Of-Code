import re
import numpy as np
d = open("AoC_2015\data\p6_data.txt").read().splitlines() 

arr1, arr2 = np.zeros(shape=(1000,1000), dtype=np.int64), np.zeros(shape=(1000,1000), dtype=np.int64)
for instr in d:
    x1,y1,x2,y2 = [int(s) for s in re.split(' |,',instr) if s.isdigit()]
    if "toggle" in instr:
        for x in range(x1, x2 + 1):
            for y in range(y1, y2 + 1):
                arr1[x][y] = 1 - arr1[x][y]
        arr2[x1:x2+1:1,y1:y2+1:1] += 2
    elif "turn on" in instr:
        arr1[x1:x2+1:1,y1:y2+1:1] = 1
        arr2[x1:x2+1:1,y1:y2+1:1] += 1
    else:
        arr1[x1:x2+1:1,y1:y2+1:1] = 0
        arr2[x1:x2+1:1,y1:y2+1:1] -= 1
        arr2[arr2 < 0] = 0
print("PART 1:",sum(map(sum,arr1)))  
print("PART 2:",sum(map(sum,arr2)))  