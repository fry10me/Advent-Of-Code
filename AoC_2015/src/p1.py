d = open("AoC_2015\data\p1_data.txt").read()

score = 0
found = False
for i  in range(len(d)):
    if d[i] == '(':
        score += 1
    else:
        score -= 1
    if not found and score == -1:
        found = True
        basement = i+1

print("PART1:", score)
print("PART2:", basement)