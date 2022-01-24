import re
d = open('AoC_2015\data\p19_data.txt').read().splitlines()

elements, rules = set(), dict()
for i in range(len(d)-2):
    a,b = re.split(' => ',d[i])
    if not a in rules:
        rules[a] = list()
    rules[a].append(b)
    elements.add(a)
startMolecule = d[-1]

molecules = set()
for e in elements:
    eLen = len(e)
    eIdx = [x.start(0) for x in re.finditer(e, d[-1])]
    for idx in eIdx:
        for replace in rules[e]:
            molecules.add(startMolecule[:idx] + replace + startMolecule[idx+eLen:])
print("PART 1:", len(molecules))

nElement, nArRn, nY = len(re.findall('[A-Z]', startMolecule)), len(re.findall('(Rn|Ar)', startMolecule)), len(re.findall('Y', startMolecule))
print("PART 2:", nElement - nArRn - 2*nY - 1)