module datapath(
    input [15:0] datapath_in,
    input [2:0] writenum,
    input write,
    input [2:0] readnum,
    input clk,
    input [1:0] ALUop,
    input [1:0] shift,
    input vsel,           
    input asel,
    input bsel,
    input loada, loadb, loadc, loads,
    output wire [15:0] datapath_out,
    output wire Z_out
);

    wire [15:0] data_out;       // Output from the register file
    reg [15:0] A_reg, B_reg;    // Pipeline registers A and B
    wire [15:0] Ain, Bin;
    wire [15:0] ALU_out;
    wire [15:0] shifter_out;
    wire [15:0] write_data;     // Data to be written back to the register file

    // Instantiate the register file
    regfile REGFILE(
        .data_in(write_data),
        .writenum(writenum),
        .write(write),
        .readnum(readnum),
        .clk(clk),
        .data_out(data_out)
    );

    // Instantiate the shifter
    shifter SHIFTER_unit(
        .in(B_reg),
        .shift(shift),
        .sout(shifter_out)
    );

    // Load pipeline registers A and B
    always @(posedge clk) begin
        if (loada) A_reg <= data_out; // Load A with data_out if loada is high
        // A holds the first operand for the ALU from the reg file
        
        if (loadb) B_reg <= data_out; // Load B with data_out if loadb is high
        // B holds the second operand for the ALU from the reg file or the shifter
    end

    // Select Ain and Bin inputs for the ALU
    assign Ain = (asel) ? 16'b0 : A_reg;
    assign Bin = (bsel) ? datapath_in : shifter_out;

    // Instantiate the ALU
    ALU ALU_unit(
        .Ain(Ain),
        .Bin(Bin),
        .ALUop(ALUop),
        .out(ALU_out),
        .Z(Z_out)
    );

    // Register to hold ALU output
    reg [15:0] C_reg;

    // Load the ALU output into C_reg when loadc is high
    always @(posedge clk) begin
        if (loadc) C_reg <= ALU_out;
        // C holds the output of the ALU to be written back to the register file
    end

    // Output assignment
    assign datapath_out = C_reg;

    // Data to be written back to the register file
    assign write_data = (vsel) ? datapath_in : datapath_out;

endmodule
