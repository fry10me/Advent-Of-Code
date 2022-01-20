from itertools import permutations
import sys
d = open("AoC_2015\data\p13_data.txt").read().splitlines() 

def SOLVE(people,scores):
    bestH = -sys.maxsize-1
    adj = [x for x in range(len(people))]
    adj.append(0)
    for perms in permutations(people):
        h = 0   
        for i in range(len(people)):
            a,b = perms[adj[i]],perms[adj[i+1]]
            h += scores[(a, b)] + scores[(b, a)]
        if h > bestH:
            bestH = h
    return bestH

people = set()
scores = dict()
for line in d:
    a,_,sign,val,_,_,_,_,_,_,b = line[:-1].split()
    people.add(a)
    people.add(b)
    if sign == 'gain':
        scores[(a,b)] = int(val)
    else:
        scores[(a,b)] = int(val)*-1
print("PART 1:",SOLVE(people,scores))

for person in people:
    scores[('Myself', person)] = 0
    scores[(person, 'Myself')] = 0
people.add('Myself')
print("PART 2:",SOLVE(people,scores))