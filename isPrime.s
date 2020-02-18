# Implementation of isPrime in RISCV
# Ben Bradberry
# 2/18/20
# Not tested on native hardware, run on https://www.kvakil.me/venus/
.data
    lim:. word 50                           # isPrime loop limit
    primeStr: .asciiz " is Prime.\n"
    notprimeStr: .asciiz " is not prime.\n"

.text
    main:
        lw a2, lim                          # load lim into a2
        addi a3, zero, 2                    # a3 will be used for halving numbers
        addi a4, zero, 1                    # used for comparing a6 to 1
        jal ra, loop
        addi a0, zero, 10                   # set a0 up for system exit
        ecall                               # Exit

    loop:
        beq a7, zero, isNotPrime            # 0 is not prime
        beq a7, a4, isNotPrime              # 1 is not prime
        beq a7, a3, isPrime                 # 2 is prime but divisible by 2 so this case is here
        add t1, zero, a3                    # t1 = 2
        rem t0, a7, t1                      # t0 = a7 % 2
        beq t0, zero, isNotPrime            # checks if number is even
        addi t3, zero, 3                    # t3 is starting point of inner loop
        div t4, a7, t1                      # t4 = a7 / 2
    innerLoop:                              # iterates up to t4
        rem t0, a7, t3                      # t0 = a7 % t3
        beq t0, zero, isNotPrime            # if t0 == 0, goto isNotPrime
    innerLoopEnd:
        addi t3, t3, 1                      # j = j + 1
        beq t3, t4, innerEnd                 # if j = t4, goto loopEnd
        jal zero, innerLoop
    loopEnd:
        beq a7, a2, outerEnd                # if i == lim break out
        addi a7, a7, 1                      # i = i + 1
        jal zero, loop                      # start loop
        
    isPrime:
        addi a0, zero, 1                    # prep a0 for int ecall
        add a1, zero, a7                    # load a7 into ecall
        ecall
        addi a0, zero, 4                    # prep a0 for string ecall
        la a1, primeStr                     # load primeStr into a1
        ecall
        jal zero, loopEnd                   # return to end of loop

    isNotPrime:
        addi a0, zero, 1                    # prep a0 for int ecall
        add a1, zero, a7                    # load a7 into ecall
        ecall
        addi a0, zero, 4                    # prep a0 for string ecall
        la a1, notprimeStr                  # load primeStr into a1
        ecall
        jal zero, loopEnd                   # return to end of loop

    innerEnd:
        jal zero, isPrime                   # if here, must be prime

    outerEnd:
        jalr zero, 0(ra)                    # return to main