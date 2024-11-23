.data
##### R1 START MODIFY HERE START #####
# This space is to define constants and auxiliary vectors, if necessary.
##### R1 END MODIFY HERE END #####

.text
# Test initialization
add s0, zero, zero          # Number of tests passed

# Test 1: LCM of 10 and 2 (expected result: 10)
addi a0, zero, 10
addi a1, zero, 2
jal ra, mmc                 # Call the mmc procedure
addi t0, zero, 10           # Expected result
bne a0, t0, test2           # If a0 != 10, go to the next test
addi s0, s0, 1              # Increment s0 if the test passed

# Test 2: LCM of 6 and 4 (expected result: 12)
test2:
addi a0, zero, 6
addi a1, zero, 4
jal ra, mmc                 # Call the mmc procedure
addi t0, zero, 12           # Expected result
bne a0, t0, END             # If a0 != 12, skip to the end
addi s0, s0, 1              # Increment s0 if the test passed

beq zero, zero, END         # Unconditional jump to the end

##### R2 START MODIFY HERE START #####

# Procedure to calculate the LCM
mmc:
    # Save the registers used in the procedure on the stack
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s1, 8(sp)
    sw s2, 4(sp)

    # Calculate the GCD using the auxiliary procedure
    mv s1, a0                # s1 = a (first number)
    mv s2, a1                # s2 = b (second number)
    jal ra, mdc              # Call the mdc procedure; result in a0

    # Calculate LCM using the formula (a * b) / GCD
    mul a1, s1, s2           # a1 = a * b
    div a0, a1, a0           # a0 = (a * b) / GCD

    # Restore the registers and return
    lw ra, 12(sp)
    lw s1, 8(sp)
    lw s2, 4(sp)
    addi sp, sp, 16
    jalr zero, 0(ra)

# Auxiliary procedure to calculate the GCD using the Euclidean Algorithm
mdc:
    mv t0, a0                # t0 = a
    mv t1, a1                # t1 = b

mdc_loop:
    beq t1, zero, mdc_done   # If t1 == 0, exit the loop
    rem t2, t0, t1           # t2 = t0 % t1
    mv t0, t1                # t0 = t1
    mv t1, t2                # t1 = t2
    beq zero, zero, mdc_loop # Repeat the loop

mdc_done:
    mv a0, t0                # Result GCD in a0
    jalr zero, 0(ra)         # Return

##### R2 END MODIFY HERE END #####

END:
    addi t0, s0, 0           # t0 = number of tests passed
