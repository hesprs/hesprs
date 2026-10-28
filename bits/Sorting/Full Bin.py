array = input("Input: ")
arr = []
for i in array.split():
    arr.append(int(i))

bin_height = int(input("Bin height: "))

bins = [{
    "taken": 0,
    "contents": []
}]
index = 0

for i in arr:
    contained = False
    for bin in bins:
        if bin_height - bin["taken"] >= i:
            bin["taken"] += i
            bin["contents"].append(i)
            contained = True
            break
    if not contained:
        bins.append({
            "taken": i,
            "contents": [i]
        })

for i in range(len(bins)):
    print("Bin " + str(i + 1) + ": ", end="")
    for j in bins[i]["contents"]:
        print(str(j) + " ", end="")
    print()