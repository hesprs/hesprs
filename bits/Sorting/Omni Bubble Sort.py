element_dictionary = {}

def print_arr(arr):
    for i in arr:
        print(element_dictionary[i], end=" ")
    print()

array = input("Input: ")
arr = []
for i in array.split():
    sum = 0
    digits = len(i)
    for j in range (digits):
        sum += ord(i[j]) * 10 ** (digits - j - 1)
    element_dictionary[sum] = i
    arr.append(sum)

order = input("Order(as/de): ")
def need_sorting(a, b):
    if order == "as":
        return a > b
    else:
        return a < b

output_depth = int(input("Output depth(1/2): "))

index = 0
sort_happens = True
while sort_happens:
    sort_happens = False
    if output_depth == 2:
        print("In pass " + str(index + 1) + ":")
    for i in range(len(arr) - 1 - index):
        if need_sorting(arr[i], arr[i + 1]):
            arr[i], arr[i + 1] = arr[i + 1], arr[i]
            sort_happens = True
            if (output_depth == 2):
                print("  Swap:", end=" ")
                print_arr(arr)
    index += 1
    if (output_depth == 1):
        print("Pass " + str(index) + ":", end=" ")
        print_arr(arr)