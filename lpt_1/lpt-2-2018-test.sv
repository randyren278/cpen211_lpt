module tb_top_module;
    
    // Declare inputs as regs and outputs as wires
    reg clk, reset;
    reg [1:0] in;
    wire [2:0] out; // Matches the top module's output width
    
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
            if (out === expected_out && uut.current_state === expected_state) begin
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
        check_output(3'b101, 3'd0);  // out = 101, state = Sa (0)
        
        // Test transition to Sb with in = 11
        in = 2'b11;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(3'b010, 3'd1);  // out = 010, state = Sb (1)
        
        // Test transition to Sc with in = 01
        in = 2'b01;
        pulse_clock;  // Trigger the clock for the state transition
        check_output(3'b001, 3'd2);  // out = 001, state = Sc (2)
        
        // Test staying in Sc (no transition)
        in = 2'b00;  // Input irrelevant in Sc
        pulse_clock;
        check_output(3'b001, 3'd2);  // out = 001, state = Sc (2)
        
        // Reset to Sa
        $display("Applying Reset...");
        reset = 1;
        pulse_clock;
        reset = 0;
        check_output(3'b101, 3'd0);  // out = 101, state = Sa (0)
        
        // Transition to Sb with in = 11
        in = 2'b11;
        pulse_clock;
        check_output(3'b010, 3'd1);  // out = 010, state = Sb (1)
        
        // Transition to Sd with in = 11 from Sb
        in = 2'b11;
        pulse_clock;
        check_output(3'b101, 3'd3);  // out = 101, state = Sd (3)
        
        // Transition to Sc from Sd
        in = 2'b00; // Input irrelevant, since Sd always goes to Sc
        pulse_clock;
        check_output(3'b001, 3'd2);  // out = 001, state = Sc (2)
        
        // Apply another reset
        $display("Applying Reset...");
        reset = 1;
        pulse_clock;
        reset = 0;
        check_output(3'b101, 3'd0);  // out = 101, state = Sa (0)
        
        // Transition to Sb with in = 11
        in = 2'b11;
        pulse_clock;
        check_output(3'b010, 3'd1);  // out = 010, state = Sb (1)
        
        // Transition to Se with in = 00 from Sb
        in = 2'b00;
        pulse_clock;
        check_output(3'b011, 3'd4);  // out = 011, state = Se (4)
        
        // Transition to Sd with in = 11 from Se
        in = 2'b11;
        pulse_clock;
        check_output(3'b101, 3'd3);  // out = 101, state = Sd (3)
        
        // Finish simulation
        $display("All tests completed.");
        $stop;
    end
    
endmodule
