// Testbench (ignored by autograder)
module testbench;
    reg [5:0] ain, bin;
    wire [5:0] f;

    detect_cover uut (
        .ain(ain),
        .bin(bin),
        .f(f)
    );

    initial begin
        // Test case 1
        ain = 6'b000011; bin = 6'b000110;
        #10;
        $display("ain=%b, bin=%b, f=%b", ain, bin, f);

        // Test case 2
        ain = 6'b000011; bin = 6'b000011;
        #10;
        $display("ain=%b, bin=%b, f=%b", ain, bin, f);

        // Test case 3
        ain = 6'b100000; bin = 6'b100101;
        #10;
        $display("ain=%b, bin=%b, f=%b", ain, bin, f);

        // Test case 4
        ain = 6'b101011; bin = 6'b110111;
        #10;
        $display("ain=%b, bin=%b, f=%b", ain, bin, f);

        // Test case 5
        ain = 6'b101011; bin = 6'b111111;
        #10;
        $display("ain=%b, bin=%b, f=%b", ain, bin, f);

        $finish;
    end
endmodule