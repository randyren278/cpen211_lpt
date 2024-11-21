module datapath(clk, in, sr, Rn, w, aluop, lt, tsel, bsel, out);
    input clk, w, lt;
    input [7:0] in;
    input [1:0] sr, Rn, aluop;
    input [2:0] bsel, tsel;
    output [7:0] out;

    reg [7:0] R0, R1, R2, R3, tmp, alu_out;
    wire [7:0] Bin, rin;

    // Loader Logic: Write to R0, R1, R2, or R3 based on Rn and w
    always @(posedge clk) begin
        if (w) begin
            case (Rn)
                2'b00: R0 <= rin; // Load R0
                2'b01: R1 <= rin; // Load R1
                2'b10: R2 <= rin; // Load R2
                2'b11: R3 <= rin; // Load R3
                default: ; // Do nothing
            endcase
        end
    end

    // Select input for register loading (rin)
    assign rin = (sr == 2'b00) ? in :
                 (sr == 2'b01) ? alu_out :
                 (sr == 2'b10) ? tmp :
                 8'b0;

    // ALU Logic: Combinational operations on tmp and Bin
    assign Bin = (bsel == 3'b001) ? R1 :
                 (bsel == 3'b010) ? R2 :
                 (bsel == 3'b100) ? R3 :
                 8'b0;

    always @(*) begin
        case (aluop)
            2'b00: alu_out = tmp ^ Bin;  // XOR
            2'b01: alu_out = tmp & Bin;  // AND
            2'b10: alu_out = tmp << 1;   // Left shift
            2'b11: alu_out = Bin;        // Pass-through
            default: alu_out = 8'b0;
        endcase
    end

    // Temporary Register Logic: Update tmp directly when lt is high 
    // BANG FUCK THIS SHIT
    always @(posedge clk) begin
        if (lt) begin
            case (tsel)
                3'b001: tmp <= alu_out;  // Select ALU output
                3'b010: tmp <= R0;      // Select R0
                3'b100: tmp <= Bin;     // Select Bin
                default: tmp <= 8'b0;   // Default to zero
            endcase
        end
    end

    // Output Logic: Directly connect R0 to the output
    assign out = R0;

endmodule
