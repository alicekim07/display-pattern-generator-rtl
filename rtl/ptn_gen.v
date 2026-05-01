module ptn_gen #(
    parameter H_ACTIVE = 1920,
    parameter H_BLANK = 160,

    parameter V_SYNC = 5,
    parameter V_BP = 20,
    parameter V_ACTIVE = 1080,
    parameter V_FP = 20
)(
    input wire CLK,
    input wire rst_n,

    output wire vsync,
    output wire de,
    output wire [7:0] data
);

    localparam H_TOTAL = H_ACTIVE + H_BLANK;
    localparam V_BLANK = V_SYNC + V_BP + V_FP;
    localparam V_TOTAL = V_ACTIVE + V_BLANK;

    // Internal signals
    wire [11:0] h_cnt;
    wire line_end;

    wire [11:0] v_cnt;

    wire h_active;
    wire v_active;
    wire active_area;
    wire [11:0] active_x;
    wire [11:0] active_y;
    wire v_sync_area;

    // pixel counter
    pixel_counter #(
        .H_ACTIVE(H_ACTIVE),
        .H_BLANK(H_BLANK),
        .H_TOTAL(H_TOTAL)
    ) u_pixel_counter (
        .CLK(CLK),
        .rst_n(rst_n),
        .h_cnt(h_cnt),
        .line_end(line_end)
    );

    // line counter
    line_counter #(
        .V_SYNC(V_SYNC),
        .V_BP(V_BP),
        .V_ACTIVE(V_ACTIVE),
        .V_FP(V_FP),
        .V_TOTAL(V_TOTAL)
    ) u_line_counter (
        .CLK(CLK),
        .rst_n(rst_n),
        .line_end(line_end),
        .v_cnt(v_cnt)
    );

    // frame timing generator
    frame_timing_generator #(
        .H_ACTIVE(H_ACTIVE),
        .H_BLANK(H_BLANK),
        .H_TOTAL(H_TOTAL),
        .V_SYNC(V_SYNC),
        .V_BP(V_BP),
        .V_ACTIVE(V_ACTIVE),
        .V_FP(V_FP),
        .V_TOTAL(V_TOTAL)
    ) u_frame_timing_generator (
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .active_area(active_area),
        .active_x(active_x),
        .active_y(active_y),
        .v_sync_area(v_sync_area)
    );

    // de generator
    de_generator u_de_generator (
        .CLK(CLK),
        .rst_n(rst_n),
        .active_area(active_area),
        .de(de)
    );

    // vsync generator
    vsync_generator u_vsync_generator (
        .CLK(CLK),
        .rst_n(rst_n),
        .v_sync_area(v_sync_area),
        .vsync(vsync)
    );

    // pattern data generator
    pattern_data_generator #(
        .H_ACTIVE(H_ACTIVE),
        .V_ACTIVE(V_ACTIVE)
    ) u_pattern_data_generator (
        .CLK(CLK),
        .rst_n(rst_n),
        .active_area(active_area),
        .active_x(active_x),
        .active_y(active_y),
        .data(data)
    );


endmodule
