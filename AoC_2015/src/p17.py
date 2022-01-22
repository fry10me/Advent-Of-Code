d = [int(x) for x in open("AoC_2015\data\p17_data.txt").read().splitlines()]

def COMBINATIONS(numbers, target, partial, c, v):
    total = sum(partial)
    if total == target:
        if v == 0:
            c.append(partial)
        elif len(partial) == 4:
            c.append(partial)
    if total >= target:
        return c   

    for i in range(len(numbers)):
        n = numbers[i]
        remaining = numbers[i + 1:]
        COMBINATIONS(remaining, target, partial + [n], c, v)
    return c

c = COMBINATIONS(d, 150, [], [], 0)
print("PART 1:", len(c))
minLen = min([len(x) for x in c])
print("PART 2:", len(COMBINATIONS(d, 150, [], [], minLen)))