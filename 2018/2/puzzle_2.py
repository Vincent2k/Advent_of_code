file = open('input.txt', 'r')

string_inputs = file.read().split('\n')

diff_pos = 0
diff_word = ''

for i in range(len(string_inputs)):
    if diff_word != '':
        break
    current = string_inputs[i]
    for j in range(1, len(string_inputs)):
        if diff_word != '':
            break
        other = string_inputs[j]
        diff_count = 0
        diff_pos = 0
        for pos in range(len(current)):
            if current[pos] != other[pos]:
                if diff_count == 1:
                    diff_word = ''
                    break
                diff_word = current
                diff_pos = pos
                diff_count = diff_count + 1 

print(diff_word[:diff_pos] + diff_word[diff_pos+1:])