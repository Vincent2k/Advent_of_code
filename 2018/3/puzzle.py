file = open('test.txt', 'r')

inputs = file.read().split('\n')

matrice = []

for data in inputs:
    inch_info = data.split(' ')[2].split(',')
    top_inch = int(inch_info[1][0])
    left_inch = int(inch_info[0])

    dimension_info = data.split(' ')[3].split('x')
    width = int(dimension_info[0])
    height = int(dimension_info[1])

    for i in range(top_inch, height + top_inch):
        for j in range(left_inch, width + left_inch):
            matrice[i][j] = matrice[i][j] + 1

count = 0

print(matrice)