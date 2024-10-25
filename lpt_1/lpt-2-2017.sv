module top_module(clk, reset, in, out);
    input clk, reset;
    input [1:0] in;  // Modify input width if needed
    output [1:0] out;  // Modify output width if needed

    reg [1:0] out;  // Output register
    reg [2:0] state_checker;  // Use this reg to check the state

    // Local parameters to define the states. You can modify/add states as needed
    localparam Sa = 3'd0, Sb = 3'd1, Sc = 3'd2, Sd = 3'd3, Se = 3'd4;
    reg [2:0] current_state, next_state;  // These hold the current and next states

    // Sequential logic to move between states on a clock edge
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state = 3'b01;  // Initial state (modify as needed)
            out = 3'b01;  // Initial output (modify as needed)
        end else begin
            // State transition logic
            case (current_state)
                Sa: case(in)  // When in state Sa, choose next state based on input
                        2'b11: next_state = Sb;  // Modify input conditions and transitions
                        2'b00: next_state = Sc;
                        default: next_state = Sa;
                    endcase
                Sb: case(in)
                        2'b01: next_state=Se;
                        default: next_state=Sb;
                    endcase  // Modify as needed (Sb transitions)
                Sc: case(in)
                        2'b01: next_state = Sb;
                        2'b11: next_state = Se;
                        2'b10: next_state = Sd;
                        default: next_state = Sc;
                    endcase
                Sd: next_state = Sc;  // Sd always goes to Sc in this example
                Se: case(in)
                        2'b00: next_state = Sd;
                        default: next_state = Se;
                    endcase
                default: next_state = 3'bxxx;  // Ensure valid default state
            endcase

            current_state = next_state;  // Update the state
            // Output logic based on current state
            case (current_state)
                Sa: out = 3'b01;  // Modify outputs for each state
                Sb: out = 3'b11;
                Sc: out = 3'b10;
                Sd: out = 3'b11;
                Se: out = 3'b00;
                default: out = 3'bxxx;  // Set default output
            endcase
        end
    end
    // Optional: Assign state_checker to current_state for debugging
    assign state_checker = current_state;
endmodule