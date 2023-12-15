import re
import copy
d = open('AoC_2015\data\p22_data.txt').read()

boss = [int(x) for x in re.findall('[0-9]+',d)]
stats = [50,500]
spells = [[53,4,0,0,0,0],[73,2,0,2,0,0],[113,0,7,0,0,6],[173,3,0,0,0,6],[229,0,0,0,101,5]]

def MINMANACOST(boss, stats, spells, effects, nextSpell, mc, best, flag):
    # -------- PLAYER TURN ------- #
    if flag:
        stats[0] -= 1
        if stats[0] <= 0:
            return
    # update active effects on player, decrement effect remaining turns
    if effects[2] > 0:
        stats[1] += spells[4][4]
    if effects[1] > 0:
        boss[0] -= spells[3][1]
    if boss[0] <= 0:
        if mc < best[0]:
            best[0] = mc
        return best 
    effects = [x - 1 if x > 0 else 0 for x in effects]

    # mana cost for player spell cast
    stats[1] -= spells[nextSpell][0]
    if stats[1] < 0:
        return 
    mc += spells[nextSpell][0]
    if mc > best[0]:
        return

    # update effects/boss hp as a result of casting spell COULD BE HERE
    if nextSpell == 0 or nextSpell == 1:
        boss[0] -= spells[nextSpell][1]
        if boss[0] <= 0:
            if mc < best[0]:
                best[0] = mc
            return best 
        if nextSpell == 1:    
            stats[0] += spells[nextSpell][3]
    else:
        if effects[nextSpell - 2] > 0:
            return 
        else: 
            effects[nextSpell - 2] = spells[nextSpell][5]
   
    # --------- BOSS'S TURN -------- #
    if flag:
        stats[0] -= 1
        if stats[0] <= 0:
            return

    # update active effects on boss, decrement effect remaining turns
    if effects[1] > 0:
        boss[0] -= spells[3][1]
    if boss[0] <= 0:
        if mc < best[0]:
            best[0] = mc
        return best 
        
    if effects[2] > 0:
        stats[1] += spells[4][4]

    dmgTaken = boss[1] - (effects[0] > 0) * spells[2][2]
    if dmgTaken <= 0:
        dmgTaken = 1
    stats[0] -= dmgTaken
    if stats[0] <= 0:
        return 
    effects = [x - 1 if x > 0 else 0 for x in effects]

    # -------- NEXT TURNS ------- #
    for i in range(len(spells)):
        MINMANACOST(copy.deepcopy(boss), copy.deepcopy(stats), spells, effects, i, mc, best, flag)
    return best

mc = 1000000
for i in range(len(spells)):
    mci = MINMANACOST(copy.deepcopy(boss), copy.deepcopy(stats), spells, [0,0,0], i, 0, [mc], 0)   
    if mci[0] < mc:
        mc = mci[0]
print("PART 1:",mc)

mc = 1000000
for i in range(len(spells)):
    mci = MINMANACOST(copy.deepcopy(boss), copy.deepcopy(stats), spells, [0,0,0], i, 0, [mc], 1)   
    if mci[0] < mc:
        mc = mci[0]
print("PART 2:",mc)