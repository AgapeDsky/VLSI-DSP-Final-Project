module A_y
(
    input signed [31:0] r1_x, r2_x, r3_x, r4_x,
    input signed [31:0] r1_w, r2_w, r3_w, r4_w,
    output signed [31:0] r1_y, r2_y
);

// INTERNAL
wire signed [31:0] r1_xw, r2_xw, r3_xw, r4_xw;
assign r1_xw = r1_x * r1_w;
assign r2_xw = r2_x * r2_w;
assign r3_xw = r3_x * r3_w;
assign r4_xw = r4_x * r4_w;

// OUTPUT
assign r1_y = r1_xw + r2_xw + r3_xw;
assign r2_y = r2_xw - r3_xw - r4_xw;

endmodule

module A_y_optimized
(
    input clk,
    input rst,
    input signed [31:0] r1_x, r2_x, r3_x, r4_x,
    input signed [31:0] r1_w, r2_w, r3_w, r4_w,
    output signed [31:0] r1_y_d1, r2_y_d1
);

// INTERNAL
wire signed [31:0] r1_x_d1, r2_x_d1, r3_x_d1, r4_x_d1;
wire signed [31:0] r1_w_d1, r2_w_d1, r3_w_d1, r4_w_d1;
wire signed [31:0] r1_xw, r2_xw, r3_xw, r4_xw;
wire signed [31:0] r1_xw_d1, r2_xw_d1, r3_xw_d1, r4_xw_d1;
wire signed [31:0] r1_y, r2_y;

// PIPELINE REGISTERS
// INPUTS
delay32b x1_delay (
    .clk(clk),
    .rst(rst),
    .in(r1_x),
    .out(r1_x_d1)
);
delay32b x2_delay (
    .clk(clk),
    .rst(rst),
    .in(r2_x),
    .out(r2_x_d1)
);
delay32b x3_delay (
    .clk(clk),
    .rst(rst),
    .in(r3_x),
    .out(r3_x_d1)
);
delay32b x4_delay (
    .clk(clk),
    .rst(rst),
    .in(r4_x),
    .out(r4_x_d1)
);
delay32b w1_delay (
    .clk(clk),
    .rst(rst),
    .in(r1_w),
    .out(r1_w_d1)
);
delay32b w2_delay (
    .clk(clk),
    .rst(rst),
    .in(r2_w),
    .out(r2_w_d1)
);
delay32b w3_delay (
    .clk(clk),
    .rst(rst),
    .in(r3_w),
    .out(r3_w_d1)
);
delay32b w4_delay (
    .clk(clk),
    .rst(rst),
    .in(r4_w),
    .out(r4_w_d1)
);
// TRANSFORM MULTIPLICATION OUT
delay32b r1_xw_delay (
    .clk(clk),
    .rst(rst),
    .in(r1_xw),
    .out(r1_xw_d1)
);
delay32b r2_xw_delay (
    .clk(clk),
    .rst(rst),
    .in(r2_xw),
    .out(r2_xw_d1)
);
delay32b r3_xw_delay (
    .clk(clk),
    .rst(rst),
    .in(r3_xw),
    .out(r3_xw_d1)
);
delay32b r4_xw_delay (
    .clk(clk),
    .rst(rst),
    .in(r4_xw),
    .out(r4_xw_d1)
);
// TRANSFORM RESULT
delay32b r1_y_delay (
    .clk(clk),
    .rst(rst),
    .in(r1_y),
    .out(r1_y_d1)
);
delay32b r2_y_delay (
    .clk(clk),
    .rst(rst),
    .in(r2_y),
    .out(r2_y_d1)
);
assign r1_xw = r1_x_d1 * r1_w_d1;
assign r2_xw = r2_x_d1 * r2_w_d1;
assign r3_xw = r3_x_d1 * r3_w_d1;
assign r4_xw = r4_x_d1 * r4_w_d1;

// OUTPUT
assign r1_y = r1_xw_d1 + r2_xw_d1 + r3_xw_d1;
assign r2_y = r2_xw_d1 - r3_xw_d1 - r4_xw_d1;

endmodule

module A_y_optimized_error_correction
(
    input clk,
    input rst,
    input signed [31:0] r1_x, r2_x, r3_x, r4_x,
    input signed [31:0] r1_w, r2_w, r3_w, r4_w,
    output signed [31:0] r1_y_d1, r2_y_d1
);

// INTERNAL
wire signed [31:0] r1_x_d1, r2_x_d1, r3_x_d1, r4_x_d1;
wire signed [31:0] r1_w_d1, r2_w_d1, r3_w_d1, r4_w_d1;
wire signed [31:0] r1_xw, r2_xw, r3_xw, r4_xw;
wire signed [31:0] r1_xw_d1, r2_xw_d1, r3_xw_d1, r4_xw_d1;
wire signed [31:0] r1_xw_corrected, r2_xw_corrected, r3_xw_corrected, r4_xw_corrected;
wire signed [31:0] r1_y, r2_y;

wire r2_err_sel, r3_err_sel;
wire signed [31:0] r2_err_val, r3_err_val;
wire signed [31:0] r2_x_d1_s1 = r2_x_d1 >>> 1;
wire signed [31:0] r3_x_d1_s1 = r3_x_d1 >>> 1;

assign r2_err_sel = r2_w_d1[0];
assign r2_err_val = (r2_err_sel == 1'b1) ? r2_x_d1_s1 : 32'h0000;

assign r3_err_sel = r3_w_d1[0];
assign r3_err_val = (r3_err_sel == 1'b1) ? r3_x_d1_s1 : 32'h0000;

// PIPELINE REGISTERS
// INPUTS
delay32b x1_delay (
    .clk(clk),
    .rst(rst),
    .in(r1_x),
    .out(r1_x_d1)
);
delay32b x2_delay (
    .clk(clk),
    .rst(rst),
    .in(r2_x),
    .out(r2_x_d1)
);
delay32b x3_delay (
    .clk(clk),
    .rst(rst),
    .in(r3_x),
    .out(r3_x_d1)
);
delay32b x4_delay (
    .clk(clk),
    .rst(rst),
    .in(r4_x),
    .out(r4_x_d1)
);
delay32b w1_delay (
    .clk(clk),
    .rst(rst),
    .in(r1_w),
    .out(r1_w_d1)
);
delay32b w2_delay (
    .clk(clk),
    .rst(rst),
    .in(r2_w),
    .out(r2_w_d1)
);
delay32b w3_delay (
    .clk(clk),
    .rst(rst),
    .in(r3_w),
    .out(r3_w_d1)
);
delay32b w4_delay (
    .clk(clk),
    .rst(rst),
    .in(r4_w),
    .out(r4_w_d1)
);
// TRANSFORM MULTIPLICATION OUT
delay32b r1_xw_delay (
    .clk(clk),
    .rst(rst),
    .in(r1_xw),
    .out(r1_xw_d1)
);
delay32b r2_xw_delay (
    .clk(clk),
    .rst(rst),
    .in(r2_xw),
    .out(r2_xw_d1)
);
delay32b r3_xw_delay (
    .clk(clk),
    .rst(rst),
    .in(r3_xw),
    .out(r3_xw_d1)
);
delay32b r4_xw_delay (
    .clk(clk),
    .rst(rst),
    .in(r4_xw),
    .out(r4_xw_d1)
);
// ERROR CORRECTION OUT
delay32b r2_error_correction (
    .clk(clk),
    .rst(rst),
    .in(r2_err_val),
    .out(r2_err_val_d1)
);
delay32b r3_error_correction (
    .clk(clk),
    .rst(rst),
    .in(r3_err_val),
    .out(r3_err_val_d1)
);
// TRANSFORM PRE RESULT
delay32b r1_pre_result (
    .clk(clk),
    .rst(rst),
    .in(r1_xw_d1),
    .out(r1_xw_corrected)
);
delay32b r2_pre_result (
    .clk(clk),
    .rst(rst),
    .in(r2_xw_d1 + r2_err_val_d1),
    .out(r2_xw_corrected)
);
delay32b r3_pre_result (
    .clk(clk),
    .rst(rst),
    .in(r3_xw_d1 + r3_err_val_d1),
    .out(r3_xw_corrected)
);
delay32b r4_pre_result (
    .clk(clk),
    .rst(rst),
    .in(r4_xw_d1),
    .out(r4_xw_corrected)
);
// FINAL TRANSFORM RESULT
delay32b r1_y_delay (
    .clk(clk),
    .rst(rst),
    .in(r1_y),
    .out(r1_y_d1)
);
delay32b r2_y_delay (
    .clk(clk),
    .rst(rst),
    .in(r2_y),
    .out(r2_y_d1)
);

assign r1_xw = r1_x_d1 * r1_w_d1;
assign r2_xw = r2_x_d1 * r2_w_d1;
assign r3_xw = r3_x_d1 * r3_w_d1;
assign r4_xw = r4_x_d1 * r4_w_d1;

// OUTPUT
assign r1_y = r1_xw_corrected + r2_xw_corrected + r3_xw_corrected;
assign r2_y = r2_xw_corrected - r3_xw_corrected - r4_xw_corrected;

endmodule

// module Ay_A_single
// (
//     input clk,
//     input rst,
//     input signed [31:0] in,
//     output signed [31:0] out
// );

// // INTERNAL
// wire signed [31:0] in_d1, in_d2;
// wire signed [31:0] pre_out_1, pre_out_2;

// // STATE VARIABLE
// reg [2:0] state;
// wire [2:0] next_state;

// // PORT MAP
// delay32b R1(
//     .clk(clk),
//     .rst(rst),
//     .in(in),
//     .out(in_d1)
// );
// delay32b R2(
//     .clk(clk),
//     .rst(rst),
//     .in(in_d1),
//     .out(in_d2)
// );

// // COMPUTATION
// assign pre_out_1 = in + in_d1 + in_d2;
// assign pre_out_2 = in_d2 - in_d1 - in;

// // OUTPUT BASED ON STATE
// assign out = (state == 3'b010) ? pre_out_1 :
//              (state == 3'b011) ? pre_out_2 : 32'h0000;

// // NEXT STATE GENERATOR
// assign next_state = (state == 3'b101) ? 0 : state + 3'b001;
// always @(posedge(clk)) begin
//     if (!rst) begin
//         state <= 3'b000;
//     end
//     else begin
//         state <= next_state;
//     end
// end

// endmodule

// 4 clocks per process
module Ay_A_single
(
    input clk,
    input rst,
    input signed [31:0] in,
    output signed [31:0] out
);

// INTERNAL
wire signed [31:0] in_d1, in_d2;
wire signed [31:0] pre_out_1, pre_out_2;

// STATE VARIABLE
reg [2:0] state;
wire [2:0] next_state;

// PORT MAP
delay32b R1(
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(in_d1)
);
delay32b R2(
    .clk(clk),
    .rst(rst),
    .in(in_d1),
    .out(in_d2)
);

// COMPUTATION
assign pre_out_1 = in + in_d1 + in_d2;
assign pre_out_2 = in_d2 - in_d1 - in;

// OUTPUT BASED ON STATE
assign out = (state == 3'b000) ? pre_out_1 :
             (state == 3'b001) ? pre_out_2 : 32'h0000;

// NEXT STATE GENERATOR
assign next_state = (state == 3'b011) ? 0 : state + 3'b001;
always @(posedge(clk)) begin
    if (!rst) begin
        state <= 3'b000;
    end
    else begin
        state <= next_state;
    end
end

endmodule

// optimized process of Ay_A_single
// synchronized with A_y_optimized (different initial state)
module Ay_A_single_optimized
(
    input clk,
    input rst,
    input signed [31:0] in,
    output signed [31:0] out
);

// INTERNAL
wire signed [31:0] in_d1, in_d2;
wire signed [31:0] pre_out_1, pre_out_2;

// STATE VARIABLE
reg [2:0] state;
wire [2:0] next_state;

// PORT MAP
delay32b R1(
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(in_d1)
);
delay32b R2(
    .clk(clk),
    .rst(rst),
    .in(in_d1),
    .out(in_d2)
);

// COMPUTATION
assign pre_out_1 = in + in_d1 + in_d2;
assign pre_out_2 = in_d2 - in_d1 - in;

// OUTPUT BASED ON STATE
assign out = (state == 3'b000) ? pre_out_1 :
             (state == 3'b001) ? pre_out_2 : 32'h0000;

// NEXT STATE GENERATOR
assign next_state = (state == 3'b011) ? 0 : state + 3'b001;
always @(posedge(clk)) begin
    if (!rst) begin
        state <= 3'b001;
    end
    else begin
        state <= next_state;
    end
end

endmodule

// optimized process of Ay_A_single with error correction
// synchronized with A_y_optimized (different initial state)
module Ay_A_single_optimized_error_correction
(
    input clk,
    input rst,
    input signed [31:0] in,
    output signed [31:0] out
);

// INTERNAL
wire signed [31:0] in_d1, in_d2;
wire signed [31:0] pre_out_1, pre_out_2;

// STATE VARIABLE
reg [2:0] state;
wire [2:0] next_state;

// PORT MAP
delay32b R1(
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(in_d1)
);
delay32b R2(
    .clk(clk),
    .rst(rst),
    .in(in_d1),
    .out(in_d2)
);

// COMPUTATION
assign pre_out_1 = in + in_d1 + in_d2;
assign pre_out_2 = in_d2 - in_d1 - in;

// OUTPUT BASED ON STATE
assign out = (state == 3'b000) ? pre_out_1 :
             (state == 3'b001) ? pre_out_2 : 32'h0000;

// NEXT STATE GENERATOR
assign next_state = (state == 3'b011) ? 0 : state + 3'b001;
always @(posedge(clk)) begin
    if (!rst) begin
        state <= 3'b000;
    end
    else begin
        state <= next_state;
    end
end

endmodule

module Ay_A_2
(
    input clk,
    input rst,
    input signed [31:0] in_1, in_2,
    output signed [31:0] out_1, out_2
);

// PORT MAP
Ay_A_single row1 (
    .clk(clk), .rst(rst),
    .in(in_1),
    .out(out_1)
);
Ay_A_single row2 (
    .clk(clk), .rst(rst),
    .in(in_2),
    .out(out_2)
);

endmodule

module Ay_A_optimized_2
(
    input clk,
    input rst,
    input signed [31:0] in_1, in_2,
    output signed [31:0] out_1, out_2
);

// PORT MAP
Ay_A_single_optimized row1 (
    .clk(clk), .rst(rst),
    .in(in_1),
    .out(out_1)
);
Ay_A_single_optimized row2 (
    .clk(clk), .rst(rst),
    .in(in_2),
    .out(out_2)
);

endmodule

module Ay_A_optimized_error_correction_2
(
    input clk,
    input rst,
    input signed [31:0] in_1, in_2,
    output signed [31:0] out_1, out_2
);

// PORT MAP
Ay_A_single_optimized_error_correction row1 (
    .clk(clk), .rst(rst),
    .in(in_1),
    .out(out_1)
);
Ay_A_single_optimized_error_correction row2 (
    .clk(clk), .rst(rst),
    .in(in_2),
    .out(out_2)
);

endmodule

module top_A_y_A
(
    input clk,
    input rst,
    input signed [31:0] x1, x2, x3, x4,
    input signed [31:0] w1, w2, w3, w4,
    output signed [31:0] res1, res2
);

// INTERNAL
wire signed [31:0] y_tf_out_1, y_tf_out_2;


// PORT MAP
A_y multiplied_tf (
    .r1_x(x1), .r2_x(x2), .r3_x(x3), .r4_x(x4),
    .r1_w(w1), .r2_w(w2), .r3_w(w3), .r4_w(w4),
    .r1_y(y_tf_out_1), .r2_y(y_tf_out_2)
);
Ay_A_2 finalee_tf (
    .clk(clk),
    .rst(rst),
    .in_1(y_tf_out_1),
    .in_2(y_tf_out_2),
    .out_1(res1),
    .out_2(res2)
);

endmodule

module top_A_y_A_optimized
(
    input clk,
    input rst,
    input signed [31:0] x1, x2, x3, x4,
    input signed [31:0] w1, w2, w3, w4,
    output signed [31:0] res1, res2
);

// INTERNAL
wire signed [31:0] y_tf_out_1, y_tf_out_2;

// PORT MAP
A_y_optimized multiplied_tf (
    .clk(clk),
    .rst(rst),
    .r1_x(x1), .r2_x(x2), .r3_x(x3), .r4_x(x4),
    .r1_w(w1), .r2_w(w2), .r3_w(w3), .r4_w(w4),
    .r1_y_d1(y_tf_out_1), .r2_y_d1(y_tf_out_2)
);
Ay_A_optimized_2 finalee_tf (
    .clk(clk),
    .rst(rst),
    .in_1(y_tf_out_1),
    .in_2(y_tf_out_2),
    .out_1(res1),
    .out_2(res2)
);

endmodule

module top_A_y_A_optimized_error_correction
(
    input clk,
    input rst,
    input signed [31:0] x1, x2, x3, x4,
    input signed [31:0] w1, w2, w3, w4,
    output signed [31:0] res1, res2
);

// INTERNAL
wire signed [31:0] y_tf_out_1, y_tf_out_2;

// PORT MAP
A_y_optimized_error_correction multiplied_tf (
    .clk(clk),
    .rst(rst),
    .r1_x(x1), .r2_x(x2), .r3_x(x3), .r4_x(x4),
    .r1_w(w1), .r2_w(w2), .r3_w(w3), .r4_w(w4),
    .r1_y_d1(y_tf_out_1), .r2_y_d1(y_tf_out_2)
);
Ay_A_optimized_error_correction_2 finalee_tf (
    .clk(clk),
    .rst(rst),
    .in_1(y_tf_out_1),
    .in_2(y_tf_out_2),
    .out_1(res1),
    .out_2(res2)
);

endmodule