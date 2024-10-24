// File: q1.v

module detect_full (
    input [11:0] ain,  // 12-bit input representing the 4x3 grid
    output reg [2:0] f // 3-bit one-hot output for the fully occupied row
);
    
    always @(*) begin
        // Default output, no rows are fully occupied
        f = 3'b000;
        
        // Check top row (bits 0, 1, 2, 3)
        if (ain[3:0] == 4'b1111)
            f = 3'b001; // Top row fully occupied

        // Check middle row (bits 4, 5, 6, 7) only if top row is not fully occupied
        else if (ain[7:4] == 4'b1111)
            f = 3'b010; // Middle row fully occupied

        // Check bottom row (bits 8, 9, 10, 11) only if top and middle rows are not fully occupied
        else if (ain[11:8] == 4'b1111)
            f = 3'b100; // Bottom row fully occupied
    end

endmodule