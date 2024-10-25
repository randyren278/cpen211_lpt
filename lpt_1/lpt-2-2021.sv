module MealyDec(state, in, out);
    input [1:0] state;   // 2-bit state input
    input in;            // 1-bit input signal
    output reg [2:0] out;  // 3-bit output signal

    // Combinational logic to determine the output based on state and input
    always @(*) begin
        case (state)
            2'b00: begin // State A
                if (in == 1'b0) 
                    out = 3'b111;  // Transition: A -> B with input 0
                else 
                    out = 3'b101;  // Transition: A -> C with input 1
            end
            2'b01: begin // State B
                if (in == 1'b0) 
                    out = 3'b001;  // Transition: B -> D with input 0
                else 
                    out = 3'b011;  // Transition: B -> A with input 1
            end
            2'b10: begin // State C
                if (in == 1'b0) 
                    out = 3'b000;  // Transition: C -> B with input 0
                else 
                    out = 3'b100;  // Transition: C -> D with input 1
            end
            2'b11: begin // State D
                if (in == 1'b0) 
                    out = 3'b110;  // Transition: D -> D with input 0
                else 
                    out = 3'b110;  // Transition: D -> D with input 1
            end
            default: 
                out = 3'b000;  // Default output
        endcase
    end
endmodule

