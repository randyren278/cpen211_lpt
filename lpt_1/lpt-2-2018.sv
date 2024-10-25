module top_module(clk, reset, in, out);
    input clk, reset;  // Clock and reset inputs
    input [1:0] in;  // 2-bit input signal; modify input width if needed
    output [2:0] out;  // 3-bit output signal; modify output width if needed

    reg [2:0] out;  // Output register to hold the current output value
    reg [2:0] state_checker;  // Register to monitor the current state for debugging

    // Local parameters to define the states. Add or modify states as needed
    localparam Sa = 3'd0, Sb = 3'd1, Sc = 3'd2, Sd = 3'd3, Se = 3'd4;
    reg [2:0] current_state, next_state;  // Registers to hold the current and next states in this case 3 bits to represent up to 2^3 states

    // Sequential logic to handle state transitions on the rising edge of the clock
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state = 3'd0;  // Set to initial state (Sa) on reset; modify if needed this is state based on localparam
            out = 3'b101;  // Initialize output; modify based on desired initial output this is state baed on output at bottom
        end else begin
            // State transition logic based on the current state and input
            case (current_state)
                Sa: case(in)  // When in state Sa, determine next state based on input
                        2'b11: next_state = Sb;  // Transition to Sb on input '01'; modify conditions as needed
                        default: next_state = Sa;  // Remain in Sa for other inputs
                    endcase
                Sb: case (in)
                        2'b01: next_state = Sc;  // Transition to Se on input '01'
                        2'b11: next_state = Sd;  // Transition to Sd on input '11'
                        2'b00: next_state = Se;  // Transition to Sa on input '00'
                        2'b10: next_state = Sa;  // Transition to Sa on input '10'
                        default: next_state = Sb;  // Remain in Sb for other inputs
                    endcase  // Transition back to Sa from Sb; modify transitions as needed
                Sc: next_state = Sc; // Always transition to Sc from Sc; modify if different behavior is required
                Sd: next_state = Sc;  // Always transition to Sc from Sd; modify if different behavior is required
                Se: case(in)  // When in state Se, determine next state based on input
                        2'b11: next_state = Sd;  // Transition to Sb on input '11'
                        2'b10: next_state = Sa;  // Transition to Sa on input '10'
                        default: next_state = Se;  // Remain in Se for other inputs
                    endcase
                default: next_state = 3'bxxx;  // Undefined state; ensure all states are covered to avoid latches
            endcase

            current_state = next_state;  // Update the current state to the next state
            // Output logic based on the current state
            case (current_state)
                Sa: out = 3'b101;  // Output for state Sa; modify if different outputs are needed
                Sb: out = 3'b010;  // Output for state Sb
                Sc: out = 3'b001;  // Output for state Sc
                Sd: out = 3'b101;  // Output for state Sd
                Se: out = 3'b011;  // Output for state Se
                default: out = 3'bxxx;  // Undefined output for invalid states remember to change if output bit width is different
            endcase
        end
    end

    // Optional: Assign the current state to state_checker for debugging purposes
    assign state_checker = current_state;
endmodule