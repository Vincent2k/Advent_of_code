

end_frequency = 0

found_frequency = {}
found_frequency[0] = 'test'

twise_found = False

while not twise_found:

    file = open('frequency.txt', 'r')

    frequency_string = file.read()
    frequency_tab = frequency_string.split('\n')

    for frequency in frequency_tab:
        operation = frequency[0]
        number = int(frequency[1:])
        if operation == '+':
            end_frequency = end_frequency + number 
        elif operation == '-':
            end_frequency = end_frequency - number

        if end_frequency in found_frequency:
            print('yes')
            twise_found = True
            break
            
        found_frequency[end_frequency] = 'test'


print(end_frequency)