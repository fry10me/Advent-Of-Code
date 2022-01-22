import re
d = open("AoC_2015\data\p16_data.txt").read().splitlines() 

theRealSue = {'children': 3, 'cats': 7, 'samoyeds': 2, 'pomeranians': 3, 'akitas': 0,
'vizslas': 0, 'goldfish': 5, 'trees': 3, 'cars': 2, 'perfumes': 1}

SueFound1, SueFound2 = False,False
for i in range(len(d)):
    Sue = re.sub('Sue \d+: ', '', d[i])
    SueKeys = re.findall('[A-Za-z]+',Sue)
    SueVals = [int(x) for x in re.findall('[0-9]+',Sue)]
    if not SueFound1:
        mismatch = False
        for j in range(len(SueKeys)):    
            if not SueVals[j] == 0:
                if not theRealSue[SueKeys[j]] == SueVals[j]:
                    mismatch = True
                    break
        if not mismatch:
            SueFound1 = True
            print("PART 1:", i+1)
    if not SueFound2:
        mismatch = False
        for j in range(len(SueKeys)): 
            if SueKeys[j] == 'cats' or SueKeys[j] == 'trees':
                if not theRealSue[SueKeys[j]] < SueVals[j]:                       
                    mismatch = True
                    break
            elif SueKeys[j] == 'pomeranians' or SueKeys[j] == 'goldfish':
                if not theRealSue[SueKeys[j]] > SueVals[j]:
                    mismatch = True
                    break
            else:
                 if not SueVals[j] == 0 and  not theRealSue[SueKeys[j]] == SueVals[j]:
                    mismatch = True
                    break
        if not mismatch:
            SueFound2 = True
            print("PART 2:", i+1)  
    if SueFound1 and SueFound2:
        break