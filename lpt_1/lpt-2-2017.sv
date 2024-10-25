module top_module(clk, reset, in, out);
    input clk, reset;  // Clock and reset inputs
    input [1:0] in;  // 2-bit input signal; modify input width if needed
    output [1:0] out;  // 3-bit output signal; modify output width if needed

    reg [1:0] out;  // Output register to hold the current output value

    // Local parameters to define the states. Add or modify states as needed
    localparam Sa = 3'd1, Sb = 3'd2, Sc = 3'd3, Sd = 3'd4, Se = 3'd5;
    reg [2:0] current_state, next_state;  // Registers to hold the current and next states

    // Sequential logic to handle state transitions on the rising edge of the clock
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state = 3'd1;  // Set to initial state (Sa) on reset; modify if needed
            out = 2'b01;  // Initialize output; modify based on desired initial output
        end else begin
            // State transition logic based on the current state and input
            case (current_state)
                Sa: case(in)  // When in state Sa, determine next state based on input
                        2'b00: next_state = Sc;  // Transition to Sb on input '01'; modify conditions as needed
                        2'b11: next_state = Sb;  // Transition to Sd on input '10'
                        default: next_state = Sa;  // Remain in Sa for other inputs
                    endcase
                Sb: case (in)
                        2'b01: next_state = Se;  // Transition  to Se on input '01' 
                        default: next_state=Sb;  // Remain in Sb for other inputs 
                endcase // Transition back to Sa from Sb; modify transitions as needed
                Sc: case(in)  // When in state Sc, determine next state based on input
                        2'b01: next_state = Sb;  // Transition to Sb on input '01'
                        2'b11: next_state = Se;  // Transition to Sb on input '11'
                        2'b10: next_state = Sd;  // Transition to Sd on input '10'
                        default: next_state = Sc;  // Remain in Sc for other inputs
                    endcase
                Sd: next_state = Sc;  // Always transition to Sc from Sd; modify if different behavior is required
                Se: case(in)  // When in state Se, determine next state based on input
                        2'b00: next_state = Sd;  // Transition to Sd on input '11'
                        default: next_state = Se;  // Remain in Se for other inputs
                    endcase
                default: next_state = 2'bxx;  // Undefined state; ensure all states are covered to avoid latches
            endcase

            current_state = next_state;  // Update the current state to the next state
            // Output logic based on the current state
            case (current_state)
                Sa: out = 2'b01;  // Output for state Sa; modify if different outputs are needed
                Sb: out = 2'b11;  // Output for state Sb
                Sc: out = 2'b10;  // Output for state Sc
                Sd: out = 2'b11;  // Output for state Sd
                Se: out = 2'b00;  // Output for state Se
                default: out = 2'bxx;  // Undefined output for invalid states
            endcase
        end
    end
endmodule