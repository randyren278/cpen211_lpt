`timescale 1ns / 1ps

module cpu_tb;

    // Testbench Signals
    reg clk;
    reg reset;
    reg s;
    reg load;
    reg [15:0] in;
    wire [15:0] out;
    wire N, V, Z, w;

    // Error Flag
    reg err;

    // Instantiate the CPU
    cpu DUT (
        .clk(clk),
        .reset(reset),
        .s(s),
        .load(load),
        .in(in),
        .out(out),
        .N(N),
        .V(V),
        .Z(Z),
        .w(w)
    );

    // Clock Generation: 10 time units period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Initial Block for Test Sequence
    initial begin
        // Initialize Signals
        err = 0;
        reset = 1;
        s = 0;
        load = 0;
        in = 16'b0;
        #10;

        // Release Reset
        reset = 0;
        #10;

        /////////////////////////////////////////////////////////////////////
        // Test Case 1: MOV R0, #7
        /////////////////////////////////////////////////////////////////////
        // Instruction Encoding: 1101000000000111
        in = 16'b1101000000000111;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w); // Wait for instruction to complete
        #10;
        if (DUT.DP.REGFILE.R0 !== 16'h0007) begin
            err = 1;
            $display("FAILED: MOV R0, #7. Expected R0=0007, Got R0=%h", DUT.DP.REGFILE.R0);
            // $stop removed
        end else begin
            $display("PASSED: MOV R0, #7");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 2: MOV R1, #2
        /////////////////////////////////////////////////////////////////////
        // Instruction Encoding:1101000100000010
        in = 16'b1101000100000010;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R1 !== 16'h0002) begin
            err = 1;
            $display("FAILED: MOV R1, #2. Expected R1=0002, Got R1=%h", DUT.DP.REGFILE.R1);
            // $stop removed
        end else begin
            $display("PASSED: MOV R1, #2");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 3: ADD R2, R1, R0, LSL#1
        /////////////////////////////////////////////////////////////////////
        // Instruction Encoding:1010000101001000
        in = 16'b1010000101001000;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R2 !== 16'h0010) begin
            err = 1;
            $display("FAILED: ADD R2, R1, R0, LSL#1. Expected R2=0010, Got R2=%h", DUT.DP.REGFILE.R2);
            // $stop removed
        end else begin
            $display("PASSED: ADD R2, R1, R0, LSL#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 4: CMP R1, R0, LSL#1
        /////////////////////////////////////////////////////////////////////
        // Instruction Encoding:1010100101001000
        in = 16'b1010100101001000;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (Z !== 1'b0 || V !== 1'b0 || N !== 1'b1) begin
            err = 1;
            $display("FAILED: CMP R1, R0, LSL#1. Expected Z=0, V=0, N=1. Got Z=%b, V=%b, N=%b", Z, V, N);
            // $stop removed
        end else begin
            $display("PASSED: CMP R1, R0, LSL#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 5: AND R3, R2, R1, LSR#1
        /////////////////////////////////////////////////////////////////////
        // Corrected Instruction Encoding:1011001011100001
        in = 16'b1011001011100001;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R3 !== 16'h0000) begin
            err = 1;
            $display("FAILED: AND R3, R2, R1, LSR#1. Expected R3=0000, Got R3=%h", DUT.DP.REGFILE.R3);
            // $stop removed
        end else begin
            $display("PASSED: AND R3, R2, R1, LSR#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 6: MVN R4, R3, ASR#1
        /////////////////////////////////////////////////////////////////////
        // Corrected Instruction Encoding:1011100110100011
        in = 16'b1011100110100011;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R4 !== 16'hFFFE) begin
            err = 1;
            $display("FAILED: MVN R4, R3, ASR#1. Expected R4=FFFE, Got R4=%h", DUT.DP.REGFILE.R4);
            // $stop removed
        end else begin
            $display("PASSED: MVN R4, R3, ASR#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 7: MOV R5, R4, LSL#1
        /////////////////////////////////////////////////////////////////////
        // Corrected Instruction Encoding:1100001010010100
        in = 16'b1100001010010100;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R5 !== 16'h0004) begin
            err = 1;
            $display("FAILED: MOV R5, R4, LSL#1. Expected R5=0004, Got R5=%h", DUT.DP.REGFILE.R5);
            // $stop removed
        end else begin
            $display("PASSED: MOV R5, R4, LSL#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 8: MOV R6, #-15
        /////////////////////////////////////////////////////////////////////
        // Corrected Instruction Encoding:1101001111110001
        in = 16'b1101001111110001; // im8 = 11110001 (-15)
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R6 !== 16'hFFF1) begin
            err = 1;
            $display("FAILED: MOV R6, #-15. Expected R6=FFF1, Got R6=%h", DUT.DP.REGFILE.R6);
            // $stop removed
        end else begin
            $display("PASSED: MOV R6, #-15");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 9: ADD R7, R6, R1, ASR#1
        /////////////////////////////////////////////////////////////////////
        // Corrected Instruction Encoding:1010001111100010
        in = 16'b1010001111100010;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R7 !== 16'hFFF2) begin
            err = 1;
            $display("FAILED: ADD R7, R6, R1, ASR#1. Expected R7=FFF2, Got R7=%h", DUT.DP.REGFILE.R7);
            // $stop removed
        end else begin
            $display("PASSED: ADD R7, R6, R1, ASR#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 10: CMP R7, R2, LSL#1
        /////////////////////////////////////////////////////////////////////
        // Corrected Instruction Encoding:1010111101001010
        in = 16'b1010111101001010; // Correct encoding for CMP R7, R2, LSL#1
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (Z !== 1'b0 || V !== 1'b0 || N !== 1'b1) begin
            err = 1;
            $display("FAILED: CMP R7, R2, LSL#1. Expected Z=0, V=0, N=1. Got Z=%b, V=%b, N=%b", Z, V, N);
            // $stop removed
        end else begin
            $display("PASSED: CMP R7, R2, LSL#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 11: AND R0, R0, R1, ASR#1
        /////////////////////////////////////////////////////////////////////
        // Corrected Instruction Encoding:1011000000100001
        in = 16'b1011000000100001;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R0 !== 16'h0001) begin
            err = 1;
            $display("FAILED: AND R0, R0, R1, ASR#1. Expected R0=0001, Got R0=%h", DUT.DP.REGFILE.R0);
            // $stop removed
        end else begin
            $display("PASSED: AND R0, R0, R1, ASR#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 12: ADD R1, R1, R1, LSL#1
        /////////////////////////////////////////////////////////////////////
        // Instruction Encoding:1010000101001001
        in = 16'b1010000101001001;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R1 !== 16'h0006) begin
            err = 1;
            $display("FAILED: ADD R1, R1, R1, LSL#1. Expected R1=0006, Got R1=%h", DUT.DP.REGFILE.R1);
            // $stop removed
        end else begin
            $display("PASSED: ADD R1, R1, R1, LSL#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 13: ADD R7, R7, R7, LSL#1
        /////////////////////////////////////////////////////////////////////
        // Corrected Instruction Encoding:1010001111101111
        in = 16'b1010001111101111;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R7 !== 16'hFFF6) begin
            err = 1;
            $display("FAILED: ADD R7, R7, R7, LSL#1. Expected R7=FFF6, Got R7=%h", DUT.DP.REGFILE.R7);
            // $stop removed
        end else begin
            $display("PASSED: ADD R7, R7, R7, LSL#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 14: MOV R2, R0, LSR#1
        /////////////////////////////////////////////////////////////////////
        // Corrected Instruction Encoding:1100001000100000
        in = 16'b1100001000100000;
        load = 1;
        #10;
        load = 0;
        s = 1;
        #10;
        s = 0;
        @(posedge w);
        #10;
        if (DUT.DP.REGFILE.R2 !== 16'h0003) begin
            err = 1;
            $display("FAILED: MOV R2, R0, LSR#1. Expected R2=0003, Got R2=%h", DUT.DP.REGFILE.R2);
            // $stop removed
        end else begin
            $display("PASSED: MOV R2, R0, LSR#1");
        end

        /////////////////////////////////////////////////////////////////////
        // Test Case 15: Final Check and Completion
        /////////////////////////////////////////////////////////////////////
        if (~err) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("TESTS FAILED");
        end
        $stop; // This $stop remains to end the simulation after all tests.
    end

endmodule
