from hashlib import md5
d = open("AoC_2015\data\p4_data.txt").read()

n = 1
found5,found6 = False,False
while not found6:
    h = md5((d + str(n)).encode()).hexdigest()
    if not found5 and h[:5] == '00000':
        n5 = n
        print("PART 1:",n5)
        found5 = True
    if h[:6] == '000000':
        n6 = n
        print("PART :",n6)
        found6 = True
    n += 1
