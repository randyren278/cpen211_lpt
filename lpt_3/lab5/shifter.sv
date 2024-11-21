module shifter(in,shift,sout);
input [15:0] in;
input [1:0] shift;
output reg [15:0] sout; // output after shifting

//shifting operations
always @(*) begin
    case (shift)
        2'b00: sout = in; //no shift
        2'b01: sout = in << 1; //lsl 0 as LSB and shifts left
        2'b10: sout = in >> 1; //lsr 0 as MSB and shifts right
        2'b11: sout = {in[15],in[15:1]}; //asr shifts right with MSB preserved
        default: sout = in;
    endcase
end


//shifter works


endmodule
