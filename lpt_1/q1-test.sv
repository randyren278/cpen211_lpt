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
        input [2:0] expected_state;  // Changed to 3 bits to match current_state
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

        // Check initial state (should be STATE_C)
        check_output(2'b11, 3'd3);  // Expecting out = 11, state = STATE_C (Sc)

        // Test transition to STATE_B with in = 11
        in = 2'b11;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b01, 3'd2);  // Expecting out = 01, state = STATE_B (Sb)

        // Test transition to STATE_A with in = 01
        in = 2'b01;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b00, 3'd1);  // Expecting out = 00, state = STATE_A (Sa)

        // Test transition back to STATE_B with in = 10
        in = 2'b10;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b01, 3'd2);  // Expecting out = 01, state = STATE_B (Sb)

        // Test transition to STATE_C from STATE_B with in = 00
        in = 2'b00;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b11, 3'd3);  // Expecting out = 11, state = STATE_C (Sc)

        // Good up to here

        // Test transition to STATE_E from STATE_C with in = 01
        in = 2'b01;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b01, 3'd5);  // Expecting out = 01, state = STATE_E (Se)

        // Check if STATE_E transitions to STATE_D automatically
        pulse_clock;
        check_output(2'b10, 3'd4);  // Expecting out = 10, state = STATE_D (Sd)

        // Test transition from STATE_D to STATE_E with input = 10
        in = 2'b10;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(2'b01, 3'd5);  // Expecting out = 01, state = STATE_E (Se)

        // Check if STATE_E transitions to STATE_D automatically again
        pulse_clock;
        check_output(2'b10, 3'd4);  // Expecting out = 10, state = STATE_D (Sd)

        // Now check final transition from STATE_D to STATE_C with in = 01
        in = 2'b01;
        pulse_clock;
        check_output(2'b11, 3'd3);  // Expecting out = 11, state = STATE_C (Sc)

        // Finish simulation
        $display("Test complete.");
        $stop;
    end
endmodule
