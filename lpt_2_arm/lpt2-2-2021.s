.global loopy
loopy:
    MOV R3, #0          // Initialize index i to 0
    MOV R5, #0          // Initialize L1norm to 0

loop_start:
    CMP R3, R0          // Check if i < n
    BGE end_loop        // Exit loop if i >= n

    // Load A[i] and calculate absolute value
    LDR R4, [R1, R3, LSL #2]    // Load A[i] into R4
    CMP R4, #0
    RSBLT R4, R4, #0            // If A[i] < 0, negate it

    // Store the absolute value in B[i]
    STR R4, [R2, R3, LSL #2]    // B[i] = abs(A[i])

    // Accumulate into L1norm
    ADD R5, R5, R4              // L1norm += abs(A[i])

    // Increment index i
    ADD R3, R3, #1
    B loop_start                // Repeat loop

end_loop:
    MOV R0, R5          // Return L1norm in R0
    MOV PC, LR          // End function and return
