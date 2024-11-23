module tb_check_q1;
  reg clk, w, sel, loadb;
  reg [1:0] Rd, Ri, Rj;
  reg [15:0] in;
  reg [1:0] aop;
  wire lsb;
  wire [15:0] out;

  datapath DUT(clk,Rd,w,in,sel,Ri,Rj,lsb,aop,loadb,out);

  // make sure you get no warnings for the the following lines!
  wire [15:0] R0 = DUT.R0;
  wire [15:0] R1 = DUT.R1;
  wire [15:0] R2 = DUT.R2;
  wire [15:0] aout = DUT.aout;
  wire [15:0] iout = DUT.iout;
  wire [15:0] jout = DUT.jout;
  wire aL  = DUT.aL;
  wire [2:0] load = DUT.load;

  initial begin
    $display("INTERFACE OK; Also check above this line for any warnings.");
  end
endmodule 

module tb_check_q2;
  reg clk, reset, s;
  reg [15:0] in;
  reg [4:0] op;
  wire [15:0] out;
  wire done;
  
  mult DUT(clk,reset,s,op,in,out,done);

  wire [15:0] R0 = DUT.DP.R0;
  wire [15:0] R1 = DUT.DP.R1;
  wire [15:0] R2 = DUT.DP.R2;
  wire [15:0] aout = DUT.DP.aout;
  wire [15:0] iout = DUT.DP.iout;
  wire [15:0] jout = DUT.DP.jout;
  wire aL  = DUT.DP.aL;
  wire [2:0] load = DUT.DP.load;

  // make sure you get no warnings for the the following lines!

  initial forever begin
    clk = 0; #5;
    clk = 1; #5;
  end

  initial begin
    s = 1'b0;
    reset = 1'b1;
    @(posedge done); // wait for FSM to reset
    @(negedge clk);  // wait for falling edge of clk after FSM reset
    reset = 1'b0; 
    #10;

    if (done !== 1'b1) begin
      $display("ERROR ** 'done' should be set to 1 after reset");
      $stop;
    end

    s = 1'b1; in = 15'd6; op = 5'b00000; // MOV R0, #6  (110)
    @(posedge clk); 
    @(negedge clk); 

    if (done !== 1'b0) begin
      $display("ERROR ** 'done' should be set to 0 for at least one cycle after s is set to 1");
      $stop;
    end
    #10;
    $display("INTERFACE OK; Also check above this line for any warnings.");
    $stop;
  end
endmodule

module tb_mult;
  reg clk, reset, s;
  reg [15:0] in;
  reg [4:0] op;
  wire [15:0] out;
  wire done;
  
  mult DUT(clk,reset,s,op,in,out,done);

  wire [15:0] R0 = DUT.DP.R0;
  wire [15:0] R1 = DUT.DP.R1;
  wire [15:0] R2 = DUT.DP.R2;
  wire [15:0] aout = DUT.DP.aout;
  wire [15:0] iout = DUT.DP.iout;
  wire [15:0] jout = DUT.DP.jout;
  wire aL  = DUT.DP.aL;
  wire [2:0] load = DUT.DP.load;

  // make sure you get no warnings for the the following lines!

  initial forever begin
    clk = 0; #5;
    clk = 1; #5;
  end

  initial begin
    s = 1'b0;
    reset = 1'b1;
    @(posedge done); // wait for FSM to reset
    @(negedge clk);  // wait for falling edge of clk after FSM reset
    reset = 1'b0; 
    #10;

    if (done !== 1'b1) begin
      $display("ERROR ** 'done' should be set to 1 after reset");
      $stop;
    end

    s = 1'b1; in = 15'd6; op = 5'b00000; // MOV R0, #6  (110)
    @(posedge clk); 
    @(negedge clk); 

    if (done !== 1'b0) begin
      $display("ERROR ** 'done' should be set to 0 for at least one cycle after s is set to 1");
      $stop;
    end

    @(posedge done); // wait for instruction to finish

    assert(DUT.DP.R0 === 15'd6) else $error("*** ERROR ***");

    @(negedge clk); 
    s = 1'b1; in = 15'd7; op = 5'b00100;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.DP.R1 === 15'd7)  else $error("*** ERROR ***");

    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b01000;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.DP.R2 === 15'd0) else $error("*** ERROR ***");

    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b00011;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.lsb === 1'b0)  else $error("*** ERROR ***");

    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b11001;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.DP.R2 === 15'd0) else $error("*** ERROR ***");
  
    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b00001;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.DP.R0 === 15'd3) else $error("*** ERROR ***");
  
    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b00110;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.DP.R1 === 15'd14) else $error("*** ERROR ***");

    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b00011;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.lsb === 1'b1) else $error("*** ERROR ***");

    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b11001;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.DP.R2 === 15'd14) else $error("*** ERROR ***");

    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b00001;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.DP.R0 === 15'd1) else $error("*** ERROR ***");
  
    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b00110;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.DP.R1 === 15'd28) else $error("*** ERROR ***");

    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b00011;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    assert(DUT.lsb === 1'b1) else $error("*** ERROR ***");

    @(negedge clk); 
    s = 1'b1; in = 15'd0; op = 5'b11001;
    @(negedge clk); 
    @(posedge done); // wait for instruction to finish
    #10;
    if(DUT.DP.R2 !== 15'd42) begin
      $display("ERROR ** R2 not set to 42 as expected");
      $stop;
    end else begin
      $display("The answer is 42.");
      $stop;
    end
  end
endmodule 
