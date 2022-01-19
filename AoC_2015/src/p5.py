import re
d = open("AoC_2015\data\p5_data.txt").read().splitlines()

count = 0
for s in d:
    if len([x for x in s if x in "aeiou"]) > 2 and not any(x in s for x in ["ab", "cd", "pq", "xy"]) and re.search(r"([a-z])\1", s):
        count += 1
print("PART 1:",count)

count = 0
for s in d:
      if len(re.findall(r"([a-z]{2}).*\1", s)) and re.findall(r"([a-z]).\1", s):
          count += 1
print("PART 2:",count)
