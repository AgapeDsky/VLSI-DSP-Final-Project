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
assign out = (state == 3'b010) ? pre_out_1 :
             (state == 3'b011) ? pre_out_2 : 32'h0000;

// NEXT STATE GENERATOR
assign next_state = (state == 3'b101) ? 0 : state + 3'b001;
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