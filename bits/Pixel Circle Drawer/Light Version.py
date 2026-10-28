r = int(input("Enter radius: "))
for i in range(2 * r + 1):
    for j in range(2 * r + 1):
        if (i - r - 0.5) ** 2 + (j - r - 0.5) ** 2 < r ** 2:
            print("■ ", end="")
        else:
            print("  ", end="")
    print()