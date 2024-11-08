.global funky
funky:
    MOV R2, #0              // result = 0
    MOV R3, #-1             // top = -1
    MOV R4, #0              // next = 0

loop:
    LDR R5, [R0, R4, LSL #2]    // Load A[next] into R5
    CMP R5, #0
    BEQ else_block              // Branch to else_block if A[next] == 0

    // If A[next] != 0:
    ADD R3, R3, #1              // top = top + 1
    ADD R6, R4, #2              // Compute next+2 index
    LDR R7, [R0, R6, LSL #2]    // Load A[next + 2] into R7
    STR R7, [R1, R3, LSL #2]    // B[top] = A[next + 2]
    ADD R6, R4, #1              // Compute next+1 index
    LDR R4, [R0, R6, LSL #2]    // next = A[next + 1]
    B check_next                // Jump to check_next

else_block:
    // Else block: result = result + A[next + 1]
    ADD R6, R4, #1              // Compute next+1 index
    LDR R5, [R0, R6, LSL #2]    // Load A[next + 1] into R5
    ADD R2, R2, R5              // result += A[next + 1]
    
    CMP R3, #0                  // Check if top >= 0
    BLT set_next_minus1         // If top < 0, set next = -1

    // If top >= 0:
    LDR R4, [R1, R3, LSL #2]    // next = B[top]
    SUB R3, R3, #1              // top = top - 1
    B check_next

set_next_minus1:
    MOV R4, #-1                 // next = -1

check_next:
    CMP R4, #0                  // Check if next >= 0
    BGE loop                    // Loop if next >= 0

    // Return result
    MOV R0, R2                  // R0 = result
    MOV PC, LR                  // Return

.global _start
_start:
    LDR R0, =A                  // Load base address of A
    LDR R1, =B                  // Load base address of B
    BL funky
end: B end                      // Infinite loop; R0 contains return value of funky

A: .word 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
B: .word 0, 0, 0, 0
