.data
##### R1 START MODIFY HERE START #####
vector: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
##### R1 END MODIFY HERE END #####

.text
    add s0, zero, zero       # Initialize s0 to 0 (accumulator for counting)
    addi a0, zero, 13        # Load immediate value 13 into a0 (first test value)
    jal ra, eprimo           # Jump to function 'eprimo' (prime check) and link return address in ra
    addi t0, zero, 0         # Initialize t0 to 0 (expected result for comparison)
    bne a0, t0, teste2       # If a0 is not equal to 0, jump to 'teste2' (continue if not prime)
    addi s0, s0, 1           # If prime, increment s0 (counter for prime numbers)

teste2:
    addi a0, zero, 2         # Load immediate value 2 into a0 (test value for Mersenne prime check)
    jal ra, primosmersenne   # Jump to function 'primosmersenne' (Mersenne prime check)
    addi t0, zero, 7         # Load immediate value 7 into t0 (expected Mersenne prime value)
    bne a0, t0, FIM          # If a0 is not equal to 7, jump to 'FIM' (end of process)
    addi s0, s0, 1           # If Mersenne prime is 7, increment s0 (counting valid primes)
    beq zero, zero, FIM      # Unconditional jump to FIM (end of the program)

geramersenne:
    addi sp, sp, -16         # Allocate 16 bytes on the stack
    sw ra, 12(sp)            # Store the return address on the stack
    mv t0, a0                # Copy the input parameter (number of Mersenne numbers) to t0
    la t1, vector            # Load the base address of the array into t1
    li t2, 0                 # Initialize iteration index t2 to 0
    li t4, 31                # Set the maximum limit to avoid overflow

loop:
    beq t0, zero, break      # Exit the loop if t0 == 0
    bgt t2, t4, break        # Exit the loop if t2 > 31
    li t3, -1                # Load -1 into t3
    sll t3, t3, t2           # Shift left -1 by t2 (t3 = -1 << t2)
    not t3, t3               # Invert t3 to get (2^n - 1)
    sw t3, 0(t1)             # Store t3 in the array
    addi t1, t1, 4           # Move the pointer to the next position in the array
    addi t2, t2, 1           # Increment n
    addi t0, t0, -1          # Decrement the loop counter
    j loop                   # Jump back to the start of the loop

break:
    lw ra, 12(sp)            # Load the saved return address from the stack
    addi sp, sp, 16           # Adjust the stack pointer to its original position
    ret                      # Return to the caller (uses ra by default)

eprimo:
    addi sp, sp, -16         # Allocate stack space for saving return address
    sw ra, 12(sp)            # Save the return address (ra) to stack
    addi t6, a0, -1          # Subtract 1 from the input number and store in t6
    li t1, 2                 # Load 2 into t1 (initial divisor)
    blt a0, t1, less_than_two # If the number is less than 2, jump to return 1
    j check_prime

less_than_two:
    li a0, 1                 # Return 1 for numbers less than 2
    j end_eprimo

check_prime:
    # Continue with the prime check if number >= 2
    j verify_prime

verify_prime:
    rem t2, a0, t1           # t2 = number % t1
    beq t2, zero, nao_primo  # If number % t1 == 0, it's not prime
    addi t1, t1, 1           # Increment the divisor
    blt t1, a0, verify_prime # Continue until t1 < number

fim_primo:
    li a0, 0                 # Return 0 if it's prime
    j end_eprimo

nao_primo:
    li a0, 1                 # Return 1 if it's not prime

end_eprimo:
    lw ra, 12(sp)            # Restore the ra register
    addi sp, sp, 16          # Release space on the stack
    jalr zero, 0(ra)         # Return

primosmersenne:
    addi sp, sp, -24         # Allocate space on the stack
    sw ra, 20(sp)            # Save the return address (ra)
    sw t0, 16(sp)            # Save the original value of t0
    sw s1, 12(sp)            # Save the value of s1
    mv s1, a0              # Set s1 to the desired nth Mersenne prime
    li a0, 32                # Prepare to generate up to 32 Mersenne numbers
    jal ra, geramersenne     # Jump and link to the geramersenne function
    xor s2, s2, s2           # Reset the Mersenne prime counter (s2 = 0)
    la t5, vector            # Load the address of the vector (array) into t5

find_prime:
    lw t3, 0(t5)             # Load the current Mersenne number
    addi a0, t3, 0           # Prepare the argument for eprimo
    jal ra, eprimo           # Call eprimo
    beq a0, zero, increase   # If it's prime, increment the counter

continue:
    addi t5, t5, 4           # Advance to the next number
    j find_prime             # Repeat the process

increase:
    addi s2, s2, 1           # Increment the counter (uses s2 instead of t2)
    beq s2, s1, end_primes   # If the nth prime is found, terminate
    j continue               # If not, continue with the next number

end_primes:
    lw a0, 0(t5)            # Load the nth Mersenne prime into t1
    lw ra, 20(sp)           # Restore the return address (ra) from the stack
    lw t0, 16(sp)           # Restore the value of t0 from the stack
    lw s1, 12(sp)           # Restore s1 register from the stack
    addi sp, sp, 24         # Adjust the stack pointer to free up space
    jalr zero, 0(ra)        # Jump to the return address stored in ra
 
FIM:
    add t0, zero, s0
