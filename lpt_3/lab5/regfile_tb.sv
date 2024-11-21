module regfile_tb;

    //input and output for the testbench
    reg [15:0] data_in;
    reg [2:0] writenum, readnum;
    reg write, clk;
    wire [15:0] data_out;

    //required error signal
    reg err;

    //instantiate the regfile module
    regfile DUT(
        .data_in(data_in),
        .writenum(writenum),
        .write(write),
        .readnum(readnum),
        .clk(clk),
        .data_out(data_out)
    );

    //clock generation 
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //initialize inputs 
    initial begin
        data_in = 16'b0;
        writenum = 3'b0;
        readnum = 3'b0;
        write = 0;
        err = 0;

        //test case 1 write to R0 and verify that it was read
        writenum = 3'b000; //R0 selected
        data_in = 16'habcd; //test data
        write = 1; //write to R0
        #10; //wait for rising edge
        write = 0; //stop writing
        readnum = 3'b000; //R0 selected
        #10; //wait for read
        if (data_out != 16'habcd) begin
            $display("Error: data_out = %h, expected = %h", data_out, 16'habcd);
            err = 1;
        end else begin
            $display("Test case 1 passed");
        end     

        //test case 2 write to R1 and verify that it was read
        writenum = 3'b001; //R1 selected
        data_in = 16'habcd; //test data
        write = 1; //write to R1
        #10; //wait for rising edge
        write = 0; //stop writing
        readnum = 3'b001; //R1 selected
        #10; //wait for read
        if (data_out != 16'habcd) begin
            $display("Error: data_out = %h, expected = %h", data_out, 16'habcd);
            err = 1;
        end else begin
            $display("Test case 2 passed");
        end

        //test case 3 write to R2 and verify that it was read
        writenum = 3'b010; //R2 selected
        data_in = 16'habcd; //test data
        write = 1; //write to R2
        #10; //wait for rising edge
        write = 0; //stop writing
        readnum = 3'b010; //R2 selected
        #10; //wait for read
        if (data_out != 16'habcd) begin
            $display("Error: data_out = %h, expected = %h", data_out, 16'habcd);
            err = 1;
        end else begin
            $display("Test case 3 passed");
        end

        //test case 4 write to R3 and verify that it was read
        writenum = 3'b011; //R3 selected
        data_in = 16'habcd; //test data
        write = 1; //write to R3
        #10; //wait for rising edge
        write = 0; //stop writing
        readnum = 3'b011; //R3 selected
        #10; //wait for read
        if (data_out != 16'habcd) begin
            $display("Error: data_out = %h, expected = %h", data_out, 16'habcd);
            err = 1;
        end else begin
            $display("Test case 4 passed");
        end

        //test case 5 write to R4 and verify that it was read
        writenum = 3'b100; //R4 selected
        data_in = 16'habcd; //test data
        write = 1; //write to R4
        #10; //wait for rising edge
        write = 0; //stop writing
        readnum = 3'b100; //R4 selected
        #10; //wait for read
        if (data_out != 16'habcd) begin
            $display("Error: data_out = %h, expected = %h", data_out, 16'habcd);
            err = 1;
        end else begin
            $display("Test case 5 passed");
        end

        //test case 6 write to R5 and verify that it was read
        writenum = 3'b101; //R5 selected
        data_in = 16'habcd; //test data
        write = 1; //write to R5
        #10; //wait for rising edge
        write = 0; //stop writing
        readnum = 3'b101; //R5 selected
        #10; //wait for read
        if (data_out != 16'habcd) begin
            $display("Error: data_out = %h, expected = %h", data_out, 16'habcd);
            err = 1;
        end else begin
            $display("Test case 6 passed");
        end

        //test case 7 write to R6 and verify that it was read
        writenum = 3'b110; //R6 selected
        data_in = 16'habcd; //test data
        write = 1; //write to R6
        #10; //wait for rising edge
        write = 0; //stop writing
        readnum = 3'b110; //R6 selected
        #10; //wait for read
        if (data_out != 16'habcd) begin
            $display("Error: data_out = %h, expected = %h", data_out, 16'habcd);
            err = 1;
        end else begin
            $display("Test case 7 passed");
        end

        //test case 8 write to R7 and verify that it was read
        writenum = 3'b111; //R7 selected
        data_in = 16'habcd; //test data
        write = 1; //write to R7
        #10; //wait for rising edge
        write = 0; //stop writing
        readnum = 3'b111; //R7 selected
        #10; //wait for read
        if (data_out != 16'habcd) begin
            $display("Error: data_out = %h, expected = %h", data_out, 16'habcd);
            err = 1;
        end else begin
            $display("Test case 8 passed");
        end

        // Display overall test result
        if (err == 0) begin
            $display("All tests PASSED");
        end else begin
            $display("Some tests FAILED");
        end

        $finish; // End the simulation
    end

endmodule
