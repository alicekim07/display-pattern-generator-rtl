`timescale 1ns/1ps

module tb_line_counter;

	localparam V_SYNC_TB   = 5;
	localparam V_BP_TB     = 20;
	localparam V_ACTIVE_TB = 1080;
	localparam V_FP_TB     = 20;
	localparam V_TOTAL_TB  = V_SYNC_TB + V_BP_TB + V_ACTIVE_TB + V_FP_TB;

	reg CLK;
	reg rst_n;
	reg line_end;
	wire [11:0] v_cnt;

	integer cycle;
	integer expected_cnt;

	line_counter #(
		.V_SYNC(V_SYNC_TB),
		.V_BP(V_BP_TB),
		.V_ACTIVE(V_ACTIVE_TB),
		.V_FP(V_FP_TB)
	) dut (
		.CLK(CLK),
		.rst_n(rst_n),
		.line_end(line_end),
		.v_cnt(v_cnt)
	);

	initial begin
		CLK = 1'b0;
		forever #5 CLK = ~CLK;
	end

	initial begin
		rst_n = 1'b0;
		line_end = 1'b0;
		expected_cnt = 0;

		$display("[TB] line_counter test start");

		repeat (3) @(posedge CLK);
		@(negedge CLK);
		rst_n = 1'b1;

		#1;
		if (v_cnt !== 12'd0) begin
			$display("[FAIL] after reset release expected v_cnt=0, got=%0d", v_cnt);
			$fatal;
		end

		for (cycle = 0; cycle < (V_TOTAL_TB * 3 + 5); cycle = cycle + 1) begin
			line_end = 1'b1;
			@(posedge CLK);
			#1;
			line_end = 1'b0;

			if (expected_cnt == V_TOTAL_TB - 1)
				expected_cnt = 0;
			else
				expected_cnt = expected_cnt + 1;

			if (v_cnt !== expected_cnt[11:0]) begin
				$display("[FAIL] cycle=%0d expected v_cnt=%0d, got=%0d", cycle, expected_cnt, v_cnt);
				$fatal;
			end

			@(posedge CLK);
			#1;

			if (v_cnt !== expected_cnt[11:0]) begin
				$display("[FAIL] hold check cycle=%0d expected v_cnt=%0d, got=%0d", cycle, expected_cnt, v_cnt);
				$fatal;
			end
		end

		rst_n = 1'b0;
		@(posedge CLK);
		#1;

		if (v_cnt !== 12'd0) begin
			$display("[FAIL] reset assertion failed, v_cnt=%0d", v_cnt);
			$fatal;
		end

		$display("[PASS] line_counter test passed");
		$finish;
	end

endmodule

