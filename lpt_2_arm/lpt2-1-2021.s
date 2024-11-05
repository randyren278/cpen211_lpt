.global func
func:
    // Initialize return value as i + j
    ADD R0, R0, R1          // R0 = i + j

    // Check if i < j
    CMP R0, R1              // Compare i and j
    BGE check_i_equals_k    // If i >= j, skip to next check
    MOV R4, #1
    STR R4, [R3]            // A[0] = 1

check_i_equals_k:
    CMP R0, R2              // Compare i and k
    BNE end_func            // If i != k, return result
    MOV R4, #2
    STR R4, [R3, #4]        // A[1] = 2

    // Check if A[2] > j
    LDR R4, [R3, #8]        // Load A[2] into R4
    CMP R4, R1              // Compare A[2] and j
    BLE end_func            // If A[2] <= j, return result
    MOV R4, #4
    STR R4, [R3, #12]       // A[3] = 4

end_func:
    MOV PC, LR              // Return from function
