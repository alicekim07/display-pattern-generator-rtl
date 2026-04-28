module frame_timing_generator #(
    parameter H_ACTIVE = 1920,
    parameter H_BLANK = 160,
    parameter H_TOTAL = H_ACTIVE + H_BLANK,

    parameter V_SYNC = 5,
    parameter V_BP = 20,
    parameter V_ACTIVE = 1080,
    parameter V_FP = 20,
    parameter V_TOTAL = V_SYNC + V_BP + V_ACTIVE + V_FP
)(
    input wire [11:0] h_cnt,
    input wire [11:0] v_cnt,
    //
    output wire active_area,
    //
    output wire [11:0] active_x,
    output wire [11:0] active_y,
    //
    output wire v_sync_area
);

    localparam H_ACTIVE_START = 0;
    localparam H_ACTIVE_END = H_ACTIVE_START + H_ACTIVE;

    localparam V_SYNC_START = 0;
    localparam V_SYNC_END = V_SYNC_START + V_SYNC;

    localparam V_ACTIVE_START = V_SYNC_END + V_BP;
    localparam V_ACTIVE_END = V_ACTIVE_START + V_ACTIVE;

    assign h_active = (h_cnt >= H_ACTIVE_START) && (h_cnt < H_ACTIVE_END);

    assign v_active = (v_cnt >= V_ACTIVE_START) && (v_cnt < V_ACTIVE_END);

    assign active_area = h_active && v_active;

    assign v_sync_area = (v_cnt >= V_SYNC_START) && (v_cnt < V_SYNC_END);

    assign active_x = h_active ? (h_cnt - H_ACTIVE_START) : 12'd0;
    assign active_y = v_active ? (v_cnt - V_ACTIVE_START) : 12'd0;

endmodule