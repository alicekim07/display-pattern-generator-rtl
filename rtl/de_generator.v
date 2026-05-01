module de_generator #(
    input wire CLK,
    input wire rst_n,
    //
    input wire active_area,
    //
    output reg de
);

    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            de <= 1'b0;
        end else begin
            de <= active_area;
        end
    end

endmodule