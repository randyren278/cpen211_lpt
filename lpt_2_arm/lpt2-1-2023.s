.global _start
_start:
    LDR R0, =data        // Base address of array "data" in R0
    MOV R1, #1           // i = 1
    MOV R2, #1           // j = 1
    MOV R3, #1           // k = 1
    BL func
END: B END               // Infinite loop; R0 contains return value of func

.global func
func:
    // Check if i == j
    CMP R1, R2
    BNE else_block       // Branch to else_block if i != j
    // if (i == j) { A[0] = A[1] + k; }
    LDR R4, [R0, #4]     // Load A[1] into R4
    ADD R4, R4, R3       // R4 = A[1] + k
    STR R4, [R0]         // Store result in A[0]
    B check_i_k          // Jump to check_i_k

else_block:
    // else { A[1] = A[0] - k; }
    LDR R4, [R0]         // Load A[0] into R4
    SUB R4, R4, R3       // R4 = A[0] - k
    STR R4, [R0, #4]     // Store result in A[1]

check_i_k:
    // Check if i < k
    CMP R1, R3
    BGE else_block2      // Branch to else_block2 if i >= k
    // if (i < k) {
    CMP R1, R2           // Check if i < j
    BGE end_if           // Skip A[2] = -j if i >= j
    // if (i < j) { A[2] = -j; }
    RSBS R4, R2, #0      // R4 = -j
    STR R4, [R0, #8]     // Store result in A[2]
    B end_if             // Jump to end_if

else_block2:
    // else { A[3] = j + 1; }
    ADD R4, R2, #1       // R4 = j + 1
    STR R4, [R0, #12]    // Store result in A[3]

end_if:
    // Return i + j - k
    ADD R0, R1, R2       // R0 = i + j
    SUB R0, R0, R3       // R0 = i + j - k
    MOV PC, LR           // Return
data:
    .word 0
    .word 0
    .word 0
    .word 0
