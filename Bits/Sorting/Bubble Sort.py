input = input("Input: ")
arr = []
for i in input.split():
    arr.append(int(i))

sort_happens = True
index = 0
while sort_happens:
    sort_happens = False
    for i in range(len(arr) - 1 - index):
        if arr[i] > arr[i+1]:
            arr[i], arr[i+1] = arr[i+1], arr[i]
            sort_happens = True
    print(arr)
    index += 1