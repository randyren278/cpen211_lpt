module shifter_tb;
    //input and output
    reg [15:0] in;
    reg [1:0] shift;
    wire [15:0] sout;

    //required error signal
    reg err;

    //instantiate the shifter module
    shifter DUT(
        .in(in),
        .shift(shift),
        .sout(sout)
    );

    //initialize inputs
    initial begin
        err = 0; //initialize error flag

        //test case 1 no shift
        in = 16'b0000000000000001; //test data
        shift = 2'b00; //no shift
        #10; //wait for output
        if (sout != 16'b0000000000000001) begin
            $display("Error: sout = %b, expected = %b", sout, 16'b0000000000000001);
            err = 1;
        end else begin
            $display("Test case 1 passed");
        end

        //test case 2 lsl
        in = 16'b0000000000000001; //test data
        shift = 2'b01; //lsl
        #10; //wait for output
        if (sout != 16'b0000000000000010) begin
            $display("Error: sout = %b, expected = %b", sout, 16'b0000000000000010);
            err = 1;
        end else begin
            $display("Test case 2 passed");
        end

        //test case 3 lsr
        in = 16'b0000000000000010; //test data
        shift = 2'b10; //lsr
        #10; //wait for output
        if (sout != 16'b0000000000000001) begin
            $display("Error: sout = %b, expected = %b", sout, 16'b0000000000000001);
            err = 1;
        end else begin
            $display("Test case 3 passed");
        end

        //test case 4 asr
        in = 16'b1000000000000000; //test data
        shift = 2'b11; //asr
        #10; //wait for output
        if (sout != 16'b1100000000000000) begin
            $display("Error: sout = %b, expected = %b", sout, 16'b1100000000000000);
            err = 1;
        end else begin
            $display("Test case 4 passed");
        end

        //display final result
        if (err == 1) begin
            $display("Test failed");
        end else begin
            $display("All tests passed");
        end

    end

endmodule
