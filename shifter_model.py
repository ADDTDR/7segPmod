da = 0xfa
cc = 0b1


for i in range(0, 8):
    cc = 1 << i
    do = (da & cc) >> i
    clck = 0b0
    clck = 0b1

for i in reversed(range(0, 8)):
    cc = 1 << i
    do = (da & cc) >> i
    clck = 0b0
    clck = 0b1