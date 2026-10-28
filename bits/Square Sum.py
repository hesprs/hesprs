n = int(input('Input n: '))
sum = 0
len = n - 1
for i in range(len):
    sum += (2 * n - 1 - 2 * i) * (len - i)
ans = n ** 3 - sum
print(f'The answer is {ans}.')