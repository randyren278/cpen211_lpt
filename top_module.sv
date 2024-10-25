module top_module(clk, reset, in, out);
    input clk;
    input reset;
    input [1:0] in;
    output reg [1:0] out;

    localparam Sa = 3'd0, Sb = 3'd1, Sc = 3'd2, Sd = 3'd3, Se = 3'd4;

    reg [2:0] current_state , next_state;
    always_ff @(posedge clk) begin
        if ( reset ) begin
            current_state = Sa ;
            out = 2'b01; // usually here need the output
        end else begin
            case (current_state) 
                Sa: case(in)
                        2'b00: next_state = Sc;
                        2'b11: next_state = Sb;
                        default: next_state = Sa;
                    endcase
                Sb: case(in)
                        2'b01: next_state = Se;
                        default: next_state = Sb;
                    endcase
                Se: case(in)
                        2'b00: next_state = Sd;
                        default: next_state = Se;
                    endcase
                Sd: next_state = Sc;
                Sc: case(in)
                        2'b01: next_state = Sb;
                        2'b11: next_state = Se;
                        2'b10: next_state = Sd;
                        default: next_state = Sc;
                    endcase
            endcase
        
        // do not use end here
        current_state = next_state;
            case (current_state) 
                Sa : out = 2'b01;
                Sb : out = 2'b11;
                Sc : out = 2'b10;
                Sd : out = 2'b11;
                Se : out = 2'b00;
                default: out = 2'bxx;
            endcase
        end
    end
endmodule