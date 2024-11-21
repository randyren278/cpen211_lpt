module shifter(in, shift, sout);
    input [15:0] in;
    input [1:0] shift;
    output reg [15:0] sout;

    always @(*) begin
        case (shift)
            2'b00: sout = in;// No shift
            2'b01: sout = in << 1;// Logical shift left by 1
            2'b10: sout = in >> 1;// Logical shift right by 1
            2'b11: sout = {in[15], in[15:1]}; // Arithmetic shift right by 1
            default: sout = in;
        endcase
    end

endmodule