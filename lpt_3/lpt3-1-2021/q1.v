module datapath(clk, in, sr, Rn, w, aluop, lt, tsel, bsel, out);
    input clk, w, lt;
    input [7:0] in;
    input [1:0] sr, Rn, aluop;
    input [2:0] bsel, tsel;
    output reg [7:0] out;

    reg [7:0] R0, R1, R2, R3, tmp; 
    wire [7:0] Bin, alu_out, tselmux_out, rin;

    // Loader Logic
    always @(posedge clk) begin
        if (w) begin
            case (Rn)
                2'b00: R0 <= rin;
                2'b01: R1 <= rin;
                2'b10: R2 <= rin;
                2'b11: R3 <= rin;
            endcase
        end
    end

    // Select input for register loading
    assign rin = (sr[0]) ? in :
                 (sr[1]) ? alu_out :
                 (sr[2]) ? tmp :
                 8'b0;

    // ALU Logic
    assign Bin = (bsel[0]) ? R1 :
                 (bsel[1]) ? R2 :
                 (bsel[2]) ? R3 :
                 8'b0;

    always @(*) begin
        case (aluop)
            2'b00: alu_out = tmp ^ Bin;
            2'b01: alu_out = tmp & Bin;
            2'b10: alu_out = tmp << 1;
            2'b11: alu_out = Bin;
            default: alu_out = 8'b0;
        endcase
    end

    // Multiplexer for tsel
    assign tselmux_out = (tsel[0]) ? alu_out :
                         (tsel[1]) ? R0 :
                         (tsel[2]) ? Bin :
                         8'b0;

    // Temporary Register Logic
    always @(posedge clk) begin
        if (lt) begin
            tmp <= tselmux_out;
        end
    end

    // Output Logic
    always @(posedge clk) begin
        out <= R0;
    end

endmodule
