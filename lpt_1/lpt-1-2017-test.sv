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
