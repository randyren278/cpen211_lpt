module detect_cover(ain, bin, f);
  input [5:0] ain, bin;
  output reg [5:0] f;

  always @(*) begin
    if ((ain & bin) == ain)
      f = ain;
    else
      f = 6'b000000;
  end
endmodule

