module tb_MealyDec;

    // Declare inputs as regs and outputs as wires
    reg [1:0] state;   // 2-bit state signal
    reg in;            // 1-bit input signal
    wire [2:0] out;    // 3-bit output signal

    // Instantiate the Mealy Decoder module
    MealyDec uut (
        .state(state),
        .in(in),
        .out(out)
    );

    // Task to check the state, input, and output
    task check_output;
        input [2:0] expected_out;  // Expected 3-bit output
        begin
            if (out == expected_out) begin
                $display("PASS: Time = %0t | State = %b | Input = %b | Output = %b", $time, state, in, out);
            end else begin
                $display("FAIL: Time = %0t | State = %b | Input = %b | Expected Output = %b | Got Output = %b",
                         $time, state, in, expected_out, out);
            end
        end
    endtask

    // Initial stimulus
    initial begin
        // Test Case: State A, in = 0 (Expecting out = 3'b111)
        state = 2'b00; in = 1'b0;
        #1;  // Small delay for simulation purposes
        check_output(3'b111);

        // Test Case: State A, in = 1 (Expecting out = 3'b101)
        state = 2'b00; in = 1'b1;
        #1;
        check_output(3'b101);

        // Test Case: State B, in = 0 (Expecting out = 3'b001)
        state = 2'b01; in = 1'b0;
        #1;
        check_output(3'b001);

        // Test Case: State B, in = 1 (Expecting out = 3'b011)
        state = 2'b01; in = 1'b1;
        #1;
        check_output(3'b011);

        // Test Case: State C, in = 0 (Expecting out = 3'b000)
        state = 2'b10; in = 1'b0;
        #1;
        check_output(3'b000);

        // Test Case: State C, in = 1 (Expecting out = 3'b100)
        state = 2'b10; in = 1'b1;
        #1;
        check_output(3'b100);

        // Test Case: State D, in = 0 (Expecting out = 3'b110)
        state = 2'b11; in = 1'b0;
        #1;
        check_output(3'b110);

        // Test Case: State D, in = 1 (Expecting out = 3'b110)
        state = 2'b11; in = 1'b1;
        #1;
        check_output(3'b110);

        // Finish simulation
        $display("Test complete.");
        $stop;
    end
endmodule
