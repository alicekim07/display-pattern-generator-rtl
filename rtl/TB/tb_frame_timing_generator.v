`timescale 1ns/1ps

module tb_frame_timing_generator;

    localparam H_ACTIVE_TB = 1920;
    localparam H_BLANK_TB  = 160;
    localparam H_TOTAL_TB  = H_ACTIVE_TB + H_BLANK_TB;

    localparam V_SYNC_TB   = 5;
    localparam V_BP_TB     = 20;
    localparam V_ACTIVE_TB = 1080;
    localparam V_FP_TB     = 20;
    localparam V_TOTAL_TB  = V_SYNC_TB + V_BP_TB + V_ACTIVE_TB + V_FP_TB;

    reg CLK;

    reg [11:0] h_cnt;
    reg [11:0] v_cnt;

    wire active_area;
    wire [11:0] active_x;
    wire [11:0] active_y;
    wire v_sync_area;

    integer cycle;

    integer exp_h_active;
    integer exp_v_active;
    integer exp_active_area;
    integer exp_v_sync_area;
    integer exp_active_x;
    integer exp_active_y;

    frame_timing_generator #(
        .H_ACTIVE(H_ACTIVE_TB),
        .H_BLANK(H_BLANK_TB),
        .V_SYNC(V_SYNC_TB),
        .V_BP(V_BP_TB),
        .V_ACTIVE(V_ACTIVE_TB),
        .V_FP(V_FP_TB)
    ) dut (
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .active_area(active_area),
        .active_x(active_x),
        .active_y(active_y),
        .v_sync_area(v_sync_area)
    );

    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end

    task check_outputs;
        input integer case_cycle;
        begin
            exp_h_active = (h_cnt < H_ACTIVE_TB);

            exp_v_active =
                (v_cnt >= (V_SYNC_TB + V_BP_TB)) &&
                (v_cnt <  (V_SYNC_TB + V_BP_TB + V_ACTIVE_TB));

            exp_active_area = exp_h_active && exp_v_active;

            exp_v_sync_area = (v_cnt < V_SYNC_TB);

            if (exp_h_active)
                exp_active_x = h_cnt;
            else
                exp_active_x = 0;

            if (exp_v_active)
                exp_active_y = v_cnt - (V_SYNC_TB + V_BP_TB);
            else
                exp_active_y = 0;

            if (active_area !== exp_active_area[0]) begin
                $display("[FAIL] cycle=%0d h=%0d v=%0d expected active_area=%0d, got=%0d",
                         case_cycle, h_cnt, v_cnt, exp_active_area, active_area);
                $fatal;
            end

            if (v_sync_area !== exp_v_sync_area[0]) begin
                $display("[FAIL] cycle=%0d h=%0d v=%0d expected v_sync_area=%0d, got=%0d",
                         case_cycle, h_cnt, v_cnt, exp_v_sync_area, v_sync_area);
                $fatal;
            end

            if (active_x !== exp_active_x[11:0]) begin
                $display("[FAIL] cycle=%0d h=%0d v=%0d expected active_x=%0d, got=%0d",
                         case_cycle, h_cnt, v_cnt, exp_active_x, active_x);
                $fatal;
            end

            if (active_y !== exp_active_y[11:0]) begin
                $display("[FAIL] cycle=%0d h=%0d v=%0d expected active_y=%0d, got=%0d",
                         case_cycle, h_cnt, v_cnt, exp_active_y, active_y);
                $fatal;
            end
        end
    endtask

    initial begin
        $display("[TB] frame_timing_generator scan test start");

        h_cnt = 12'd0;
        v_cnt = 12'd0;

        // full frame + wrap-around 조금 더 확인
        for (cycle = 0; cycle < (H_TOTAL_TB * V_TOTAL_TB + 10); cycle = cycle + 1) begin

            // h_cnt, v_cnt가 현재 위치일 때 DUT 출력 확인
            #1;
            check_outputs(cycle);

            @(posedge CLK);

            // 실제 동작처럼 h_cnt 증가
            if (h_cnt == H_TOTAL_TB - 1) begin
                h_cnt = 12'd0;

                // 한 줄 끝났으므로 v_cnt 증가
                if (v_cnt == V_TOTAL_TB - 1)
                    v_cnt = 12'd0;
                else
                    v_cnt = v_cnt + 12'd1;
            end else begin
                h_cnt = h_cnt + 12'd1;
            end
        end

        $display("[PASS] frame_timing_generator scan test passed");
        $finish;
    end

endmodule