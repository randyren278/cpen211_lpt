module ALU_tb;
    //input and output for the testbench
    reg [15:0] Ain, Bin; //input data
    reg [1:0] ALUop; //determines the operation to be performed
    wire [15:0] out; //output of the ALU
    wire Z; // becomes 1 if the output is zero

    //required error signal
    reg err;

    //instantiate the ALU module
    ALU DUT(
        .Ain(Ain),
        .Bin(Bin),
        .ALUop(ALUop),
        .out(out),
        .Z(Z)
    );

    //initialize inputs
        initial begin
            err = 0; //intialize error flag

            //test case 1 addition
            Ain = 16'h0001; //test data
            Bin = 16'h0001; //test data
            ALUop = 2'b00; //addition
            #10; //wait for output
            if (out != 16'h0002) begin
                $display("Error: out = %h, expected = %h", out, 16'h0002);
                err = 1;
            end else begin
                $display("Test case 1 passed");
            end

            //test case 2 subtraction
            Ain = 16'h0002; //test data
            Bin = 16'h0001; //test data
            ALUop = 2'b01; //subtraction
            #10; //wait for output
            if (out != 16'h0001) begin
                $display("Error: out = %h, expected = %h", out, 16'h0001);
                err = 1;
            end else begin
                $display("Test case 2 passed");
            end

            //test case 3 bitwise AND
            Ain = 16'h0003; //test data
            Bin = 16'h0002; //test data
            ALUop = 2'b10; //bitwise AND
            #10; //wait for output
            if (out != 16'h0002) begin
                $display("Error: out = %h, expected = %h", out, 16'h0002);
                err = 1;
            end else begin
                $display("Test case 3 passed");
            end

            //test case 4 bitwise not  
            Bin = 16'h0002; //test data
            ALUop = 2'b11; //bitwise not
            #10; //wait for output
            if (out != 16'hFFFD) begin
                $display("Error: out = %h, expected = %h", out, 16'hFFFD);
                err = 1;
            end else begin
                $display("Test case 4 passed");
            end
            // remember this alu only uses Bin for not 
            // in this test case we tested Bin as 0000 0000 0000 0010 and teh result comes back as 1111 1111 1111 1101 which is hFFFD in hex

            //testcase 5 Z flag
            Ain = 16'h0000; //test data
            Bin = 16'h0000; //test data
            ALUop = 2'b00; //addition
            #10; //wait for output
            if (Z != 1) begin
                $display("Error: Z = %b, expected = %b", Z, 1);
                err = 1;
            end else begin
                $display("Test case 5 passed");
            end

            //summary
            if (err == 1) begin
                $display("Test failed");
            end else begin
                $display("All tests passed");
            end

            $finish; //end simulation

        end
endmodule