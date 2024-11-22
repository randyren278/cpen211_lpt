// tb.v
`timescale 1ns / 1ps

// Define opcode macros
`define MOV_R0 4'b0000
`define MOV_R1 4'b0001
`define MOV_R2 4'b0010
`define MOV_R3 4'b0011

`define XOR    4'b0100
`define ASL    4'b1000

`define SWP_R1 4'b1101
`define SWP_R2 4'b1110
`define SWP_R3 4'b1111

module ihateeverything;
    reg clk, reset, s;
    reg [3:0] op;
    reg [7:0] in;
    wire [7:0] out;  
    wire done;
    
    // Instantiate the DUT (Device Under Test)
    bitwise DUT(clk, reset, s, op, in, out, done);

    // Clock Generation: 10ns period
    initial forever begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Test Sequence
    initial begin
        // Initialize Inputs
        s = 1'b0; 
        reset = 1'b1; 
        op = 4'b0000;
        in = 8'b00000000;
        #10;
        reset = 1'b0; 
        #20;

        // ------------------------
        // Test Case 1: MOV R1, 42
        // ------------------------
        $display("Test Case 1: MOV R1, 42");
        {s, op, in} = {1'b1, `MOV_R1, 8'd42}; #10; 
        s = 1'b0;
        @(posedge done);
        @(negedge clk);
        #10;
        if (DUT.DP.R1 !== 8'd42) begin
            $display("ERROR: After MOV R1, expected R1=42, got R1=%d", DUT.DP.R1);
            $stop;
        end else begin
            $display("PASS: MOV R1, R1=%d", DUT.DP.R1);
        end

        // ------------------------
        // Test Case 2: MOV R2, 11
        // ------------------------
        $display("Test Case 2: MOV R2, 11");
        {s, op, in} = {1'b1, `MOV_R2, 8'd11}; #10; 
        s = 1'b0;
        @(posedge done);
        @(negedge clk);
        #10;
        if (DUT.DP.R2 !== 8'd11) begin
            $display("ERROR: After MOV R2, expected R2=11, got R2=%d", DUT.DP.R2);
            $stop;
        end else begin
            $display("PASS: MOV R2, R2=%d", DUT.DP.R2);
        end

        // ------------------------
        // Test Case 3: XOR (R1 ^ R2 -> R0)
        // ------------------------
        $display("Test Case 3: XOR R1 ^ R2 -> R0");
        {s, op, in} = {1'b1, `XOR, 8'd0}; #10; 
        s = 1'b0;
        @(posedge done);
        @(negedge clk);
        #10;
        if (DUT.DP.R0 !== (DUT.DP.R1 ^ DUT.DP.R2)) begin
            $display("ERROR: After XOR, expected R0=%d, got R0=%d", (DUT.DP.R1 ^ DUT.DP.R2), DUT.DP.R0);
            $stop;
        end else begin
            $display("PASS: XOR, R0=%d", DUT.DP.R0);
        end

        // ------------------------
        // Test Case 4: ASL (Shift R1 left by 1 -> R0)
        // ------------------------
        $display("Test Case 4: ASL R1 << 1 -> R0");
        {s, op, in} = {1'b1, `ASL, 8'd0}; #10; 
        s = 1'b0;
        @(posedge done);
        @(negedge clk);
        #10;
        if (DUT.DP.R0 !== (DUT.DP.R1 << 1)) begin
            $display("ERROR: After ASL, expected R0=%d, got R0=%d", (DUT.DP.R1 << 1), DUT.DP.R0);
            $stop;
        end else begin
            $display("PASS: ASL, R0=%d", DUT.DP.R0);
        end

        // ------------------------
        // Test Case 5: SWP R2 (Swap R0 and R2)
        // ------------------------
        $display("Test Case 5: SWP R2 (Swap R0 and R2)");
        {s, op, in} = {1'b1, `SWP_R2, 8'd0}; #10; 
        s = 1'b0;
        @(posedge done);
        @(negedge clk);
        #10;
        if ((DUT.DP.R0 !== 8'd11) || (DUT.DP.R2 !== 8'd64)) begin // R0 was ASL'ed to 64
            $display("ERROR: After SWP R2, expected R0=11 and R2=64, got R0=%d and R2=%d", DUT.DP.R0, DUT.DP.R2);
            $stop;
        end else begin
            $display("PASS: SWP R2, R0=%d, R2=%d", DUT.DP.R0, DUT.DP.R2);
        end

        // ------------------------
        // Additional Test Cases
        // ------------------------

        // ------------------------
        // Test Case 6: SWP R1 (Swap R0 and R1)
        // ------------------------
        $display("Test Case 6: SWP R1 (Swap R0 and R1)");
        {s, op, in} = {1'b1, `SWP_R1, 8'd0}; #10; 
        s = 1'b0;
        @(posedge done);
        @(negedge clk);
        #10;
        if ((DUT.DP.R0 !== 8'd42) || (DUT.DP.R1 !== 8'd11)) begin
            $display("ERROR: After SWP R1, expected R0=42 and R1=11, got R0=%d and R1=%d", DUT.DP.R0, DUT.DP.R1);
            $stop;
        end else begin
            $display("PASS: SWP R1, R0=%d, R1=%d", DUT.DP.R0, DUT.DP.R1);
        end

        // ------------------------
        // Test Case 7: SWP R3 (Swap R0 and R3)
        // ------------------------
        // First, initialize R3 with a known value
        $display("Test Case 7: Initialize R3 with 85");
        {s, op, in} = {1'b1, `MOV_R3, 8'd85}; #10; 
        s = 1'b0;
        @(posedge done);
        @(negedge clk);
        #10;
        if (DUT.DP.R3 !== 8'd85) begin
            $display("ERROR: After MOV R3, expected R3=85, got R3=%d", DUT.DP.R3);
            $stop;
        end else begin
            $display("PASS: MOV R3, R3=%d", DUT.DP.R3);
        end

        $display("Test Case 8: SWP R3 (Swap R0 and R3)");
        {s, op, in} = {1'b1, `SWP_R3, 8'd0}; #10; 
        s = 1'b0;
        @(posedge done);
        @(negedge clk);
        #10;
        if ((DUT.DP.R0 !== 8'd85) || (DUT.DP.R3 !== 8'd42)) begin
            $display("ERROR: After SWP R3, expected R0=85 and R3=42, got R0=%d and R3=%d", DUT.DP.R0, DUT.DP.R3);
            $stop;
        end else begin
            $display("PASS: SWP R3, R0=%d, R3=%d", DUT.DP.R0, DUT.DP.R3);
        end

        // ------------------------
        // Final Check: Verify R0 is 85
        // ------------------------
        if( DUT.DP.R0 === 8'd85 ) begin
            $display("FINAL PASS: R0 is %d (expected 85).", DUT.DP.R0);
        end else begin
            $display("ERROR ** R0 is %d instead of 85", DUT.DP.R0);
            #5; $stop;
        end

        $stop;
    end
endmodule
