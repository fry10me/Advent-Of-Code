import re
import numpy as np
d = open("AoC_2015\data\p15_data.txt").read().splitlines() 
N = len(d)

idx = 0
arr = np.zeros((N,5), dtype=int)
for line in d:
    capacity, durability, flavor, texture, calories = map(int, re.findall('-?\d+', line))
    arr[idx,:] = [capacity, durability, flavor, texture, calories]
    idx += 1
cookies = arr

bestScore = 0
bestScore500 = 0
for i in range(101):
    for j in range(101-i):
        for k in range(101-i-j):
            l = 100 - i - j - k
            scores = [i*arr[0][x] + j*arr[1][x] + k*arr[2][x] + l*arr[3][x] for x in range(0,5)]
            if min(scores) > 0:
                score = np.prod(scores[:-1])
                bestScore = max(bestScore,score)
                if scores[4] == 500:
                    bestScore500 = max(bestScore500,score)

print("PART 1:", bestScore)
print("PART 2:", bestScore500)