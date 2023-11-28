module winograd1d
(
    input signed [31:0] r1_x, r2_x, r3_x, r4_x,
    input signed [31:0] r1_w, r2_w, r3_w,
    output signed [31:0] r1_res, r2_res
);

// INTERNAL
wire signed [31:0] r1_wout, r2_wout, r3_wout, r4_wout;
wire signed [31:0] r1_xout, r2_xout, r3_xout, r4_xout;

// PORT MAP
B_x x_transform (
    .in_1(r1_x), .in_2(r2_x), .in_3(r3_x), .in_4(r4_x),
    .out_1(r1_xout), .out_2(r2_xout), .out_3(r3_xout), .out_4(r4_xout)
);
G_w w_transform (
    .in_1(r1_w), .in_2(r2_w), .in_3(r3_w),
    .out_1(r1_wout), .out_2(r2_wout), .out_3(r3_wout), .out_4(r4_wout)
);
A_y result_calculation (
    .r1_x(r1_xout), .r2_x(r2_xout), .r3_x(r3_xout), .r4_x(r4_xout),
    .r1_w(r1_wout), .r2_w(r2_wout), .r3_w(r3_wout), .r4_w(r4_wout),
    .r1_y(r1_res), .r2_y(r2_res)
);

endmodule

module A_y_error_correction
(
    input signed [31:0] r1_x, r2_x, r3_x, r4_x,
    input signed [31:0] r1_w, r2_w, r3_w, r4_w,
    input signed [31:0] r2_ec, r3_ec,
    output signed [31:0] r1_y, r2_y
);

// INTERNAL
wire signed [31:0] r1_xw, r2_xw, r3_xw, r4_xw;
assign r1_xw = r1_x * r1_w;
assign r2_xw = r2_ec + r2_x * r2_w;
assign r3_xw = r3_ec + r3_x * r3_w;
assign r4_xw = r4_x * r4_w;

// OUTPUT
assign r1_y = r1_xw + r2_xw + r3_xw;
assign r2_y = r2_xw - r3_xw - r4_xw;

endmodule

module winograd1d_error_correction
(
    input signed [31:0] r1_x, r2_x, r3_x, r4_x,
    input signed [31:0] r1_w, r2_w, r3_w,
    output signed [31:0] r1_res, r2_res
);


// INTERNAL
wire signed [31:0] r1_wout, r2_wout, r3_wout, r4_wout;
wire signed [31:0] r1_xout, r2_xout, r3_xout, r4_xout;
wire r2_err_sel, r3_err_sel;
wire signed [31:0] r2_err_val, r3_err_val;
wire signed [31:0] r2_xout_s1 = r2_xout >>> 1;
wire signed [31:0] r3_xout_s1 = r3_xout >>> 1;

assign r2_err_sel = r2_wout[0];
assign r2_err_val = (r2_err_sel == 1'b1) ? r2_xout_s1 : 32'h0000;

assign r3_err_sel = r3_wout[0];
assign r3_err_val = (r3_err_sel == 1'b1) ? r3_xout_s1 : 32'h0000;

// PORT MAP
B_x x_transform (
    .in_1(r1_x), .in_2(r2_x), .in_3(r3_x), .in_4(r4_x),
    .out_1(r1_xout), .out_2(r2_xout), .out_3(r3_xout), .out_4(r4_xout)
);
G_w w_transform (
    .in_1(r1_w), .in_2(r2_w), .in_3(r3_w),
    .out_1(r1_wout), .out_2(r2_wout), .out_3(r3_wout), .out_4(r4_wout)
);
A_y_error_correction result_calculation (
    .r1_x(r1_xout), .r2_x(r2_xout), .r3_x(r3_xout), .r4_x(r4_xout),
    .r1_w(r1_wout), .r2_w(r2_wout), .r3_w(r3_wout), .r4_w(r4_wout),
    .r2_ec(r2_err_val), .r3_ec(r3_err_val),
    .r1_y(r1_res), .r2_y(r2_res)
);

endmodule