module datapath(
    input [15:0] datapath_in, 
    input [2:0] writenum,//✓
    input write,//✓
    input [2:0] readnum,//✓
    input clk, //✓
    input [1:0] ALUop,  //✓
    input [1:0] shift, //✓
    input [1:0] vsel, //✓           
    input asel,//✓
    input bsel,//✓
    input loada, loadb, loadc, loads,//✓
    output wire [15:0] datapath_out,
    output wire Z_out,

    output wire N_out, //negative eflag
    output wire V_out, //overflow flag

    // new stuff for lab 6
    input [15:0] mdata,//✓
    input [7:0] pc,//✓

    input [15:0] sximm8,//✓ 
    input [15:0] sximm5//✓





);

    wire [15:0] data_out;// Output from the register file //✓
    reg [15:0] A_reg, B_reg; //shift input opeartion i sb reg 
    reg [15:0] C_reg;// Pipeline registers A and B
 // Flags: Zero, Negative, Overflow

    // need intermediate wires? 
    wire ALU_Z, ALU_N, ALU_V; // Flags from the ALU
    
    reg[2:0] status_reg; //register flags 
    assign Z_out = status_reg[0];
    assign N_out = status_reg[1]; 
    assign V_out = status_reg[2];

    wire [15:0] Ain, Bin;//✓
    wire [15:0] ALU_out;//✓ 

    wire [15:0] shifter_out;//✓
    wire [15:0] write_data;// Data to be written back to the register file //✓

    // mved output assignment 
    assign datapath_out = C_reg;
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
        .in(B_reg), //shift in
        .shift(shift),//shift operationg
        .sout(shifter_out) //shift_out
    );

    // Load pipeline registers A and B
    //  needs to be different for lab 6?
    always @(posedge clk) begin
        if (loada) A_reg <= data_out; // Load A with data_out if loada is high
        // A holds the first operand for the ALU from the reg file
        if (loadb) B_reg <= data_out; // Load B with data_out if loadb is high
        // B holds the second operand for the ALU from the reg file or the shifter
        if (loadc) C_reg <= ALU_out; // Load C with ALU_out if loadc is high
        // C holds the output of the ALU to be written back to the register file
        if (loads) status_reg <= {ALU_V, ALU_N, ALU_Z}; // Load the status register with the flags

    end

    // Select Ain and Bin inputs for the ALU

    // edit later for lab 6
    assign Ain = (asel) ? 16'b0 : A_reg;
    assign Bin = (bsel) ? sximm5 : shifter_out;

    // Instantiate the ALU
    ALU ALU_unit(
        .Ain(Ain),
        .Bin(Bin), 
        .ALUop(ALUop), 
        .out(ALU_out),
        .Z(ALU_Z),
        .N(ALU_N),
        .V(ALU_V)
    );





    // need a bunch of stuff ehre for lab 6 
    // Load the ALU output into C_reg when loadc is high
    // always @(posedge clk) begin
    //     if (loadc) C_reg <= ALU_out;
    //     // C holds the output of the ALU to be written back to the register file
    // end

        // moved to multiplexer at the top so this one was redundant 

    // Output assignment


    // Set the status register flags


    // Data to be written back to the register file
    assign write_data = (vsel ==2'b00) ? C_reg:
                        (vsel ==2'b01) ? {8'b0, pc}:
                        (vsel ==2'b10) ? sximm8:
                        (vsel ==2'b11) ? mdata:
                        16'b0;




endmodule