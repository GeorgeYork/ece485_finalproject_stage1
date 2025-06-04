
        addi    x5, x0, 9       # x5 = number of values in array - 1
        load_addr x6, array     # x6 = address of array (custom instruction)
        lw      x7, 0(x6)       # x7 = initial value
loop:   addi    x6, x6, 4       
        lw      x10, 0(x6)      
        add     x7, x10, x7     
        subi    x5, x5, 1       
        bne     x5, x0, loop
done:   j       done            # infinite loop (breakpoint)

#   initialize data in the array
array:  .word 0x5, 0x4, 0x10, 0x3, 0x12, 0x1, 0x7, 0x4, 0x8, 0x2