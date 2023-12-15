import numpy as np
d = int(open('AoC_2015\data\p20_data.txt').read())

nMax = 1000000
houses1 = np.ones(nMax) 
houses2 = np.ones(nMax) * 11
for elf in range(2,nMax):
    houses1[elf::elf] += elf * 10
    houses2[elf:(elf+1)*50:elf] += elf * 11
print("PART 1:", np.nonzero(houses1 >= d)[0][0])
print("PART 2:", np.nonzero(houses2 >= d)[0][0])