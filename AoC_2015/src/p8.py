d = open("AoC_2015\data\p8_data.txt").read().splitlines() 

n1,n2 = 0,0
for words in d:
    n1 += len(words)-len(eval(words))
    n2 += 2+words.count('\\')+words.count('"') 
    
print("PART 1:",n1)
print("PART 2:",n2)