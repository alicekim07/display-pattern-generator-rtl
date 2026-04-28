module vsync_generator(
    input  wire CLK,
    input  wire rst_n,

    input  wire v_sync_area,

    output reg  vsync
);

always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        vsync <= 1'b0;
    end
    else begin
        vsync <= v_sync_area;
    end
end

endmodule