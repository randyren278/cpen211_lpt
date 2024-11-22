module bitwise(clk, reset, s, op, in, out, done);
    input clk, reset, s;
    input [7:0] in;
    input [3:0] op;
    output [7:0] out;
    output reg done; // Changed from wire to reg

    // Control signals for the datapath
    reg [1:0] sr, Rn, aluop;
    reg w, lt;
    reg [2:0] bsel, tsel;
    
    // Instantiate the datapath
    datapath DP(
        .clk(clk),
        .in(in),
        .sr(sr),
        .Rn(Rn),
        .w(w),
        .aluop(aluop),
        .lt(lt),
        .tsel(tsel),
        .bsel(bsel),
        .out(out)
    );
    
    // State encoding
    localparam S_WAIT   = 4'd0,
               S_MOV    = 4'd1,
               S_XOR_1  = 4'd2,
               S_XOR_2  = 4'd3,
               S_XOR_3  = 4'd4,
               S_ASL_1  = 4'd5,
               S_ASL_2  = 4'd6,
               S_ASL_3  = 4'd7,
               S_ASL_4  = 4'd8,
               S_SWP_1  = 4'd9,
               S_SWP_2  = 4'd10,
               S_SWP_3  = 4'd11;
    
    reg [3:0] state, next_state;
    
    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S_WAIT;
        else
            state <= next_state;
    end
    
    // Combinational logic for next state and control signals
    always @(*) begin
        // Default assignments
        next_state = state;
        sr        = 2'b00;
        Rn        = 2'b00;
        aluop     = 2'b00;
        w         = 1'b0;
        lt        = 1'b0;
        tsel      = 3'b000;
        bsel      = 3'b000;
        done      = 1'b0; // Default done to 0
        
        case (state)
            // Wait State
            S_WAIT: begin
                done = 1'b1; // Assert done in wait state
                if (s) begin
                    case (op[3:2])
                        2'b00: next_state = S_MOV;
                        2'b01: next_state = S_XOR_1;
                        2'b10: next_state = S_ASL_1;
                        2'b11: next_state = S_SWP_1;
                        default: next_state = S_WAIT;
                    endcase
                end
            end
            
            // MOV Instruction
            S_MOV: begin
                sr   = 2'b00;           // Select 'in' as source
                Rn   = op[1:0];         // Select Ri
                w    = 1'b1;            // Enable write
                lt   = 1'b0;            // No tmp update
                done = 1'b0;
                next_state = S_WAIT;
            end
            
            // XOR Instruction - Step 1: tmp = R1
            S_XOR_1: begin
                tsel  = 3'b100;         // Select Bin (R1)
                bsel  = 3'b001;         // Choose R1
                lt    = 1'b1;           // Enable tmp update
                done  = 1'b0;
                next_state = S_XOR_2;
            end
            
            // XOR Instruction - Step 2: tmp = tmp ^ R2
            S_XOR_2: begin
                aluop = 2'b00;           // XOR operation
                bsel  = 3'b010;           // Choose R2
                tsel  = 3'b001;           // Select ALU output
                lt    = 1'b1;            // Enable tmp update
                done  = 1'b0;
                next_state = S_XOR_3;
            end
            
            // XOR Instruction - Step 3: R0 = tmp
            S_XOR_3: begin
                sr   = 2'b10;            // Select tmp
                Rn   = 2'b00;            // Select R0
                w    = 1'b1;             // Enable write
                lt   = 1'b0;             // No tmp update
                done = 1'b0;
                next_state = S_WAIT;
            end
            
            // ASL Instruction - Step 1: tmp = R1
            S_ASL_1: begin
                tsel  = 3'b100;         // Select Bin (R1)
                bsel  = 3'b001;         // Choose R1
                lt    = 1'b1;            // Enable tmp update
                done  = 1'b0;
                next_state = S_ASL_2;
            end
            
            // ASL Instruction - Step 2: tmp = tmp & R2
            S_ASL_2: begin
                aluop = 2'b01;           // AND operation
                bsel  = 3'b010;           // Choose R2
                tsel  = 3'b001;           // Select ALU output
                lt    = 1'b1;            // Enable tmp update
                done  = 1'b0;
                next_state = S_ASL_3;
            end
            
            // ASL Instruction - Step 3: tmp = tmp << 1
            S_ASL_3: begin
                aluop = 2'b10;           // Shift left operation
                tsel  = 3'b001;           // Select ALU output
                lt    = 1'b1;            // Enable tmp update
                done  = 1'b0;
                next_state = S_ASL_4;
            end
            
            // ASL Instruction - Step 4: R0 = tmp
            S_ASL_4: begin
                sr   = 2'b10;            // Select tmp
                Rn   = 2'b00;            // Select R0
                w    = 1'b1;             // Enable write
                lt   = 1'b0;             // No tmp update
                done = 1'b0;
                next_state = S_WAIT;
            end
            
            // SWP Instruction - Step 1: tmp = R0
            S_SWP_1: begin
                tsel  = 3'b010;         // Select R0
                bsel  = 3'b000;         // bsel not used
                lt    = 1'b1;            // Enable tmp update
                done  = 1'b0;
                next_state = S_SWP_2;
            end
            
            // SWP Instruction - Step 2: R0 = Ri
            S_SWP_2: begin
                aluop = 2'b11;           // Pass-through operation
                case (op[1:0])
                    2'b00: bsel = 3'b000; // Invalid (R0 cannot be selected via bsel)
                    2'b01: bsel = 3'b001; // R1
                    2'b10: bsel = 3'b010; // R2
                    2'b11: bsel = 3'b100; // R3
                    default: bsel = 3'b000;
                endcase
                sr   = 2'b01;            // Select ALU output (Bin)
                Rn   = 2'b00;            // Select R0
                w    = 1'b1;             // Enable write
                lt   = 1'b0;             // No tmp update
                done = 1'b0;
                next_state = S_SWP_3;
            end
            
            // SWP Instruction - Step 3: Ri = tmp
            S_SWP_3: begin
                sr   = 2'b10;            // Select tmp
                Rn   = op[1:0];          // Select Ri
                w    = 1'b1;             // Enable write
                lt   = 1'b0;             // No tmp update
                done = 1'b0;
                next_state = S_WAIT;
            end
            
            // Default case
            default: begin
                next_state = S_WAIT;
                done       = 1'b1;
            end
        endcase
    end
    
endmodule
