array = input("Input: ")
arr = []
for i in array.split():
    arr.append(int(i))

bin_height = int(input("Bin height: "))

bins = [0]
index = 0

for i in arr:
    if bin_height - bins[index] > i:
        bins[index] += i
    else:
        index += 1
        bins.append(i)

print(bins)