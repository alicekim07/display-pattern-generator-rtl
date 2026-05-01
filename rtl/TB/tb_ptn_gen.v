`timescale 1ns/1ps

module tb_ptn_gen;

    localparam H_ACTIVE_TB = 1920;
    localparam H_BLANK_TB  = 160;
    localparam H_TOTAL_TB  = H_ACTIVE_TB + H_BLANK_TB;

    localparam V_SYNC_TB   = 5;
    localparam V_BP_TB     = 20;
    localparam V_ACTIVE_TB = 1080;
    localparam V_FP_TB     = 20;
    localparam V_TOTAL_TB  = V_SYNC_TB + V_BP_TB + V_ACTIVE_TB + V_FP_TB;

    reg CLK;
    reg rst_n;

    wire vsync;
    wire de;
    wire [7:0] data;

    ptn_gen #(
        .H_ACTIVE(H_ACTIVE_TB),
        .H_BLANK(H_BLANK_TB),
        .V_SYNC(V_SYNC_TB),
        .V_BP(V_BP_TB),
        .V_ACTIVE(V_ACTIVE_TB),
        .V_FP(V_FP_TB)
    ) dut (
        .CLK(CLK),
        .rst_n(rst_n),
        .vsync(vsync),
        .de(de),
        .data(data)
    );

    // clock generation
    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;   // 100MHz
    end

    // reset and simulation control
    initial begin
        rst_n = 1'b0;

        #30;
        rst_n = 1'b1;

        // 몇 프레임 정도만 돌림
        #(H_TOTAL_TB * V_TOTAL_TB * 10 * 3);

        $finish;
    end

endmodule