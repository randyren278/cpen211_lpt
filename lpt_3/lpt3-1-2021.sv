module datapath(clk,in,sr,Rn,w,aluop,lt,tsel,bsel,out);
 input clk, w, lt;
 input [7:0] in;
 input [1:0] sr, Rn, aluop;
 input [2:0] bsel, tsel;
 output [7:0] out;

endmodule