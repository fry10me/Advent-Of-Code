import numpy as np
d = open("AoC_2015\data\p3_data.txt").read()

def MOVE(arr,idx,direction,houses):
    if direction == '^':
        idx[0] += 1
        arr[idx[0],idx[1]] += 1
    elif direction == 'v':
        idx[0] -= 1
        arr[idx[0],idx[1]] += 1
    elif direction == '>':
        idx[1] += 1
        arr[idx[0],idx[1]] += 1
    else:
        idx[1] -= 1
        arr[idx[0],idx[1]] += 1
    if arr[idx[0],idx[1]] == 1:
        houses += 1
    return houses
    
idx,idx1,idx2 = np.array([250,250]),np.array([250,250]),np.array([250,250])
arr1,arr2 = np.zeros((500,500)),np.zeros((500,500))
housesSanta,housesBoth = 0,0
for i in range(len(d)):
    housesSanta = MOVE(arr1,idx,d[i],housesSanta) 
    if i%2 == 0:
        housesBoth = MOVE(arr2,idx1,d[i],housesBoth) 
    else:
        housesBoth = MOVE(arr2,idx2,d[i],housesBoth)

print("PART 1:",housesSanta)
print("PART 2:",housesBoth)




