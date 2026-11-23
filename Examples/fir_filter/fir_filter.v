module fir_filter (
    input clk,
    input reset,
    input signed [7:0] x,        // Input sample
    input signed [7:0] c0, c1, c2, c3, c4, c5, c6, c7, // Coefficients
    output reg signed [18:0] y   // Output (8 bits + 8 bits + 3 bits growth)
);
    // Shift register for past inputs
    reg signed [7:0] x0, x1, x2, x3, x4, x5, x6, x7;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x0 <= 0; x1 <= 0; x2 <= 0; x3 <= 0;
            x4 <= 0; x5 <= 0; x6 <= 0; x7 <= 0;
            y  <= 0;
        end else begin
            // Shift register
            x0 <= x;
            x1 <= x0;
            x2 <= x1;
            x3 <= x2;
            x4 <= x3;
            x5 <= x4;
            x6 <= x5;
            x7 <= x6;

            // Multiply-Accumulate (MAC)
            y <= (x0 * c0) + (x1 * c1) + (x2 * c2) + (x3 * c3) +
                 (x4 * c4) + (x5 * c5) + (x6 * c6) + (x7 * c7);
        end
    end
endmodule
