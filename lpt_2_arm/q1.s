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
 // ADD YOUR CODE HERE
 MOV PC, LR
data:
 .word 0, 0, 0, 0 