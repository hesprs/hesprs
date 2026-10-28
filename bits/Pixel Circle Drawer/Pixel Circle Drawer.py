while True:
    l = []
    try:
        d = int(input('Please type in the diameter of the pixel circle as a positive integer: '))
        if d <= 0:
            d = l[d]
    except:
        print ('Invalid input!\n-----------------------------')
        continue
    w = d / 2
    z = w % 1 + 0.5
    y = d % 2
    x = d // 2
    l.append(d)
    while len(l) - z + 0.5 < l[len(l) - 1] / 2:
        l.append(l[len(l) - 1])
        while (w + len(l) - z) * (w - len(l) + z) < (l[len(l) - 1] / 2 - 0.5) ** 2: l[len(l) - 1] -= 2
    c = len(l)
    for a in range(int(x + y - c)):
        l.append(y)
        for b in range(int(c - y)):
            if l[b + y] - 2 * c + y - 2 * a >= 2: l[len(l) - 1] += 2
    S = 0
    for a in l: S += 2 * a
    S -= y * d
    print (f'Area of the pixel circle: {str(S)}.')
    for a in range(x): l.insert(0, l[2 * a + y])
    print ('The chord lengths of the pixel circle: ', end = '')
    for a in range(len(l)):
        if a + 1 != len(l): print (l[a], end = ',')
        else: print (l[a], end = '.\n')
    for a in l:
        for b in range(int((d - a) / 2)): print ('  ', end = '')
        for b in range(a): print ('■ ', end = '')
        print ()
    print ('-----------------------------')
