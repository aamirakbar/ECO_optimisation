module mac (
    input  logic        clk,
    input  logic        reset,
    input  logic [15:0] a,
    input  logic [15:0] b,
    output logic [31:0] acc
);
    logic [31:0] mult_reg;
    logic [31:0] add_reg;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mult_reg <= 32'h0;
            add_reg  <= 32'h0;
            acc      <= 32'h0;
        end else begin
            mult_reg <= a * b;
            add_reg  <= mult_reg + acc;
            acc      <= add_reg;
        end
    end
endmodule
