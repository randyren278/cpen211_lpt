// Testbench module for top_module
module tb_top_module;
    
    // ----------------------------
    // 1. Declare Inputs and Outputs
    // ----------------------------
    
    // Inputs to the top_module are declared as reg types in the testbench
    reg clk;          // Clock signal
    reg reset;        // Reset signal
    reg [1:0] in;     // 2-bit input signal (must match the width in top_module)
    
    // Outputs from the top_module are declared as wire types in the testbench
    wire [2:0] out;    // 3-bit output signal (must match the width in top_module)
    
    // If the original module changes (e.g., different input/output widths),
    // update the reg and wire declarations accordingly.
    // Example:
    // - If 'in' becomes 3 bits: reg [2:0] in;
    // - If 'out' becomes 4 bits: wire [3:0] out;

    // --------------------------------
    // 2. Instantiate the Top Module
    // --------------------------------
    
    // Instantiate the Unit Under Test (UUT)
    top_module uut (
        .clk(clk),     // Connect testbench clk to top_module clk
        .reset(reset), // Connect testbench reset to top_module reset
        .in(in),       // Connect testbench in to top_module in
        .out(out)      // Connect top_module out to testbench out
    );
    
    // If the module name or port names change in top_module,
    // update the instantiation accordingly.
    // Example:
    // If top_module is renamed to 'fsm', instantiate as:
    // fsm uut (
    //     .clk(clk),
    //     .reset(reset),
    //     .in(in),
    //     .out(out)
    // );

    // -------------------------------------
    // 3. Clock Generation Task
    // -------------------------------------
    
    // Task to generate a single clock pulse
    task pulse_clock;
        begin
            clk = 1;    // Set clock high
            #5;         // Wait for 5 time units
            clk = 0;    // Set clock low
            #5;         // Wait for 5 time units
        end
    endtask
    
    // If the clock period needs to change (e.g., different frequency),
    // adjust the delay values (#5) accordingly.
    // Example:
    // For a 20-unit period: #10 for high and #10 for low

    // -------------------------------------
    // 4. Output Checking Task
    // -------------------------------------
    
    // Task to verify the output and state against expected values
    task check_output;
        input [2:0] expected_out;    // Expected 3-bit output 
        input [2:0] expected_state;  // Expected 3-bit state (both based on the output state sizes at the bottom)
        
        begin
            // Compare the actual output and state with expected values
            if (out === expected_out && uut.current_state === expected_state) begin
                $display("PASS: Time = %0t | Current State = %b | Output = %b", 
                         $time, uut.current_state, out);
            end else begin
                $display("FAIL: Time = %0t | Expected State = %b | Got State = %b | " 
                         + "Expected Output = %b | Got Output = %b",
                         $time, expected_state, uut.current_state, expected_out, out);
            end
        end
    endtask
    
    // Notes:
    // - The '===' operator is used for exact comparison, including X and Z states.
    // - If the state signal name in top_module changes (e.g., 'current_state' to 'state'),
    //   update 'uut.current_state' accordingly in the condition and display statements.
    // - If the number of state bits changes, adjust the width of 'expected_state'.

    // -------------------------------------
    // 5. Initial Stimulus and Test Sequence
    // -------------------------------------
    
    initial begin
        // ----------------------------
        // a. Initialize Inputs
        // ----------------------------
        clk = 0;         // Initialize clock to 0
        reset = 0;       // Initialize reset to inactive
        in = 2'b00;      // Initialize input to 00
        
        // ----------------------------
        // b. Apply Reset
        // ----------------------------
        $display("Applying Reset...");
        reset = 1;       // Activate reset
        pulse_clock;     // Generate a clock pulse while reset is active
        reset = 0;       // Deactivate reset
        $display("Reset Deactivated. Starting test...");
        
        // ----------------------------
        // c. Check Initial State
        // ----------------------------
        // After reset, the state should be Sa (3'd0) with output 3'b101
        check_output(3'b101, 3'd0);  // out = 101, state = Sa (0)
        
        // ----------------------------
        // d. Test Transition: Sa -> Sb with in = 11
        // ----------------------------
        in = 2'b11;       // Set input to 11 to trigger transition from Sa to Sb
        pulse_clock;      // Trigger clock to perform state transition
        check_output(3'b010, 3'd1);  // out = 010, state = Sb (1)
        
        // ----------------------------
        // e. Test Transition: Sb -> Sc with in = 01
        // ----------------------------
        in = 2'b01;       // Set input to 01 to trigger transition from Sb to Sc
        pulse_clock;      // Trigger clock to perform state transition
        check_output(3'b001, 3'd2);  // out = 001, state = Sc (2)
        
        // ----------------------------
        // f. Test Staying in Sc with irrelevant input
        // ----------------------------
        in = 2'b00;       // Set input to 00 (irrelevant in Sc)
        pulse_clock;      // Trigger clock; state should remain Sc
        check_output(3'b001, 3'd2);  // out = 001, state = Sc (2)
        
        // ----------------------------
        // g. Apply Reset Again
        // ----------------------------
        $display("Applying Reset...");
        reset = 1;        // Activate reset
        pulse_clock;      // Generate a clock pulse during reset
        reset = 0;        // Deactivate reset
        check_output(3'b101, 3'd0);  // out = 101, state = Sa (0)
        
        // ----------------------------
        // h. Test Transition: Sa -> Sb with in = 11
        // ----------------------------
        in = 2'b11;       // Set input to 11 to trigger transition from Sa to Sb
        pulse_clock;      // Trigger clock to perform state transition
        check_output(3'b010, 3'd1);  // out = 010, state = Sb (1)
        
        // ----------------------------
        // i. Test Transition: Sb -> Sd with in = 11
        // ----------------------------
        in = 2'b11;       // Set input to 11 to trigger transition from Sb to Sd
        pulse_clock;      // Trigger clock to perform state transition
        check_output(3'b101, 3'd3);  // out = 101, state = Sd (3)
        
        // ----------------------------
        // j. Test Transition: Sd -> Sc (always transitions to Sc)
        // ----------------------------
        in = 2'b00;       // Input is irrelevant; Sd always transitions to Sc
        pulse_clock;      // Trigger clock to perform state transition
        check_output(3'b001, 3'd2);  // out = 001, state = Sc (2)
        
        // ----------------------------
        // k. Apply Another Reset
        // ----------------------------
        $display("Applying Reset...");
        reset = 1;        // Activate reset
        pulse_clock;      // Generate a clock pulse during reset
        reset = 0;        // Deactivate reset
        check_output(3'b101, 3'd0);  // out = 101, state = Sa (0)
        
        // ----------------------------
        // l. Test Transition: Sa -> Sb with in = 11
        // ----------------------------
        in = 2'b11;       // Set input to 11 to trigger transition from Sa to Sb
        pulse_clock;      // Trigger clock to perform state transition
        check_output(3'b010, 3'd1);  // out = 010, state = Sb (1)
        
        // ----------------------------
        // m. Test Transition: Sb -> Se with in = 00
        // ----------------------------
        in = 2'b00;       // Set input to 00 to trigger transition from Sb to Se
        pulse_clock;      // Trigger clock to perform state transition
        check_output(3'b011, 3'd4);  // out = 011, state = Se (4)
        
        // ----------------------------
        // n. Test Transition: Se -> Sd with in = 11
        // ----------------------------
        in = 2'b11;       // Set input to 11 to trigger transition from Se to Sd
        pulse_clock;      // Trigger clock to perform state transition
        check_output(3'b101, 3'd3);  // out = 101, state = Sd (3)
        
        // ----------------------------
        // o. Finish Simulation
        // ----------------------------
        $display("All tests completed.");
        $stop;            // Stop the simulation
    end
    
    // -------------------------------------
    // 6. End of Testbench
    // -------------------------------------
    
endmodule
