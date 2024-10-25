`timescale 1ps/1ps

module q2_tb;
  // Declare internal signals
  reg clk, reset;
  reg [3:0] in;

  // Clock generation: Starts high, toggles every 5 ps
  initial begin
    clk = 1;
    forever begin
      #5 clk = ~clk;
      if ($time >= 55) $stop; // Stop toggling at 55 ps
    end
  end

  // Generate the reset and input signals according to the provided timing
  initial begin
    // Initialize signals
    reset = 0;
    in = 4'b0000;

    // Generate reset waveform
    #5  reset = 1;   // Reset goes high at 5 ps
    #10 reset = 0;   // Reset goes low at 15 ps

    // Apply changes to the 'in' signal
    #0  in = 4'b0000;  // in is 0000 from 0 ps to 15 ps
    #15 in = 4'b0110;  // in changes to 0110 at 15 ps
    #10 in = 4'b1101;  // in changes to 1101 at 25 ps
    #10 in = 4'b1001;  // in changes to 1001 at 35 ps
    #10 in = 4'b1011;  // in changes to 1011 at 45 ps

    // Stop simulation at exactly 55 ps
    #10 $stop;
  end

endmodule
