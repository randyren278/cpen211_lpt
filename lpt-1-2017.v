// File: q1.v

module detect_full (
    input [11:0] ain,  // 12-bit input representing the 4x3 grid
    output reg [2:0] f // 3-bit one-hot output for the fully occupied row
);
    
    always @(*) begin
        // Default output, no rows are fully occupied
        f = 3'b000;
        
        // Check top row (bits 0, 1, 2, 3)
        if (ain[3:0] == 4'b1111)
            f = 3'b001; // Top row fully occupied

        // Check middle row (bits 4, 5, 6, 7) only if top row is not fully occupied
        else if (ain[7:4] == 4'b1111)
            f = 3'b010; // Middle row fully occupied

        // Check bottom row (bits 8, 9, 10, 11) only if top and middle rows are not fully occupied
        else if (ain[11:8] == 4'b1111)
            f = 3'b100; // Bottom row fully occupied
    end

endmodule

// Testbench for detect_full
module tb_detect_full;
    reg [11:0] ain;
    wire [2:0] f;

    detect_full uut (
        .ain(ain),
        .f(f)
    );

    initial begin
        // Test case 1
        ain = 12'b000000001111;
        #10;
        $display("ain = %b, f = %b", ain, f);

        // Test case 2
        ain = 12'b111111110000;
        #10;
        $display("ain = %b, f = %b", ain, f);

        // Test case 3
        ain = 12'b111100000111;
        #10;
        $display("ain = %b, f = %b", ain, f);

        // Test case 4
        ain = 12'b110111111111;
        #10;
        $display("ain = %b, f = %b", ain, f);

        // Test case 5
        ain = 12'b111010110010;
        #10;
        $display("ain = %b, f = %b", ain, f);

        $finish;
    end
endmodule
