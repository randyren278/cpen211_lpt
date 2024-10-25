module tb_top_module;

    // Declare inputs as regs and outputs as wires
    reg clk, reset;
    reg [1:0] in;
    wire [2:0] out; // Corrected to match the top module's output width

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
        input [2:0] expected_out;
        input [2:0] expected_state;
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

        // Check initial state (should be Sa)
        check_output(3'b000, 3'b000);  // Expecting out = 000, state = Sa

        // Test transition to Sb with in = 01
        in = 2'b01;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(3'b001, 3'b001);  // Expecting out = 001, state = Sb

        // Test transition to Sa (Sb always goes to Sa)
        pulse_clock;  // Trigger the clock for the state transition
        check_output(3'b000, 3'b000);  // Expecting out = 000, state = Sa

        // Test transition to Sd with in = 10
        in = 2'b10;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(3'b000, 3'b011);  // Expecting out = 000, state = Sd

        // Test transition to Sc (Sd always goes to Sc)
        pulse_clock;
        check_output(3'b010, 3'b010);  // Expecting out = 010, state = Sc

        // Test transition to Se with in = 01
        in = 2'b01;
        pulse_clock;
        check_output(3'b100, 3'b100);  // Expecting out = 100, state = Se

        // Test transition to Sd with in = 11
        in = 2'b11;
        pulse_clock;
        check_output(3'b000, 3'b011);  // Expecting out = 000, state = Sd

        // Finish simulation
        $display("Test complete.");
        $stop;
    end
endmodule


