module top_module(
    input clk,
    input reset,
    input [1:0] in,
    output reg [1:0] out
);

// State encoding
localparam STATE_A = 2'b01, 
           STATE_B = 2'b11,  
           STATE_C = 2'b10, 
           STATE_D = 2'b11,  
           STATE_E = 2'b00;

reg [1:0] current_state, next_state;

// State transition logic on clock or reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= STATE_A;  // Reset to STATE_A
    end else begin
        current_state <= next_state;  // Transition to next state
    end
end

// Next state logic using a case statement
always @(*) begin
    case (current_state)
        STATE_A: begin
            case (in)
                2'b00: next_state = STATE_C;
                2'b11: next_state = STATE_B;
                default: next_state = STATE_A;
            endcase
        end

        STATE_B: begin
            case (in)
                2'b01: next_state = STATE_E;
                default: next_state = STATE_B;
            endcase
        end

        STATE_C: begin
            case (in)
                2'b01: next_state = STATE_B;
                2'b11: next_state = STATE_E;
                2'b10: next_state = STATE_D;
                default: next_state = STATE_C;
            endcase
        end

        STATE_D: next_state = STATE_C; 

        STATE_E: begin
            case (in)
                2'b00: next_state = STATE_D;
                default: next_state = STATE_E;
            endcase
        end

        default: next_state = STATE_A;  // Default case
    endcase
end

// Output logic using a case statement
always @(*) begin
    case (current_state)
        STATE_A: out = 2'b01;  // Output for STATE_A
        STATE_B: out = 2'b11;  // Output for STATE_B
        STATE_C: out = 2'b10;  // Output for STATE_C
        STATE_D: out = 2'b11;  // Output for STATE_D (same encoding as STATE_B)
        STATE_E: out = 2'b00;  // Output for STATE_E
        default: out = 2'b01;  // Default output (shouldn't occur)
    endcase
end

endmodule
