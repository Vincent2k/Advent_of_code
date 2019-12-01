file = open('input.txt', 'r')

string_inputs = file.read().split('\n')

checksum_concurrency = {}
checksum_concurrency[2] = 0
checksum_concurrency[3] = 0

for string_input in string_inputs:
    letter_concurrency = {}

    for letter in string_input:
        if letter in letter_concurrency:
            new_concurrency = letter_concurrency[letter] + 1
            letter_concurrency[letter] = new_concurrency
            
            if new_concurrency == 2 or new_concurrency == 3:
                letter_concurrency[letter] = new_concurrency
        else:
            letter_concurrency[letter] = 1

    tow = False
    three = False
    for concu in letter_concurrency:
        if letter_concurrency[concu] == 2 and not tow:
            tow = True
            checksum_concurrency[2] = checksum_concurrency[2] + 1
        if letter_concurrency[concu] == 3 and not three:
            three = True 
            checksum_concurrency[3] = checksum_concurrency[3] + 1


print(checksum_concurrency[2] * checksum_concurrency[3])
