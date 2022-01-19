import re
d = open("AoC_2015\data\p10_data.txt").read()

for i in range(50):
    dList = [m.group(0) for m in re.finditer(r"(\d)\1*", d)]
    chunks = []
    for groups in dList:
        chunks.append(str(len(groups))+groups[0])
    d = ''.join(chunks)
    if i == 40:
        print("PART 1:",len(d))
print("PART 2:",len(d))