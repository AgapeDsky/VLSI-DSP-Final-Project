module B_x
(
    input signed [31:0] in_1, in_2, in_3, in_4,
    output signed [31:0] out_1, out_2, out_3, out_4
);

// OUTPUTS
assign out_1 = in_1 - in_3;
assign out_2 = in_2 + in_3;
assign out_3 = in_3 - in_2;
assign out_4 = in_2 - in_4;

endmodule

module Bx_B_single
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
delay32b D1(
    .clk(clk),
    .rst(rst),
    .in(sel_R1),
    .out(in_d1)
);
delay32b D2(
    .clk(clk),
    .rst(rst),
    .in(sel_R2),
    .out(in_d2)
);
delay32b D3(
    .clk(clk),
    .rst(rst),
    .in(sel_R3),
    .out(in_d3)
);

// REGISTER INPUT SWITCH
assign sel_R1 = in;
assign sel_R2 = (state == 3'b100) ? in_d3 : in_d1;
assign sel_R3 = (state == 3'b100) ? in_d1 : in_d2;

// COMPUTATION
assign pre_out_1 = in_d2 - in;
assign pre_out_2 = in_d1 + in_d2;
assign pre_out_3 = in_d2 - in_d3;
assign pre_out_4 = pre_out_3;

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

module Bx_B_4
(
    input clk,
    input rst,
    input signed [31:0] in_1, in_2, in_3, in_4,
    output signed [31:0] out_1, out_2, out_3, out_4
);

// PORT MAP
Bx_B_single row_1 (
    .clk(clk), .rst(rst),
    .in(in_1),
    .out(out_1)
);
Bx_B_single row_2 (
    .clk(clk), .rst(rst),
    .in(in_2),
    .out(out_2)
);
Bx_B_single row_3 (
    .clk(clk), .rst(rst),
    .in(in_3),
    .out(out_3)
);
Bx_B_single row_4 (
    .clk(clk), .rst(rst),
    .in(in_4),
    .out(out_4)
);

endmodule

module top_B_x_B
(
    input clk,
    input rst,
    input signed [31:0] x1, x2, x3, x4,
    output signed [31:0] r1, r2, r3, r4
);

// INTERNAL
wire signed [31:0] input_tf_out_1, input_tf_out_2, input_tf_out_3, input_tf_out_4;


// PORT MAP
B_x input_tf (
    .in_1(x1),
    .in_2(x2),
    .in_3(x3),
    .in_4(x4),
    .out_1(input_tf_out_1),
    .out_2(input_tf_out_2),
    .out_3(input_tf_out_3),
    .out_4(input_tf_out_4)
);
Bx_B_4 finale_tf (
    .clk(clk),
    .rst(rst),
    .in_1(input_tf_out_1),
    .in_2(input_tf_out_2),
    .in_3(input_tf_out_3),
    .in_4(input_tf_out_4),
    .out_1(r1),
    .out_2(r2),
    .out_3(r3),
    .out_4(r4)
);

endmodule