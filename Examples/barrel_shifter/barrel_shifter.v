module barrel_shifter (
    input  wire [31:0] data_in,
    input  wire [4:0]  shift_amt,
    input  wire        direction, // 0 = left, 1 = right
    input  wire        clk,
    output reg  [31:0] data_out
);

    // Combinational shift logic
    wire [31:0] shift_left;
    wire [31:0] shift_right;
    wire [31:0] shifted_result;

    // Left shift stages (Muxes)
    assign shift_left = shift_amt[4] ? {data_in[15:0], 16'b0} : data_in;
    wire [31:0] l2 = shift_amt[3] ? {shift_left[23:0], 8'b0} : shift_left;
    wire [31:0] l3 = shift_amt[2] ? {l2[27:0], 4'b0} : l2;
    wire [31:0] l4 = shift_amt[1] ? {l3[29:0], 2'b0} : l3;
    wire [31:0] l5 = shift_amt[0] ? {l4[30:0], 1'b0} : l4;

    // Right shift stages (Muxes)
    assign shift_right = shift_amt[4] ? {16'b0, data_in[31:16]} : data_in;
    wire [31:0] r2 = shift_amt[3] ? {8'b0, shift_right[31:8]} : shift_right;
    wire [31:0] r3 = shift_amt[2] ? {4'b0, r2[31:4]} : r2;
    wire [31:0] r4 = shift_amt[1] ? {2'b0, r3[31:2]} : r3;
    wire [31:0] r5 = shift_amt[0] ? {1'b0, r4[31:1]} : r4;

    // Direction Mux
    assign shifted_result = direction ? r5 : l5;

    // Registered output (so OpenSTA can analyze it)
    always @(posedge clk) begin
        data_out <= shifted_result;
    end

endmodule
