module conv_3x3 (
    input  logic               clk,
    input  logic               reset,
    input  logic signed [7:0]  p00, p01, p02,
    input  logic signed [7:0]  p10, p11, p12,
    input  logic signed [7:0]  p20, p21, p22,
    output logic signed [15:0] conv_out
);
    // Hardcoded Sobel-like filter weights
    localparam signed [7:0] W00 = -1, W01 = 0, W02 = 1;
    localparam signed [7:0] W10 = -2, W11 = 0, W12 = 2;
    localparam signed [7:0] W20 = -1, W21 = 0, W22 = 1;

    logic signed [15:0] sum_comb;

    always_comb begin
        sum_comb = (p00 * W00) + (p01 * W01) + (p02 * W02) +
                   (p10 * W10) + (p11 * W11) + (p12 * W12) +
                   (p20 * W20) + (p21 * W21) + (p22 * W22);
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            conv_out <= 16'sd0;
        end else begin
            conv_out <= sum_comb;
        end
    end
endmodule
