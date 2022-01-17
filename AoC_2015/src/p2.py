
with open('AoC_2015\data\p2_data.txt') as f:
    d = [ line.strip() for line in f ]

wpaper = 0
ribbon = 0
for i in range(len(d)):
    dim = d[i].split('x')
    dim = [int(i) for i in dim]
    dim.sort()
    wpaper += 2*dim[0]*dim[1] + 2*dim[1]*dim[2] + 2*dim[2]*dim[0] + min([dim[0]*dim[1],dim[1]*dim[2],dim[2]*dim[0]])
    ribbon += dim[0]*dim[1]*dim[2] + dim[0]*2 + dim[1]*2
    
print("PART1: WRAPPING PAPER", wpaper)
print("PART1: RIBBON",ribbon)