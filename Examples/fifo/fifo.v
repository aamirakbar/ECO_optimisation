module fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 512, // Must be a power of 2
    parameter ALMOST_FULL_THRESH = 480,
    parameter ALMOST_EMPTY_THRESH = 32
)(
    input wire clk,
    input wire reset,
    
    // Write Interface
    input wire wr_en,
    input wire [DATA_WIDTH-1:0] wr_data,
    output wire full,
    output wire almost_full,
    output wire half_full,
    
    // Read Interface
    input wire rd_en,
    output reg [DATA_WIDTH-1:0] rd_data,
    output wire empty,
    output wire almost_empty,
    
    // Status
    output wire [9:0] count
);

    // Memory Array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    
    // Pointers
    reg [9:0] wr_ptr, rd_ptr;
    reg [9:0] wr_ptr_gray, rd_ptr_gray;
    reg [9:0] wr_ptr_gray_next, rd_ptr_gray_next;
    
    // Count
    reg [9:0] fifo_count;
    
    // ==========================================
    // WRITE LOGIC
    // ==========================================
    wire do_write = wr_en && !full;
    
    always @(posedge clk) begin
        if (do_write) begin
            mem[wr_ptr[8:0]] <= wr_data;
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 10'b0;
            wr_ptr_gray <= 10'b0;
        end else if (do_write) begin
            wr_ptr <= wr_ptr + 1'b1;
            wr_ptr_gray <= ((wr_ptr + 1'b1) >> 1) ^ (wr_ptr + 1'b1);
        end
    end
    
    // ==========================================
    // READ LOGIC
    // ==========================================
    wire do_read = rd_en && !empty;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rd_ptr <= 10'b0;
            rd_ptr_gray <= 10'b0;
        end else if (do_read) begin
            rd_ptr <= rd_ptr + 1'b1;
            rd_ptr_gray <= ((rd_ptr + 1'b1) >> 1) ^ (rd_ptr + 1'b1);
        end
    end
    
    // ==========================================
    // FLAGS & COUNT
    // ==========================================
    assign empty = (fifo_count == 0);
    assign full  = (fifo_count == DEPTH);
    assign almost_full  = (fifo_count >= ALMOST_FULL_THRESH);
    assign almost_empty = (fifo_count <= ALMOST_EMPTY_THRESH);
    assign half_full    = (fifo_count >= DEPTH/2);
    assign count = fifo_count;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fifo_count <= 10'b0;
        end else begin
            if (do_write && !do_read) begin
                fifo_count <= fifo_count + 1'b1;
            end else if (!do_write && do_read) begin
                fifo_count <= fifo_count - 1'b1;
            end
        end
    end
    
    // ==========================================
    // OUTPUT BYPASS LOGIC (Fall-through)
    // ==========================================
    // This creates a 32-bit MUX on the output to reduce latency
    always @(posedge clk) begin
        if (reset) begin
            rd_data <= {DATA_WIDTH{1'b0}};
        end else if (do_read) begin
            rd_data <= mem[rd_ptr[8:0]];
        end else if (empty && wr_en) begin
            // Bypass logic: if empty and writing, push data straight to output
            rd_data <= wr_data;
        end
    end

endmodule