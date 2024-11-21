module ALU (
    input [15:0] Ain, Bin,// Input data
    input [1:0] ALUop,// Determines the operation to be performed
    output reg [15:0] out, // Output of the ALU
    output reg Z, N, V // Flags: Zero, Negative, Overflow
);

    reg overflow; // Internal overflow flag

    always @(*) begin
        // Default values 
        out = 16'b0;
        Z = 0;
        N = 0;
        V = 0;
        overflow = 0;

        case (ALUop)
            2'b00: begin
                out = Ain + Bin; // Addition
                // Overflow detection for addition
                if ((Ain[15]==Bin[15]) &&(Ain[15]!=out[15])) begin
                    overflow = 1;
                end else begin
                    overflow = 0;
                end
            end
            2'b01: begin
                out = Ain - Bin; // Subtraction
                // Overflow detection for subtraction
                if ((Ain[15] != Bin[15]) && (out[15] != Ain[15])) begin
                    overflow = 1;
                end else begin
                    overflow = 0;
                end
            end
            2'b10: begin
                out = Ain & Bin; // Bitwise AND
                overflow = 0; // No overflow in AND
            end
            2'b11: begin
                out = ~Bin; // Bitwise NOT
                overflow = 0; // No overflow in NOT
            end
            default: begin
                out = 16'b0; // Default output is 0
                overflow = 0;
            end
        endcase

        // Set the V flag based on the overflow flag
        if (overflow == 1) begin
            V = 1;
        end else begin
            V = 0;
        end

        // Set the Z flag if the output is zero
        if (out == 16'b0) begin
            Z = 1;
        end else begin
            Z = 0;
        end
        // Set the N flag if the output is negative (MSB is 1)
        if (out[15] == 1) begin
            N = 1;
        end else begin
            N = 0;
        end
    end

endmodule