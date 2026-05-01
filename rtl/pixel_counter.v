module pixel_counter #(
    parameter H_ACTIVE = 1920,
    parameter H_BLANK = 160,
    parameter H_TOTAL = H_ACTIVE + H_BLANK
)(
    input wire CLK,
    input wire rst_n,
    //
    output reg [11:0] h_cnt,
    output wire line_end
);

    assign line_end = (h_cnt == H_TOTAL - 1);

always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        h_cnt <= 12'd0;
    end else begin
        if (line_end) begin
            h_cnt <= 12'd0;
        end else begin
            h_cnt <= h_cnt + 12'd1;
        end
    end
end

endmodule