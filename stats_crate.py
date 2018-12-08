SOLID = '#$@'
SOLIDD = '#@'
WIRE = '+@$'

N = 6

def is_playable(level):
    soln_len = 0
    for row in range(0, N):
        for col in range(0, N):
            if level[row][col] == 'p':
                start = (row, col)
                break
    # player to crate
    crate = ()
    p2c = False
    stk = []
    stk.append(start)
    seen = set()
    seen.add(start)
    while stk:
        currX, currY = stk.pop()
        if level[currX][currY] == '*':
            crate = (currX, currY)
            p2c = True
            break
        if currX - 1 >= 0 and (currX - 1, currY) not in seen and level[currX-1][currY] not in SOLID:
            seen.add((currX - 1, currY))
            stk.append((currX - 1, currY))
        if currX + 1 < N and (currX + 1, currY) not in seen and level[currX+1][currY] not in SOLID:
            seen.add((currX + 1, currY))
            stk.append((currX + 1, currY))
        if currY - 1 >= 0 and (currX, currY - 1) not in seen and level[currX][currY - 1] not in SOLID:
            seen.add((currX, currY - 1))
            stk.append((currX, currY - 1))
        if currY + 1 < N and (currX, currY + 1) not in seen and level[currX][currY + 1] not in SOLID:
            seen.add((currX, currY + 1))
            stk.append((currX, currY + 1))
    #print(crate)
    if not p2c:
        return (False, soln_len)
    soln_len += len(stk) + 1
    
    # crate to button
    button = ()
    c2b = False
    stk = []
    stk.append(crate)
    seen = set()
    seen.add(crate)
    while stk:
        currX, currY = stk.pop()
        if level[currX][currY] == '_':
            button = (currX, currY)
            c2b = True
            break
        if currX - 1 >= 0 and (currX - 1, currY) not in seen and level[currX-1][currY] not in SOLID:
            seen.add(((currX - 1, currY)))
            stk.append((currX - 1, currY))
        if currX + 1 < N and (currX + 1, currY) not in seen and level[currX+1][currY] not in SOLID:
            seen.add((currX + 1, currY))
            stk.append((currX + 1, currY))
        if currY - 1 >= 0 and (currX, currY - 1) not in seen and level[currX][currY - 1] not in SOLID:
            seen.add((currX, currY - 1))
            stk.append((currX, currY - 1))
        if currY + 1 < N and (currX, currY + 1) not in seen and level[currX][currY + 1] not in SOLID:
            seen.add((currX, currY + 1))
            stk.append((currX, currY + 1))
    #print(button)
    if not c2b:
        return (False, soln_len)
    soln_len += len(stk) + 1
    
    # button to door
    door = ()
    b2d = False
    stk = []
    stk.append(button)
    seen = set()
    seen.add(button)
    while stk:
        currX, currY = stk.pop()
        if level[currX][currY] == '$':
            door = (currX, currY)
            b2d = True
            break
        if currX - 1 >= 0 and (currX - 1, currY) not in seen and level[currX-1][currY] not in SOLIDD:
            seen.add((currX - 1, currY))
            stk.append((currX - 1, currY))
        if currX + 1 < N and (currX + 1, currY) not in seen and level[currX+1][currY] not in SOLIDD:
            seen.add((currX + 1, currY))
            stk.append((currX + 1, currY))
        if currY - 1 >= 0 and (currX, currY - 1) not in seen and level[currX][currY - 1] not in SOLIDD:
            seen.add((currX, currY - 1))
            stk.append((currX, currY - 1))
        if currY + 1 < N and (currX, currY + 1) not in seen and level[currX][currY + 1] not in SOLIDD:
            seen.add((currX, currY + 1))
            stk.append((currX, currY + 1))
    #print(door)
    if not b2d:
        return (False, soln_len)
    soln_len += len(stk)
        
    # WIRE path from button to door
    b2dw = False
    stk = []
    stk.append(button)
    seen = set()
    seen.add(button)
    while stk:
        currX, currY = stk.pop()
        if level[currX][currY] == '$':
            b2dw = True
            break
        if currX - 1 >= 0 and (currX - 1, currY) not in seen and level[currX-1][currY] in WIRE:
            seen.add((currX - 1, currY))
            stk.append((currX - 1, currY))
        if currX + 1 < N and (currX + 1, currY) not in seen and level[currX+1][currY] in WIRE:
            seen.add((currX + 1, currY))
            stk.append((currX + 1, currY))
        if currY - 1 >= 0 and (currX, currY - 1) not in seen and level[currX][currY - 1] in WIRE:
            seen.add((currX, currY - 1))
            stk.append((currX, currY - 1))
        if currY + 1 < N and (currX, currY + 1) not in seen and level[currX][currY + 1] in WIRE:
            seen.add((currX, currY + 1))
            stk.append((currX, currY + 1))
    #print(b2dw)
    if not b2dw:
        return (False, soln_len)
    return (True, soln_len)

with open('output_level_crate.txt', 'r') as f:
    content = f.readlines()
    
lines = [line.strip() for line in content if line != '\n']
levels = [lines[x:x+N] for x in range(0, len(lines), N)]

playable_cnt = 0
lvl_lens = []
for level in levels:
    playable, soln_len = is_playable(level)
    if playable:
        playable_cnt += 1
        lvl_lens.append(soln_len)
print('Playable:', playable_cnt)
print('Unplayable:', len(levels) - playable_cnt)
print('Lengths:', lvl_lens)
print('Total:', len(levels))