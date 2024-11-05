.global func
func:
    // Initialize return value as i + j
    ADD R4, R0, R1          // R4 = i + j, store in temp to avoid affecting R0 prematurely

    // Check if i < j
    CMP R0, R1              // Compare i and j
    BGE check_i_equals_k    // If i >= j, skip to next check
    MOV R5, #1
    STR R5, [R3]            // A[0] = 1

check_i_equals_k:
    CMP R0, R2              // Compare i and k
    BNE end_func            // If i != k, return result
    MOV R5, #2
    STR R5, [R3, #4]        // A[1] = 2

    // Check if A[2] > j
    LDR R5, [R3, #8]        // Load A[2] into R5
    CMP R5, R1              // Compare A[2] and j
    BLE end_func            // If A[2] <= j, return result
    MOV R5, #4
    STR R5, [R3, #12]       // A[3] = 4

end_func:
    MOV R0, R4              // Move i + j result into R0 for return
    MOV PC, LR              // Return from function
