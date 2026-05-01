module line_counter #(
    parameter V_SYNC = 5,
    parameter V_BP = 20,
    parameter V_ACTIVE = 1080,
    parameter V_FP = 20,
    parameter V_TOTAL = V_SYNC + V_BP + V_ACTIVE + V_FP
)(
    input wire CLK,
    input wire rst_n,
    //
    input wire line_end,
    //
    output reg [11:0] v_cnt
);


always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        v_cnt <= 12'd0;
    end else begin
        if (line_end) begin
            if (v_cnt == V_TOTAL - 1) begin
                v_cnt <= 12'd0;
            end else begin
                v_cnt <= v_cnt + 12'd1;
            end
        end
    end

end

endmodule