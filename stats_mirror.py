SOLID = "#$@"
SOLIDD = "#@"
WIRE = "+@$"
LASER = "¨ø≥µ"
MIRROR = "∑ßå≈"
N = 6


def is_playable(level):
    soln_len = 0
    for row in range(0, N):
        for col in range(0, N):
            if level[row][col] == "p":
                start = (row, col)
            if level[row][col] == "B":
                goal = (row, col)
    # player to laser
    laser = ()
    p2l = False
    stk = []
    stk.append(start)
    seen = set()
    seen.add(start)
    while stk:
        currX, currY = stk.pop()
        if level[currX][currY] in LASER:
            laser = (currX, currY)
            p2l = True
            break
        if (
            currX - 1 >= 0
            and (currX - 1, currY) not in seen
            and level[currX - 1][currY] not in SOLID
        ):
            seen.add((currX - 1, currY))
            stk.append((currX - 1, currY))
        if (
            currX + 1 < N
            and (currX + 1, currY) not in seen
            and level[currX + 1][currY] not in SOLID
        ):
            seen.add((currX + 1, currY))
            stk.append((currX + 1, currY))
        if (
            currY - 1 >= 0
            and (currX, currY - 1) not in seen
            and level[currX][currY - 1] not in SOLID
        ):
            seen.add((currX, currY - 1))
            stk.append((currX, currY - 1))
        if (
            currY + 1 < N
            and (currX, currY + 1) not in seen
            and level[currX][currY + 1] not in SOLID
        ):
            seen.add((currX, currY + 1))
            stk.append((currX, currY + 1))
    # print(laser)
    soln_len += len(stk) + 1
    if not p2l:
        return (False, soln_len)

    # laser to door
    door = ()
    l2d = False
    stk = []
    stk.append(laser)
    seen = set()
    seen.add(laser)
    while stk:
        currX, currY = stk.pop()
        if level[currX][currY] == "$":
            door = (currX, currY)
            l2d = True
            break
        if (
            currX - 1 >= 0
            and (currX - 1, currY) not in seen
            and level[currX - 1][currY] not in SOLIDD
        ):
            seen.add((currX - 1, currY))
            stk.append((currX - 1, currY))
        if (
            currX + 1 < N
            and (currX + 1, currY) not in seen
            and level[currX + 1][currY] not in SOLIDD
        ):
            seen.add((currX + 1, currY))
            stk.append((currX + 1, currY))
        if (
            currY - 1 >= 0
            and (currX, currY - 1) not in seen
            and level[currX][currY - 1] not in SOLIDD
        ):
            seen.add((currX, currY - 1))
            stk.append((currX, currY - 1))
        if (
            currY + 1 < N
            and (currX, currY + 1) not in seen
            and level[currX][currY + 1] not in SOLIDD
        ):
            seen.add((currX, currY + 1))
            stk.append((currX, currY + 1))
    # print(door)
    soln_len += len(stk) + 1
    if not l2d:
        return (False, soln_len)

    # WIRE path from goal to door
    g2d = False
    stk = []
    stk.append(goal)
    seen = set()
    seen.add(goal)
    while stk:
        currX, currY = stk.pop()
        if level[currX][currY] == "$":
            g2d = True
            break
        if (
            currX - 1 >= 0
            and (currX - 1, currY) not in seen
            and level[currX - 1][currY] in WIRE
        ):
            seen.add((currX - 1, currY))
            stk.append((currX - 1, currY))
        if (
            currX + 1 < N
            and (currX + 1, currY) not in seen
            and level[currX + 1][currY] in WIRE
        ):
            seen.add((currX + 1, currY))
            stk.append((currX + 1, currY))
        if (
            currY - 1 >= 0
            and (currX, currY - 1) not in seen
            and level[currX][currY - 1] in WIRE
        ):
            seen.add((currX, currY - 1))
            stk.append((currX, currY - 1))
        if (
            currY + 1 < N
            and (currX, currY + 1) not in seen
            and level[currX][currY + 1] in WIRE
        ):
            seen.add((currX, currY + 1))
            stk.append((currX, currY + 1))
    if not g2d:
        return (False, soln_len)
    return (True, soln_len)


with open("output_level_mirror.txt", "r") as f:
    content = f.readlines()

lines = [line.strip() for line in content if line != "\n"]
levels = [lines[x : x + N] for x in range(0, len(lines), N)]

playable_cnt = 0
lvl_lens = []
for level in levels:
    playable, soln_len = is_playable(level)
    if playable:
        playable_cnt += 1
        lvl_lens.append(soln_len)
print("Playable:", playable_cnt)
print("Unplayable:", len(levels) - playable_cnt)
print("Lengths:", lvl_lens)
print("Total:", len(levels))
