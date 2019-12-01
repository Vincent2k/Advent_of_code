import functools

file = open('input.txt', 'r')

inputs = file.read().split('\n')

def date_cmp(input1, input2):
    date1 = input1.split(']')[0]
    date2 = input2.split(']')[0]
    month1 = int(date1.split('-')[1])
    month2 = int(date2.split('-')[1])
    day1 = int(date1.split('-')[2].split(' ')[0])
    day2 = int(date2.split('-')[2].split(' ')[0])
    hour1 = int(date1.split('-')[2].split(' ')[1].split(':')[0])
    hour2 = int(date2.split('-')[2].split(' ')[1].split(':')[0])
    minute1 = int(date1.split('-')[2].split(' ')[1].split(':')[1])
    minute2 = int(date2.split('-')[2].split(' ')[1].split(':')[1])

    if month1 < month2:
        return -1
    elif month1 > month2:
        return 1
    elif month1 == month2:
        if day1 < day2:
            return -1
        elif day1 > day2:
            return 1
        elif day1 == day2:
            if hour1 < hour2:
                return -1
            elif hour1 > hour2:
                return 1
            elif hour1 == hour2:
                if minute1 < minute2:
                    return -1
                elif minute1 > minute2:
                    return 1
                elif minute1 == minute2:
                    return 1
    return 1

sortedInputs = sorted(inputs, key=functools.cmp_to_key(date_cmp))


guardHourInfo = {}
currentGuard = "sauce"

def guard_cpm(guard1, guard2):
    if guardHourInfo[guard1]['Total'] < guardHourInfo[guard2]['Total']:
        return 1
    return -1

def guard_hour_cpm(hour1, hour2):
    if hour1 == 'id':
        return 1
    elif hour2 == 'id':
        return -1
    
    if hour1 == 'Total':
        return 1
    if hour2 == 'Total':
        return -1

    if guardHourInfo[currentGuard][int(hour1)] < guardHourInfo[currentGuard][int(hour2)]:
        return 1
    else:
        return -1

def part_tow_sorted(guard1, guard2):
    global currentGuard
    guard1Values = guardHourInfo[guard1]
    guard2Values = guardHourInfo[guard2]

    currentGuard = guard1
    guard1Value = sorted(guard1Values, key=functools.cmp_to_key(guard_hour_cpm))[0]
    currentGuard = guard2
    guard2Value = sorted(guard2Values, key=functools.cmp_to_key(guard_hour_cpm))[0]

    if guardHourInfo[guard1][guard1Value] < guardHourInfo[guard2][guard2Value]:
        return 1
    return -1

for guardInfo in sortedInputs:
    if '#' in guardInfo:
        guardId = guardInfo.split('#')[1].split(' ')[0]
        if guardId not in guardHourInfo:
            guardHourInfo[guardId] = {}
            guardHourInfo[guardId]['Total'] = 0
            guardHourInfo[guardId]['id'] = int(guardId)
    if 'asleep' in guardInfo:
        minuteSleep = guardInfo.split(':')[1].split(']')[0]
    if 'wakes' in guardInfo:
        minuteWake = guardInfo.split(':')[1].split(']')[0]
        timeASleep = int(minuteWake) - int(minuteSleep)
        guardHourInfo[guardId]['Total'] = guardHourInfo[guardId]['Total'] + timeASleep

        startMinute = 0
        endMinute = 0

        if minuteSleep[0] == '0':
            startMinute = int(minuteSleep[1])

            if minuteWake[0] == "0":
                endMinute = int(minuteWake[1])
            else:
                endMinute = int(minuteWake)
        else: 
            startMinute = int(minuteSleep)
            endMinute = int(minuteWake)

        for i in range(startMinute, endMinute):
            if i not in guardHourInfo[guardId]:
                guardHourInfo[guardId][i] = 0

            guardHourInfo[guardId][i] = guardHourInfo[guardId][i] + 1

sortedGuard = sorted(guardHourInfo, key=functools.cmp_to_key(guard_cpm))
currentGuard = sortedGuard[0]
valuesHour = guardHourInfo[currentGuard]
sortedHours = sorted(valuesHour, key=functools.cmp_to_key(guard_hour_cpm))
print(int(currentGuard) * sortedHours[0])

sortedGuard = sorted(guardHourInfo, key=functools.cmp_to_key(part_tow_sorted))
currentGuard = sortedGuard[0]
valuesHour = guardHourInfo[currentGuard]
sortedHours = sorted(valuesHour, key=functools.cmp_to_key(guard_hour_cpm))
print(int(currentGuard) * sortedHours[0])

