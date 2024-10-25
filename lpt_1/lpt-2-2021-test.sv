module tb_MealyDec;

    // Declare inputs as regs and outputs as wires
    reg [1:0] state;   // 2-bit state signal, adjust if the number of states is different
    reg in;            // 1-bit input signal, modify if the input width changes
    wire [2:0] out;    // 3-bit output signal, adjust output width if necessary

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
                display("PASS: Time = %0t | State = %b | Input = %b | Output = %b", time, state, in, out);
            end else begin
                display("FAIL: Time = %0t | State = %b | Input = %b | Expected Output = %b | Got Output = %b",
                         time, state, in, expected_out, out);
            end
        end
    endtask

    // Initial stimulus
    initial begin
        // Initialize signals
        state = 2'b00;  // Start in State A
        in = 1'b0;      // Initial input value

        // Apply test case for State A, in = 0 (Expecting out = 3'b111)
        #10;
        check_output(3'b111);

        state = 2'b00;  // Reset state to A
        in = 1'b1;      // Change input to 1
        check_output(3'b101);  // Expecting out = 3'b101

        state = 2'b01;  // Change state to B
        in = 1'b0;      // Change input to 0
        check_output(3'b001);  // Expecting out = 3'b001

        state = 2'b01;  // Reset state to B
        in = 1'b1;      // Change input to 1
        check_output(3'b011);  // Expecting out = 3'b011

        state = 2'b10;  // Change state to C
        in = 1'b0;      // Change input to 0
        check_output(3'b000);  // Expecting out = 3'b000

        state = 2'b10;  // Reset state to C
        in = 1'b1;      // Change input to 1
        check_output(3'b100);  // Expecting out = 3'b100

        state = 2'b11;  // Change state to D
        in = 1'b0;      // Change input to 0
        check_output(3'b110);  // Expecting out = 3'b110

        state = 2'b11;  // Reset state to D
        in = 1'b1;      // Change input to 1
        check_output(3'b110);  // Expecting out = 3'b110

        


        // Finish simulation
        display("Test complete.");
        stop;
    end
endmodule