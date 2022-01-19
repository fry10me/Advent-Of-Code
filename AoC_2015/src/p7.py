import re
d = open("AoC_2015\data\p7_data.txt").read().splitlines() 
d = [re.split(' -> | ', x) for x in d]

def DIGEST(value, operator):
    if len(value) == 1:
        newVal = ~value[0]
    else:
        if operator == 'AND':
            newVal = value[0] & value[1]
        elif operator == 'OR':
            newVal = value[0] | value[1]
        elif operator == 'LSHIFT':
            newVal = value[0] << value[1]
        else:
            newVal = value[0] >> value[1]
    return newVal

def SOLVE(d):
    known = {}
    for i in range(len(d)-1,-1,-1):
        if len(d[i]) == 2 and d[i][0].isnumeric():
            known[d[i][1]] = d[i][0]
            del d[i]
    while d:
        for i in range(len(d)-1,-1,-1):
            if len(d[i]) == 2 and d[i][0] in known.keys():
                known[d[i][1]] = known[d[i][0]]
                del d[i]
            elif len(d[i]) == 3 and d[i][1] in known.keys():
                known[d[i][2]] = DIGEST([int(known[d[i][1]])],d[i][0])
                del d[i]
            else:
                if d[i][0] in known.keys():
                    val1 = int(known[d[i][0]])
                elif d[i][0].isnumeric():
                    val1 = int(d[i][0])
                else:
                    continue
                if d[i][2] in known.keys():
                    val2 = int(known[d[i][2]])
                elif d[i][2].isnumeric():
                    val2 = int(d[i][2])
                else:
                    continue
                known[d[i][3]] = DIGEST([val1,val2],d[i][1])
                del d[i]
    return int(known['a'])

a = SOLVE(d.copy())
print("PART 1",a)
for i in range(len(d)-1,-1,-1):
        if len(d[i]) == 2 and d[i][1] == 'b':
            d[i][0] = str(a)
print("PART 2",SOLVE(d))