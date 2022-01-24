import numpy as np
from copy import deepcopy
d = open('AoC_2015\data\p18_data.txt').read().splitlines()

state = [[1 if x == '#' else 0 for x in group] for group in d]
state = np.pad(state, ((1,1),(1,1)), 'constant')

def PART1(state):
    for _ in range(100):
        nextState = deepcopy(state)
        for y in range(1,state.shape[1]-1):
            for x in range(1,state.shape[1]-1):
                adj = [state[y-1,x-1], state[y-1,x], state[y-1,x+1], state[y,x+1], 
                state[y+1,x+1], state[y+1,x], state[y+1,x-1], state[y,x-1]]
                adjOn = sum(adj)
                if state[y,x] == 1:
                    if adjOn == 2 or adjOn == 3:
                        nextState[y,x] = 1
                    else:
                        nextState[y,x] = 0
                else:
                    if adjOn == 3:
                        nextState[y,x] = 1
        state = nextState
    return sum(sum(state))

def PART2(state):
    state[1,1], state[1,-2], state[-2,1], state[-2,-2] = 1, 1, 1, 1
    for _ in range(100):
        nextState = deepcopy(state)
        for y in range(1,state.shape[1]-1):
            for x in range(1,state.shape[1]-1):
                adj = [state[y-1,x-1], state[y-1,x], state[y-1,x+1], state[y,x+1], 
                state[y+1,x+1], state[y+1,x], state[y+1,x-1], state[y,x-1]]
                adjOn = sum(adj)
                if state[y,x] == 1:
                    if adjOn == 2 or adjOn == 3:
                        nextState[y,x] = 1
                    else:
                        nextState[y,x] = 0
                else:
                    if adjOn == 3:
                        nextState[y,x] = 1
        state = nextState
        state[1,1], state[1,-2], state[-2,1], state[-2,-2] = 1, 1, 1, 1
    return sum(sum(state))

print("PART1:", PART1(state))
print("PART2:", PART2(state))