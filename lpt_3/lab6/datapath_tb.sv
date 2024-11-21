module datapath_tb;
    // Inputs
    reg clk;
    reg [15:0] datapath_in;
    reg write, vsel, loada, loadb, asel, bsel, loadc, loads;
    reg [2:0] readnum, writenum;
    reg [1:0] shift, ALUop;

    // Outputs
    wire [15:0] datapath_out;
    wire Z_out;

    // Error signal
    reg err;

    // Instantiate the datapath module
    datapath DUT (
        .clk(clk),
        // Register operand fetch stage
        .readnum(readnum),
        .vsel(vsel),
        .loada(loada),
        .loadb(loadb),
        // Computation stage
        .shift(shift),
        .asel(asel),
        .bsel(bsel),
        .ALUop(ALUop),
        .loadc(loadc),
        .loads(loads),
        // Write-back stage
        .writenum(writenum),
        .write(write),
        .datapath_in(datapath_in),
        // Outputs
        .Z_out(Z_out),
        .datapath_out(datapath_out)
    );

    // Access the contents of the register file
    wire [15:0] R0 = DUT.REGFILE.R0;
    wire [15:0] R1 = DUT.REGFILE.R1;
    wire [15:0] R2 = DUT.REGFILE.R2;
    wire [15:0] R3 = DUT.REGFILE.R3;
    wire [15:0] R4 = DUT.REGFILE.R4;
    wire [15:0] R5 = DUT.REGFILE.R5;
    wire [15:0] R6 = DUT.REGFILE.R6;
    wire [15:0] R7 = DUT.REGFILE.R7;

    // Clock generation
    initial forever begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Initialize inputs and test cases
    initial begin
        // Initialize error flag
        err = 0;

        // Set all control inputs to defined values at time = 0
        datapath_in = 16'b0;
        write = 0; vsel = 0; loada = 0; loadb = 0; asel = 0; bsel = 0;
        loadc = 0; loads = 0;
        readnum = 3'b000; writenum = 3'b000;
        shift = 2'b00; ALUop = 2'b00;
        #10; // Wait for clock to settle

        // Test Case 1: MOV R3, #42
        // Load immediate value 42 into R3
        datapath_in = 16'd42;      // Use decimal value 42
        writenum = 3'd3;
        write = 1;
        vsel = 1;
        #10; // Wait for clock edge
        write = 0; // Disable write

        // Verify that R3 now contains 42
        if (R3 !== 16'd42) begin
            err = 1;
            $display("FAILED: MOV R3, #42 -- R3=%d, expected %d", R3, 16'd42);
        end else begin
            $display("Test Case 1 (MOV R3, #42) passed");
        end


        // Test Case 2: MOV R5, #13
        // Load immediate value 13 into R5
        datapath_in = 16'd13;      // Use decimal value 13
        writenum = 3'd5;
        write = 1;
        vsel = 1;
        #10; // Wait for clock edge
        write = 0; // Disable write

        // Verify that R5 now contains 13
        if (R5 !== 16'd13) begin
            err = 1;
            $display("FAILED: MOV R5, #13 -- R5=%d, expected %d", R5, 16'd13);
        end else begin
            $display("Test Case 2 (MOV R5, #13) passed");
        end


        // Test Case 3: ADD R2, R5, R3
        // Step 1: Load R5 into A_reg
        readnum = 3'd5;
        loada = 1;
        #10; // Wait for clock edge
        loada = 0; // Disable loada

        // Step 2: Load R3 into B_reg
        readnum = 3'd3;
        loadb = 1;
        #10; // Wait for clock edge
        loadb = 0; // Disable loadb

        // Step 3: Perform addition A_reg + B_reg
        shift = 2'b00;  // No shift
        asel = 0;
        bsel = 0;
        ALUop = 2'b00;  // ADD operation
        loadc = 1;
        loads = 1;
        #10; // Wait for clock edge
        loadc = 0;
        loads = 0;

        // Step 4: Write result back to R2
        writenum = 3'd2;
        write = 1;
        vsel = 0; // Select datapath_out
        #10; // Wait for clock edge
        write = 0; // Disable write

        // Verify that R2 contains the sum of R5 and R3 (13 + 42 = 55)
        if (R2 !== 16'd55) begin
            err = 1;
            $display("FAILED: ADD R2, R5, R3 -- R2=%d, expected %d", R2, 16'd55);
        end else begin
            $display("Test Case 3 (ADD R2, R5, R3) passed");
        end

        // Verify datapath_out
        if (datapath_out !== 16'd55) begin
            err = 1;
            $display("FAILED: ADD R2, R5, R3 -- datapath_out=%d, expected %d", datapath_out, 16'd55);
        end else begin
            $display("datapath_out correctly shows the result of addition");
        end

        // Verify Z_out (should be 0 since result is not zero)
        if (Z_out !== 1'b0) begin
            err = 1;
            $display("FAILED: ADD R2, R5, R3 -- Z_out=%b, expected %b", Z_out, 1'b0);
        end else begin
            $display("Z_out correctly indicates the result is not zero");
        end


        // Test Case 4: SUB R4, R3, R5 (R4 = R3 - R5)
        // Step 1: Load R3 into A_reg
        readnum = 3'd3;
        loada = 1;
        #10;
        loada = 0;

        // Step 2: Load R5 into B_reg
        readnum = 3'd5;
        loadb = 1;
        #10;
        loadb = 0;

        // Step 3: Perform subtraction A_reg - B_reg
        shift = 2'b00;  // No shift
        asel = 0;
        bsel = 0;
        ALUop = 2'b01;  // SUB operation
        loadc = 1;
        loads = 1;
        #10;
        loadc = 0;
        loads = 0;

        // Step 4: Write result back to R4
        writenum = 3'd4;
        write = 1;
        vsel = 0;
        #10;
        write = 0;

        // Verify that R4 contains the difference (42 - 13 = 29)
        if (R4 !== 16'd29) begin
            err = 1;
            $display("FAILED: SUB R4, R3, R5 -- R4=%d, expected %d", R4, 16'd29);
        end else begin
            $display("Test Case 4 (SUB R4, R3, R5) passed");
        end

        // Verify Z_out (should be 0 since result is not zero)
        if (Z_out !== 1'b0) begin
            err = 1;
            $display("FAILED: SUB R4, R3, R5 -- Z_out=%b, expected %b", Z_out, 1'b0);
        end else begin
            $display("Z_out correctly indicates the result is not zero");
        end


        // Test Case 5: AND operation (R6 = R3 & R5)
        // Step 1: Load R3 into A_reg
        readnum = 3'd3;
        loada = 1;
        #10;
        loada = 0;

        // Step 2: Load R5 into B_reg
        readnum = 3'd5;
        loadb = 1;
        #10;
        loadb = 0;

        // Step 3: Perform bitwise AND
        shift = 2'b00;  // No shift
        asel = 0;
        bsel = 0;
        ALUop = 2'b10;  // AND operation
        loadc = 1;
        loads = 1;
        #10;
        loadc = 0;
        loads = 0;

        // Step 4: Write result back to R6
        writenum = 3'd6;
        write = 1;
        vsel = 0;
        #10;
        write = 0;

        // Verify that R6 contains the result of R3 & R5
        if (R6 !== (R3 & R5)) begin
            err = 1;
            $display("FAILED: AND R6, R3, R5 -- R6=%h, expected %h", R6, (R3 & R5));
        end else begin
            $display("Test Case 5 (AND R6, R3, R5) passed");
        end

        // Verify Z_out
        if (Z_out !== (R6 == 16'h0000)) begin
            err = 1;
            $display("FAILED: AND R6, R3, R5 -- Z_out=%b, expected %b", Z_out, (R6 == 16'h0000));
        end else begin
            $display("Z_out correctly reflects the result of the AND operation");
        end


        // Test Case 6: NOT operation (R7 = ~R5)
        // Step 1: Load R5 into B_reg (since ALU uses Bin for NOT operation)
        readnum = 3'd5;
        loadb = 1;
        #10;
        loadb = 0;

        // Step 2: Perform bitwise NOT
        shift = 2'b00;  // No shift
        asel = 1;       // Ain = 0 (ignored in NOT operation)
        bsel = 0;
        ALUop = 2'b11;  // NOT operation
        loadc = 1;
        loads = 1;
        #10;
        loadc = 0;
        loads = 0;

        // Step 3: Write result back to R7
        writenum = 3'd7;
        write = 1;
        vsel = 0;
        #10;
        write = 0;

        // Verify that R7 contains the result of ~R5
        if (R7 !== ~R5) begin
            err = 1;
            $display("FAILED: NOT R7, R5 -- R7=%h, expected %h", R7, ~R5);
        end else begin
            $display("Test Case 6 (NOT R7, R5) passed");
        end

        // Verify Z_out
        if (Z_out !== (R7 == 16'h0000)) begin
            err = 1;
            $display("FAILED: NOT R7, R5 -- Z_out=%b, expected %b", Z_out, (R7 == 16'h0000));
        end else begin
            $display("Z_out correctly reflects the result of the NOT operation");
        end


        // Test Case 7: LSL R0 by 1 (R0 = R3 << 1)
        // Step 1: Load R3 into B_reg
        readnum = 3'd3;
        loadb = 1;
        #10;
        loadb = 0;

        // Step 2: Set shift amount to LSL by 1
        shift = 2'b01;  // LSL by 1

        // Step 3: Perform shift operation
        asel = 1;       // Ain = 0
        bsel = 0;       // Use shifter output
        ALUop = 2'b00;  // ADD operation (0 + shifted B)
        loadc = 1;
        loads = 1;
        #10;
        loadc = 0;
        loads = 0;

        // Step 4: Write result back to R0
        writenum = 3'd0;
        write = 1;
        vsel = 0;
        #10;
        write = 0;

        // Verify that R0 contains R3 shifted left by 1
        if (R0 !== (R3 << 1)) begin
            err = 1;
            $display("FAILED: LSL R0, R3, #1 -- R0=%h, expected %h", R0, (R3 << 1));
        end else begin
            $display("Test Case 7 (LSL R0, R3, #1) passed");
        end


        // Test Case 8: LSR R1 by 1 (R1 = R3 >> 1)
        // Step 1: Load R3 into B_reg
        readnum = 3'd3;
        loadb = 1;
        #10;
        loadb = 0;

        // Step 2: Set shift amount to LSR by 1
        shift = 2'b10;  // LSR by 1

        // Step 3: Perform shift operation
        asel = 1;       // Ain = 0
        bsel = 0;       // Use shifter output
        ALUop = 2'b00;  // ADD operation (0 + shifted B)
        loadc = 1;
        loads = 1;
        #10;
        loadc = 0;
        loads = 0;

        // Step 4: Write result back to R1
        writenum = 3'd1;
        write = 1;
        vsel = 0;
        #10;
        write = 0;

        // Verify that R1 contains R3 shifted right by 1
        if (R1 !== (R3 >> 1)) begin
            err = 1;
            $display("FAILED: LSR R1, R3, #1 -- R1=%h, expected %h", R1, (R3 >> 1));
        end else begin
            $display("Test Case 8 (LSR R1, R3, #1) passed");
        end


        // Test Case 9: Testing Zero Flag (Z_out)
        // Perform subtraction resulting in zero
        // Step 1: Load same value into A_reg and B_reg
        readnum = 3'd5; // R5 contains 13
        loada = 1;
        loadb = 1;
        #10;
        loada = 0;
        loadb = 0;

        // Step 2: Perform subtraction A_reg - B_reg
        shift = 2'b00;
        asel = 0;
        bsel = 0;
        ALUop = 2'b01;  // SUB operation
        loadc = 1;
        loads = 1;
        #10;
        loadc = 0;
        loads = 0;

        // Verify Z_out is set
        if (Z_out !== 1'b1) begin
            err = 1;
            $display("FAILED: SUB Zero Test -- Z_out=%b, expected %b", Z_out, 1'b1);
        end else begin
            $display("Test Case 9 (SUB resulting in zero) passed");
        end


        // Final Result
        if (err == 0) begin
            $display("All tests passed successfully.");
        end else begin
            $display("Some tests failed. Please check the errors above.");
        end

        $stop; // Stop simulation
    end

endmodule
