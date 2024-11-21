module instruction_decoder(
    input [15:0] instruction, //✓

    output [2:0] opcode,//✓
    output [1:0] opaluop,//✓
    output [1:0] shiftop,//✓
    output [15:0] sximm8,//✓
    output [15:0] sximm5,//✓
    // register selector between Rn,Rd, a nd Rm
    input [1:0] nsel,//✓ 

    output [2:0] readnum,//✓
    output [2:0] writenum//✓ 



);
    assign opcode = instruction[15:13];
    assign opaluop = instruction[12:11];
    assign shiftop = instruction[4:3];
    assign sximm8 = {{8{instruction[7]}}, instruction[7:0]};
    assign sximm5 = {{11{instruction[4]}}, instruction[4:0]}; // sign exteneded to 16 bits
    wire [2:0] Rm = instruction[2:0];
    wire [2:0] Rd = instruction[7:5];
    wire [2:0] Rn = instruction[10:8];

    // Assign `readnum` based on `nsel`
    assign readnum = (nsel == 2'b00) ? Rm :
                     (nsel == 2'b01) ? Rd :
                     (nsel == 2'b10) ? Rn :
                     3'b0;

    // Assign `writenum` based on `nsel`
    assign writenum = (nsel == 2'b00) ? Rm :
                      (nsel == 2'b01) ? Rd :
                      (nsel == 2'b10) ? Rn :
                      3'b0;

endmodule