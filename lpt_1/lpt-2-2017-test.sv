module tb_top_module;

    // Declare inputs as regs and outputs as wires
    reg clk, reset;
    reg [1:0] in;
    wire [1:0] out;

    // Instantiate the top module
    top_module uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    // Task to generate a clock pulse
    task pulse_clock;
        begin
            clk = 1;
            #5;  // Clock high for 5 time units
            clk = 0;
            #5;  // Clock low for 5 time units
        end
    endtask

    // Task to check the state and output
    task check_output;
        input [1:0] expected_out;
        input [1:0] expected_state;
        begin
            if (out == expected_out && uut.current_state == expected_state) begin
                $display("PASS: Time = %0t | Current State = %b | Output = %b", $time, uut.current_state, out);
            end else begin
                $display("FAIL: Time = %0t | Expected State = %b | Got State = %b | Expected Output = %b | Got Output = %b", 
                         $time, expected_state, uut.current_state, expected_out, out);
            end
        end
    endtask

    // Initial stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        in = 2'b00;

        // Apply reset
        $display("Applying Reset...");
        reset = 1;
        pulse_clock;  // Generate clock pulse during reset
        reset = 0;
        $display("Reset Deactivated. Starting test...");

        // Check initial state (should be STATE_A)
        check_output(2'b01, 2'b01);  // Expecting out = 01, state = STATE_A

        // Test transition to STATE_C with in = 00
        in = 2'b00;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b10, 2'b10);  // Expecting out = 10, state = STATE_C

        // Test transition to STATE_D with in = 10
        in = 2'b10;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b11, 2'b11);  // Expecting out = 11, state = STATE_D

        // Test transition back to STATE_C (STATE_D always goes to STATE_C)
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b10, 2'b10);  // Expecting out = 10, state = STATE_C

        // Test transition to STATE_E with in = 11
        in = 2'b11;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b00, 2'b00);  // Expecting out = 00, state = STATE_E

        // Test transition to STATE_B with in = 01
        in = 2'b01;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b11, 2'b11);  // Expecting out = 11, state = STATE_B

        // Test transition to STATE_E with in = 01 (from STATE_B)
        in = 2'b01;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b00, 2'b00);  // Expecting out = 00, state = STATE_E

        // Test transition to STATE_D with in = 00 (from STATE_E)
        in = 2'b00;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b11, 2'b11);  // Expecting out = 11, state = STATE_D

        // Finish simulation
        $display("Test complete.");
        $stop;
    end
endmodule
