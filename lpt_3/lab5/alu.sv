module ALU(Ain,Bin,ALUop,out,Z);
input [15:0] Ain, Bin; //input data
input [1:0] ALUop; //determines the operation to be performed
output reg [15:0] out; //output of the ALU
output reg Z; // becomes 1 if the output is zero

//ALU operations
always @(*) begin
    case (ALUop)
        2'b00: out = Ain + Bin; //addition
        2'b01: out = Ain - Bin; //subtraction
        2'b10: out = Ain & Bin; //bitwise AND
        2'b11: out = ~ Bin; //bitwise not
        default: out = 16'b0; //default value is 0 when inputs aren't matched
    endcase
    // set z flag if output is 0 
    if (out == 16'b0) begin
        Z = 1;
    end else begin
        Z = 0;
    end
end

//passed all tests :)


endmodule
