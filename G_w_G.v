module G_w
(
    input signed [31:0] in_1, in_2, in_3,
    output signed [31:0] out_1, out_2, out_3, out_4
);

// INTERNAL
wire signed [31:0] sum_13;
wire signed [31:0] sum_123;
wire signed [31:0] sum_13_min_2;

assign sum_13 = in_1 + in_3;
assign sum_123 = sum_13 + in_2;
assign sum_13_min_2 = sum_13 - in_2;

// OUTPUTS
assign out_1 = in_1;
assign out_2 = sum_123 >>> 1;
assign out_3 = sum_13_min_2 >>> 1;
assign out_4 = in_3;

endmodule

module delay32b
(
    input clk,
    input rst,
    input [31:0] in,
    output reg [31:0] out
);

always @(posedge(clk)) begin
    if (!rst) begin
        out <= 32'b0;
    end
    else begin
        out <= in;
    end
end
endmodule

module Gw_G_single
(
    input clk,
    input rst,
    input signed [31:0] in,
    output signed [31:0] out
);

// INTERNAL
wire signed [31:0] in_d1, in_d2, in_d3;
wire signed [31:0] pre_out_1, pre_out_2, pre_out_3, pre_out_4;
wire signed [31:0] sel_R1, sel_R2, sel_R3;

// STATE VARIABLE
reg [2:0] state;
wire [2:0] next_state;

// PORT MAP
delay32b R1(
    .clk(clk),
    .rst(rst),
    .in(sel_R1),
    .out(in_d1)
);
delay32b R2(
    .clk(clk),
    .rst(rst),
    .in(sel_R2),
    .out(in_d2)
);
delay32b R3(
    .clk(clk),
    .rst(rst),
    .in(sel_R3),
    .out(in_d3)
);

// REGISTER INPUT SWITCH
assign sel_R1 = (state == 3'b011) ? in_d3 : in;
assign sel_R2 = in_d1;
assign sel_R3 = in_d2;

// COMPUTATION
assign pre_out_1 = in_d2;
assign pre_out_2 = (in_d1 + in_d2 + in_d3) >>> 1;
assign pre_out_3 = (in_d1 + in_d2 - in_d3) >>> 1;
assign pre_out_4 = in_d3;

// OUTPUT BASED ON STATE
assign out = (state == 3'b010) ? pre_out_1 :
             (state == 3'b011) ? pre_out_2 :
             (state == 3'b100) ? pre_out_3 :
             (state == 3'b101) ? pre_out_4 : 32'h0000;

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

module Gw_G_4
(
    input clk,
    input rst,
    input signed [31:0] in_1, in_2, in_3, in_4,
    output signed [31:0] out_1, out_2, out_3, out_4
);

// PORT MAP
Gw_G_single row1 (
    .clk(clk), .rst(rst),
    .in(in_1),
    .out(out_1)
);
Gw_G_single row2 (
    .clk(clk), .rst(rst),
    .in(in_2),
    .out(out_2)
);
Gw_G_single row3 (
    .clk(clk), .rst(rst),
    .in(in_3),
    .out(out_3)
);
Gw_G_single row4 (
    .clk(clk), .rst(rst),
    .in(in_4),
    .out(out_4)
);

endmodule

module top_G_w_G
(
    input clk,
    input rst,
    input signed [31:0] w1, w2, w3,
    output signed [31:0] r1, r2, r3, r4
);

// INTERNAL
wire signed [31:0] weight_tf_out_1, weight_tf_out_2, weight_tf_out_3, weight_tf_out_4;


// PORT MAP
G_w weight_tf (
    .in_1(w1),
    .in_2(w2),
    .in_3(w3),
    .out_1(weight_tf_out_1),
    .out_2(weight_tf_out_2),
    .out_3(weight_tf_out_3),
    .out_4(weight_tf_out_4)
);
Gw_G_4 final_tf (
    .clk(clk),
    .rst(rst),
    .in_1(weight_tf_out_1),
    .in_2(weight_tf_out_2),
    .in_3(weight_tf_out_3),
    .in_4(weight_tf_out_4),
    .out_1(r1),
    .out_2(r2),
    .out_3(r3),
    .out_4(r4)
);

endmodule