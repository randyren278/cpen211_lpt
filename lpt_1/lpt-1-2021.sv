module top_module(clk, reset, in, out);
    input clk, reset;
    input [1:0] in;
    output [2:0] out;

    reg [2:0] out;
    reg [2:0] state_checker;

    // local parameter to define the states
    localparam Sa = 3'd0, Sb = 3'd1, Sc = 3'd2, Sd = 3'd3, Se = 3'd4;
    reg [2:0] current_state, next_state;

    always_ff @(posedge clk) begin
        if ( reset ) begin
            current_state = 3'b000;
            out = 3'b000;
        end else begin
            case (current_state)
                Sa: case(in) 
                        2'd1: next_state = Sb;
                        2'd2: next_state = Sd;
                        default: next_state = Sa;
                    endcase 
                Sb: next_state = Sa;
                Sc: case(in)
                        2'd1: next_state = Se;
                        2'd3: next_state = Sb;
                        default: next_state = Sc;
                    endcase
                Sd: next_state = Sc;
                Se: case(in)
                        2'd3: next_state = Sd;
                        default: next_state = Se;
                    endcase
                default: next_state = 3'bxxx;
            endcase
        current_state = next_state;
        case (current_state)
            Sa: out = 3'b000;
            Sb: out = 3'b001;
            Sc: out = 3'b010;
            Sd: out = 3'b000;
            Se: out = 3'b100;
            default: out = 3'bxxx;
        endcase
    end
    end // when it reaches the end
    assign state_checker = current_state;
endmodule 

    