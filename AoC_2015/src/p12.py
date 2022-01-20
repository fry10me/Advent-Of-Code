import re
import json
d = open("AoC_2015\data\p12_data.txt").read()

def PART1(d):
    return sum(map(int,re.findall('-?\d+', d)))
print("PART 1:",PART1(d))

def PART2(d):
    if type(d) == type(dict()):
        if "red" in d.values():
            return 0
        return sum(map(PART2, d.values()))
    if type(d) == type(list()):
        return sum(map(PART2, d))
    if type(d) == type(0):
        return d
    return 0
print("PART 1:",PART2(json.loads(d)))