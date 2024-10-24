module detect_full (
    input [11:0] ain,
    output [2:0] f
);

    // Define internal signals
    wire top_row_full, middle_row_full, bottom_row_full;

    // Check if top row is fully occupied
    assign top_row_full = (ain[11:8] == 4'b1111);

    // Check if middle row is fully occupied
    assign middle_row_full = (ain[7:4] == 4'b1111);

    // Check if bottom row is fully occupied
    assign bottom_row_full = (ain[3:0] == 4'b1111);

    // Assign output based on the conditions
    assign f[0] = top_row_full;
    assign f[1] = middle_row_full && !top_row_full;
    assign f[2] = bottom_row_full && !top_row_full && !middle_row_full;

endmodule