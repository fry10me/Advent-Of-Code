import sys
from itertools import permutations
d = open("AoC_2015\data\p9_data.txt").read().splitlines() 

locations = set()
distances = dict()
for info in d:
    a,_,b,_,dist = info.split()
    locations.add(a)
    locations.add(b)
    distances.setdefault(a, dict())[b] = int(dist)
    distances.setdefault(b, dict())[a] = int(dist)

minPath = sys.maxsize
maxPath = 0
for perms in permutations(locations):
    dist = 0
    for i in range(len(perms)-1):
        dist += distances[perms[i]][perms[i+1]]
    if dist > maxPath:
        maxPath = dist
    if dist < minPath:
        minPath = dist

print("PART 1:",minPath)
print("PART 2:",maxPath)