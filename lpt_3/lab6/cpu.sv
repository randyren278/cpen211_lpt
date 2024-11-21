module cpu(clk,reset,s,load,in,out,N,V,Z,w);
input clk, reset, s, load;
input [15:0] in;
output [15:0] out;
output N, V, Z, w; 

    // Instruction Register
    reg [15:0] instr_reg; //✓

    // Decoder Outputs
    wire [2:0] opcode;       //✓
    wire [1:0] opaluop;      //✓
    wire [1:0] shiftop;      //✓
    wire [15:0] sximm8;      //✓
    wire [15:0] sximm5;      //✓
    wire [2:0] readnum, writenum; //✓

    // Controller Outputs
    wire loada, loadb, loadc, loads, asel, bsel, write; //✓
    wire [1:0] nsel, vsel;    //✓
    wire wait_state;          //✓

    // Datapath Status Flags
    wire Z_out, N_out, V_out;

    // Assign flags to outputs
    assign Z = Z_out;
    assign N = N_out;
    assign V = V_out;

    // Wait signal assignment
    assign w = wait_state;

    // Instruction Register Logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            instr_reg <= 16'b0;
        else if (load)
            instr_reg <= in;
    end

    // Instruction Decoder
    instruction_decoder instruction_decoder (
        .instruction(instr_reg),
        .opcode(opcode),
        .opaluop(opaluop),
        .shiftop(shiftop),
        .sximm8(sximm8),
        .sximm5(sximm5),
        .nsel(nsel),
        .readnum(readnum),
        .writenum(writenum)
    );

    // Controller (FSM)
    fsm_controller fsm_controller (
        .clk(clk),
        .reset(reset),
        .s(s),
        .opcode(opcode),
        .ALU_op(opaluop),
        .shift_op(shiftop),
        .nsel(nsel),
        .loada(loada),
        .loadb(loadb),
        .loadc(loadc),
        .loads(loads),
        .asel(asel),
        .bsel(bsel),
        .write(write),
        .vsel(vsel),
        .wait_state(wait_state),
        .Z(Z_out),
        .N(N_out),
        .V(V_out)
    );

    // Datapath
    datapath DP (
        .datapath_in(instr_reg), 
        .writenum(writenum),
        .write(write),
        .readnum(readnum),
        .clk(clk),
        .ALUop(opaluop),
        .shift(shiftop),
        .vsel(vsel),
        .asel(asel),
        .bsel(bsel),
        .loada(loada),
        .loadb(loadb),
        .loadc(loadc),
        .loads(loads),
        .datapath_out(out),
        .Z_out(Z_out),
        .N_out(N_out),
        .V_out(V_out),
        .sximm8(sximm8),
        .sximm5(sximm5),
        .mdata(16'b0),
        .pc(8'b0)  
    );

endmodule