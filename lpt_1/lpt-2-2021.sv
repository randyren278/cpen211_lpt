module MealyDec(state, in, out);
    input [1:0] state;   // 2-bit state input
    input in;            // 1-bit input signal
    output reg [2:0] out;  // 3-bit output signal

    // Define states using localparam
    localparam Sa = 2'd0, Sb = 2'd1, Sc = 2'd2, Sd = 2'd3;

    // Combinational logic to determine the output based on state and input
    always_comb begin
        case(state)
            Sa: case (in)
                1'b0: out = 3'b111;  // Transition from Sa to output 111 on input 0
                default: out = 3'b101;  // Transition from Sa to output 101 on any other input
            endcase
            Sb: case (in)
                1'b0: out = 3'b001;  // Transition from Sb to output 001 on input 0
                default: out = 3'b011;  // Transition from Sb to output 011 on any other input
            endcase
            Sc: case (in)
                1'b0: out = 3'b000;  // Transition from Sc to output 000 on input 0
                default: out = 3'b100;  // Transition from Sc to output 100 on any other input
            endcase
            Sd: out = 3'b110;  // Sd outputs 110 regardless of input
            default: out = 3'bxxx;  // Default output for undefined states
        endcase
    end
endmodule