module datapath(clk,Rd,w,in,sel,Ri,Rj,lsb,aop,loadb,out);
 input clk, w, sel, loadb;
 input [1:0] Rd, Ri, Rj;
 input [15:0] in;
 input [1:0] aop;
 output lsb;
 output [15:0] out;


 logic [15:0] R0, R1, R2;
 logic [15:0] iout, jout, aout, lsb;
logic aL;
logic [2:0] load; //decoder singal

    //decoder
    always_comb begin
       load = 3'b000; 
        if (w) begin
            case (Rd)
                2'b00: load[0] = 1'b1;
                2'b01: load[1] = 1'b1;
                2'b10: load[2] = 1'b1;
                default: load = 3'b000;
            endcase
        end
    end

    //lodaing registers with the side multiplexer
    always_ff @(posedge clk) begin
        if (load[0]) R0 <= sel ? in : aout;
        if (load[1]) R1 <= sel ? in : aout;
        if (load[2]) R2 <= sel ? in : aout;
    end

 //first mux
    always_comb begin
        case (Ri)
            2'b00: iout = R0;
            2'b01: iout = R1;
            2'b10: iout = R2;
            default: iout = 16'b0;
        endcase
    end

// right side mux 
    always_comb begin
        case (Rj)
            2'b00: jout = R0;
            2'b01: jout = R1;
            2'b10: jout = R2;
            default: jout = 16'b0;
        endcase
    end

//alu operations 
    always_comb begin
        case (aop)
            2'b00: aout = iout >> 1; 
            2'b01: aout = iout << 1; 
            2'b10: aout = iout + jout; 
            2'b11: aout = iout; 
            default: aout = 16'b0;
        endcase
        aL = aout; //im assuming this is what aL does not tooo sure 
    end

    // LSB logic
    always_ff @(posedge clk) begin
        if (loadb)
            lsb <= aL;//lad register at the bottom
    end
 

    assign out = R2;//data path ouput 


endmodule
