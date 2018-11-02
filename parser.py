import re

char_map = {
    'background': '.',
    'wall': '#',
    'player': 'p',
    'crate': '*',
    'exit': '!',
    'glass': '%',

    'laserU': 'W',
    'laserD': 'S',
    'laserL': 'A',
    'laserR': 'D',

    'laserOffU': 'I',
    'laserOffD': 'K',
    'laserOffL': 'J',
    'laserOffR': 'L',

    'laserUrot1': '¨',
    'laserDrot1': 'ø',
    'laserLrot1': '≥',
    'laserRrot1': 'µ',

    'laserUtran1': 'Â',
    'laserDtran1': '',
    'laserLtran1': 'Ô',
    'laserRtran1': 'Ò',

    'laserOffUrot1': 'ˆ',
    'laserOffDrot1': '˚',
    'laserOffLrot1': '∆',
    'laserOffRrot1': '¬',

    'mirrorUL': 'Q',
    'mirrorUR': 'E',
    'mirrorDR': 'C',
    'mirrorDL': 'Z',

    'mirrorULtran1': 'œ',
    'mirrorURtran1': '´',
    'mirrorDRtran1': 'ç',
    'mirrorDLtran1': 'Ω',
    
    'mirrorULrot1': '∑',
    'mirrorURrot1': 'ß',
    'mirrorDRrot1': 'å',
    'mirrorDLrot1': '≈',

    'splitter1': 'R',
    'splitter2': 'Y',
    'splitter1tran1': '®',
    'splitter2tran1': '¥',
    'splitter1rot1': '‰',
    'splitter2rot1': 'Á',

    'goalOffguardDLR': 'T',
    'goalOffguardULR': 'G',
    'goalOffguardUDR': 'F',
    'goalOffguardUDL': 'H',
    'goalOff': 'B',

    'wireOff': '+',
    'wireWallOff': '@',
    'buttonOff': '_',
    'doorClosed': '$',
    'antiDoorOpen': '>',
    'gate0': '&',
}

pat = re.compile(r'at\((\d+),(\d+),(\w+)\)')

try:
    while True:
        ip = input()
        at_list = ip.split()
        #print(at_list)
        attr_list = []
        for literal in at_list:
            m = pat.match(literal)
            attr_list.append((int(m.group(1)), int(m.group(2)), m.group(3)))
        #print(attr_list)
        max_x = max([x[0] for x in attr_list]) + 1
        max_y = max([y[1] for y in attr_list]) + 1
        #print(max_x, max_y)
        mat = [['' for y in range(max_y)] for x in range(max_x)]
        #print(mat)
        for attr in attr_list:
            #print(attr[0], attr[1], attr[2])
            mat[attr[0]][attr[1]] = char_map[attr[2]]
        for i in mat:
            print(''.join(i))
        print()
except EOFError:
    pass