module uart (
    input clk,
    input reset,
    
    // Transmitter
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy,

    // Receiver
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done,
    output reg rx_error
);
    parameter BAUD_DIV = 434;

    reg [9:0] tx_shift;
    reg [15:0] tx_clk_cnt;
    reg [3:0] tx_bit_cnt;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            tx_clk_cnt <= 0;
            tx_bit_cnt <= 0;
            tx_shift <= 10'h3FF;
        end else begin
            if (tx_start && !tx_busy) begin
                tx_shift <= {1'b1, tx_data, 1'b0};
                tx_busy <= 1'b1;
                tx_clk_cnt <= 0;
                tx_bit_cnt <= 0;
            end else if (tx_busy) begin
                if (tx_clk_cnt == BAUD_DIV - 1) begin
                    tx_clk_cnt <= 0;
                    tx <= tx_shift[0];
                    tx_shift <= {1'b1, tx_shift[9:1]};
                    tx_bit_cnt <= tx_bit_cnt + 1;
                    if (tx_bit_cnt == 9) begin
                        tx_busy <= 1'b0;
                    end
                end else begin
                    tx_clk_cnt <= tx_clk_cnt + 1;
                end
            end
        end
    end

    reg rx_sync1, rx_sync2;
    reg [15:0] rx_clk_cnt;
    reg [3:0] rx_bit_cnt;
    reg [9:0] rx_shift;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_sync1 <= 1'b1; rx_sync2 <= 1'b1;
            rx_data <= 0; rx_done <= 1'b0; rx_error <= 1'b0;
            rx_clk_cnt <= 0; rx_bit_cnt <= 0; rx_shift <= 0;
        end else begin
            rx_sync1 <= rx;
            rx_sync2 <= rx_sync1;
            rx_done <= 1'b0;

            if (rx_sync2 == 1'b0 && rx_clk_cnt == 0 && rx_bit_cnt == 0) begin
                rx_clk_cnt <= 1;
            end else if (rx_clk_cnt > 0) begin
                if (rx_clk_cnt == BAUD_DIV - 1) begin
                    rx_clk_cnt <= 0;
                    rx_shift <= {rx_sync2, rx_shift[9:1]};
                    rx_bit_cnt <= rx_bit_cnt + 1;
                    
                    if (rx_bit_cnt == 9) begin
                        rx_bit_cnt <= 0;
                        if (rx_shift[9] == 1'b1) begin
                            rx_data <= rx_shift[8:1];
                            rx_done <= 1'b1;
                            rx_error <= 1'b0;
                        end else begin
                            rx_error <= 1'b1;
                        end
                    end
                end else begin
                    rx_clk_cnt <= rx_clk_cnt + 1;
                end
            end
        end
    end
endmodule
