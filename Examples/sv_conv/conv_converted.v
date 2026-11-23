module conv_3x3 (
	clk,
	reset,
	p00,
	p01,
	p02,
	p10,
	p11,
	p12,
	p20,
	p21,
	p22,
	conv_out
);
	reg _sv2v_0;
	input wire clk;
	input wire reset;
	input wire signed [7:0] p00;
	input wire signed [7:0] p01;
	input wire signed [7:0] p02;
	input wire signed [7:0] p10;
	input wire signed [7:0] p11;
	input wire signed [7:0] p12;
	input wire signed [7:0] p20;
	input wire signed [7:0] p21;
	input wire signed [7:0] p22;
	output reg signed [15:0] conv_out;
	localparam signed [7:0] W00 = -1;
	localparam signed [7:0] W01 = 0;
	localparam signed [7:0] W02 = 1;
	localparam signed [7:0] W10 = -2;
	localparam signed [7:0] W11 = 0;
	localparam signed [7:0] W12 = 2;
	localparam signed [7:0] W20 = -1;
	localparam signed [7:0] W21 = 0;
	localparam signed [7:0] W22 = 1;
	reg signed [15:0] sum_comb;
	always @(*) begin
		if (_sv2v_0)
			;
		sum_comb = ((((((((p00 * W00) + (p01 * W01)) + (p02 * W02)) + (p10 * W10)) + (p11 * W11)) + (p12 * W12)) + (p20 * W20)) + (p21 * W21)) + (p22 * W22);
	end
	always @(posedge clk or posedge reset)
		if (reset)
			conv_out <= 16'sd0;
		else
			conv_out <= sum_comb;
	initial _sv2v_0 = 0;
endmodule