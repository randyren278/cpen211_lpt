module top_module(clk, reset, in, out);
    input clk, reset;
    input [1:0] in;  // Modify input width if needed
    output [2:0] out;  // Modify output width if needed

    reg [2:0] out;  // Output register

    // Local parameters to define the states. You can modify/add states as needed
    localparam Sa = 3'b000, Sb = 3'b001, Sc = 3'b010, Sd = 3'b011, Se = 3'b100;
    reg [2:0] current_state, next_state;  // These hold the current and next states

    // Sequential logic to move between states on a clock edge
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state = 3'b000;  // Initial state (modify as needed)
            out = 3'b000;  // Initial output (modify as needed)
        end else begin
            // State transition logic
            case (current_state)
                Sa: case(in)  // When in state Sa, choose next state based on input
                        2'b01: next_state = Sb;  // Modify input conditions and transitions
                        2'b10: next_state = Sd;
                        default: next_state = Sa;
                    endcase
                Sb: next_state = Sa;  // Modify as needed (Sb transitions)
                Sc: case(in)
                        2'b01: next_state = Se;
                        2'b11: next_state = Sb;
                        default: next_state = Sc;
                    endcase
                Sd: next_state = Sc;  // Sd always goes to Sc in this example
                Se: case(in)
                        2'b11: next_state = Sd;
                        default: next_state = Se;
                    endcase
                default: next_state = 3'bxxx;  // Ensure valid default state
            endcase

            current_state = next_state;  // Update the state
            // Output logic based on current state
            case (current_state)
                Sa: out = 3'b000;  // Modify outputs for each state
                Sb: out = 3'b001;
                Sc: out = 3'b010;
                Sd: out = 3'b000;
                Se: out = 3'b100;
                default: out = 3'bxxx;  // Set default output
            endcase
        end
    end
endmodule