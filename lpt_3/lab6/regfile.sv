module regfile(data_in, writenum, write, readnum, clk, data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output [15:0] data_out;

    reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7; // 8 registers

    // Write operation
    always @(posedge clk) begin
        if (write) begin
            case (writenum)
                3'b000: R0 <= data_in;
                3'b001: R1 <= data_in;
                3'b010: R2 <= data_in;
                3'b011: R3 <= data_in;
                3'b100: R4 <= data_in;
                3'b101: R5 <= data_in;
                3'b110: R6 <= data_in;
                3'b111: R7 <= data_in;
                default: ;
            endcase
        end
    end

    // Read operation
    reg [15:0] data_out_reg;
    always @(*) begin
        case (readnum)
            3'b000: data_out_reg = R0;
            3'b001: data_out_reg = R1;
            3'b010: data_out_reg = R2;
            3'b011: data_out_reg = R3;
            3'b100: data_out_reg = R4;
            3'b101: data_out_reg = R5;
            3'b110: data_out_reg = R6;
            3'b111: data_out_reg = R7;
            default: data_out_reg = 16'b0;
        endcase
    end

    assign data_out = data_out_reg;

endmodule