module pattern_data_generator(
    parameter H_ACTIVE = 1920,
    parameter V_ACTIVE = 1080
)(
    input wire CLK,
    input wire rst_n,
    //
    input wire active_area,
    input wire [11:0] active_x,
    input wire [11:0] active_y,
    //
    output reg [7:0] data
);

    wire [19:0] h_scaled;

    wire [7:0] h_gray;

    assign h_scaled = active_x * 8'd255;

    assign h_gray = (active_x >= H_ACTIVE - 1) ? 8'd255 : h_scaled / (H_ACTIVE - 1);

    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            data <= 8'd0;
        end else begin
            if (active_area) begin
                data <= h_gray;
            end else begin
                data <= 8'd0;
            end
        end
    end


endmodule