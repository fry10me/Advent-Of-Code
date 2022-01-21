import numpy as np
d = open("AoC_2015\data\p14_data.txt").read().splitlines() 
tTotal = 2503
N = len(d)
arr = np.zeros((N,tTotal),dtype=int)

for i in range(N):
    time,dist = 0,0
    name,_,_,speed,_,_,duration,_,_,_,_,_,_,rest,_ = d[i].split()
    speed,duration,rest = int(speed),int(duration),int(rest)
    while time < tTotal:
        if time < tTotal - duration:
            for j in range(time,time+duration):
                if j == 0:
                    arr[i,j] = speed
                else:
                    arr[i,j] = arr[i,j-1] +  speed
        else:
            for j in range(time,tTotal):
                arr[i,j] = arr[i,j-1] + speed
        time += duration

        if time < tTotal:
            if time < tTotal - rest:
                arr[i,time:time+rest] = arr[i,time-1]
            else:
                arr[i,time:] = arr[i,time-1]
            time += rest
print("PART 1:", max(arr[:,-1]))

scores = np.zeros(N, dtype=int)
for i in range(tTotal):
    check = np.max(arr[:,i])
    winners = np.flatnonzero(arr[:,i] == np.max(arr[:,i]))
    scores[winners] += 1
print("PART 2:", max(scores))