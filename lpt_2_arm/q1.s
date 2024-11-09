.global _start
_start:
 MOV R0, #1 // i=1
 MOV R1, #1 // j=1
 MOV R2, #1 // k=1
 LDR R3, =data // set base of A = first address of array “data”
 BL func
END: B END // infinite loop; R0 should contain return value of func
.global func
func:
    LDR R4, [R3] //A[0]
    LDR R5, [R3, #4] // load A[1] 
    ADD R6, R4, R5 
    MOV R0, R6 //moves result to R0
    
    MOV R4, #42
    STR R4, [R3] // store 42 in A[0]

    AND R7, R0, #1 // R7=i&1
    //checks if i is odd
    CMP R7, #0 //compares it with 0 
    BEQ jk 
    // if odd
    MOV R4, #1
    STR R4,[R3] //store 1 in A[0]

jk:
    CMP R1, R2
    BLE else //if j<=k
    MOV R4, #2
    STR R4, [R3, #4] //store 2 in A[1]
    B end

else:
    MOV R4, #3
    STR R4, [R3, #8] //store 3 in A[2]
    CMP R0,#0
    BGE end
    CMP R2, #10
    BLE end

    MOV R4,#0
    SUB R4,R4,R1 //r4=-j
    STR R4,[R3, #12] //store -j in A[3]

end:
    MOV PC, LR

data:
 .word 0, 0, 0, 0 