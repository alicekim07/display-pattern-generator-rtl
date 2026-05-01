`timescale 1ns/1ps

module tb_pixel_counter;

	localparam H_ACTIVE_TB = 1920;
	localparam H_BLANK_TB  = 160;
	localparam H_TOTAL_TB  = H_ACTIVE_TB + H_BLANK_TB;

	reg CLK;
	reg rst_n;
	wire [11:0] h_cnt;
	wire line_end;

	integer cycle;
	integer expected_cnt;

	pixel_counter #(
		.H_ACTIVE(H_ACTIVE_TB),
		.H_BLANK(H_BLANK_TB)
	) dut (
		.CLK(CLK),
		.rst_n(rst_n),
		.h_cnt(h_cnt),
		.line_end(line_end)
	);

	initial begin
		CLK = 1'b0;
		forever #5 CLK = ~CLK;
	end

	initial begin
		rst_n = 1'b0;
		expected_cnt = 0;

		$display("[TB] pixel_counter test start");

		repeat (3) @(posedge CLK);
		rst_n = 1'b1;

		for (cycle = 0; cycle < (H_TOTAL_TB * 3 + 5); cycle = cycle + 1) begin
			@(posedge CLK);

			if (h_cnt !== expected_cnt[11:0]) begin
				$display("[FAIL] cycle=%0d expected h_cnt=%0d, got=%0d", cycle, expected_cnt, h_cnt);
				$fatal;
			end

			if (line_end !== (expected_cnt == H_TOTAL_TB - 1)) begin
				$display("[FAIL] cycle=%0d expected line_end=%0d, got=%0d", cycle, (expected_cnt == H_TOTAL_TB - 1), line_end);
				$fatal;
			end

			if (expected_cnt == H_TOTAL_TB - 1)
				expected_cnt = 0;
			else
				expected_cnt = expected_cnt + 1;
		end

		rst_n = 1'b0;
		@(posedge CLK);
		if (h_cnt !== 12'd0) begin
			$display("[FAIL] reset assertion failed, h_cnt=%0d", h_cnt);
			$fatal;
		end

		$display("[PASS] pixel_counter test passed");
		$finish;
	end

endmodule
