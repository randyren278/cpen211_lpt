.global clunky
clunky:
    MOV R1, #0//result
    MOV R2, #0//  next=0
loop:
    LDR R3, [R0,R2,LSL #2]
    CMP R3, #-1
    BEQ end

    LDR R4, [R0,R2,LSL #2] //A[next]
    ADD R4,R4, #1
    LDR R5, [R0,R4,LSL #2] //A[next+1]
    ADD R1,R1,R5 //result+=A[Next+1] 
    MOV R6, R3, ASR #1 //tmp/2 block
    AND R6, R6, #1
    CMP R6, #1
    BEQ if
    B else

if:
    MOV R7, #-1
    STR R7, [R0,R2,LSL #2] //A[next]=-1
    B nxtmp

else: 
    MOV R7, #-2
    STR R7, [R0,R2,LSL #2] 
    B nxtmp

nxtmp:
    MOV R2, R3 //next=tmp
    B loop

end:
    MOV R0, R1 //R0=result  
    MOV PC, LR 
.global _start
_start:
 LDR R0,=A
 BL clunky
end: B end // infinite loop; R0 should contain return value of clunky
A: .word 4,1,6,2,2,3,-1,4