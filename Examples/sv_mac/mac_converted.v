module mac (
	clk,
	reset,
	a,
	b,
	acc
);
	input wire clk;
	input wire reset;
	input wire [15:0] a;
	input wire [15:0] b;
	output reg [31:0] acc;
	reg [31:0] mult_reg;
	reg [31:0] add_reg;
	always @(posedge clk or posedge reset)
		if (reset) begin
			mult_reg <= 32'h00000000;
			add_reg <= 32'h00000000;
			acc <= 32'h00000000;
		end
		else begin
			mult_reg <= a * b;
			add_reg <= mult_reg + acc;
			acc <= add_reg;
		end
endmodule