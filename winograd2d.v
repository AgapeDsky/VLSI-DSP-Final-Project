module delay1b
(
    input clk,
    input rst,
    input in,
    output reg out
);

always @(posedge(clk)) begin
    if (!rst) begin
        out <= 1'b0;
    end
    else begin
        out <= in;
    end
end
endmodule

module winograd2d
(
    input clk,
    input rst,
    input signed [31:0] r1_x, r2_x, r3_x, r4_x,
    input signed [31:0] r1_w, r2_w, r3_w,
    output signed [31:0] r1_res, r2_res
);

// INTERNAL
wire signed [31:0] r1_wout, r2_wout, r3_wout, r4_wout;
wire signed [31:0] r1_xout, r2_xout, r3_xout, r4_xout;
wire rst_d1, rst_d2;

// PORT MAP
delay1b reset_delay_1
(
    clk,
    rst,
    rst,
    rst_d1
);
delay1b reset_delay_2
(
    clk,
    rst,
    rst_d1,
    rst_d2
);
top_G_w_G weight_transformer
(
    clk,
    rst,
    r1_w, r2_w, r3_w,
    r1_wout, r2_wout, r3_wout, r4_wout
);
top_B_x_B input_transformer
(
    clk,
    rst,
    r1_x, r2_x, r3_x, r4_x,
    r1_xout, r2_xout, r3_xout, r4_xout
);
top_A_y_A result_calculation
(
    clk,
    rst_d2,
    r1_xout, r2_xout, r3_xout, r4_xout,
    r1_wout, r2_wout, r3_wout, r4_wout,
    r1_res, r2_res
);

endmodule