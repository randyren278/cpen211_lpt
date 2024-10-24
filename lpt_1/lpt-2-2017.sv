module top_module(clk,reset,in,out);

localparam STATE_A =2'b01, 
STATE_B = 2'b11, 
STATE_C = 2'b10, 
STATE_D = 2'b11, 
STATE_E=2'b00;

reg [1:0] current_state, next_state;

always @(posedge clk or posedge reset ) begin
    if (reset) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
    
end

//next state logic

always @(*) begin
    case (current_state)
        STATE_A: begin
            if (in==2'b00)
                next_state = STATE_C;
            else if (in==2'b11)
                next_state= STATE_B;
            else 
                next_state = STATE_A;
        end

        STATE_B: begin
            if (in==2'b01)
                next_state = STATE_E;
            else
                next_state = STATE_B;
        end

        STATE_C: begin
            if (in==2'b01)
                next_state = STATE_B;
            else if (in==2'b11)
                next_state = STATE_E;
            else if (in==2'b10) 
                next_state = STATE_D;
            else
                next_state = STATE_C;
        end

        STATE_D: begin
            next_state = STATE_C;
        end

        STATE_E: begin
            if (in==2'b00)
                next_state = STATE_D;
            else
                next_state = STATE_E;
        end

        default: next_state = STATE_A;
        
        
        
    endcase
    
end

always @(*) begin
    case (current_state)
        STATE_A: out = 2'b01;
        STATE_B: out = 2'b11;
        STATE_C: out = 2'b10;
        STATE_D: out = 2'b11;
        STATE_E: out = 2'b00;
        default: out = 2'b01;
    endcase
end

endmodule