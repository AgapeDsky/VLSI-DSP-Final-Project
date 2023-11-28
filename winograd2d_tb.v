module winograd2d_tb();

// TEST SIGNALS
reg clk, rst;
reg signed [31:0] r1_x, r2_x, r3_x, r4_x;
reg signed [31:0] r1_w, r2_w, r3_w;
wire signed [31:0] r1_res, r2_res;

// PORT MAP
winograd2d DUT2
(
    clk,
    rst,
    r1_x, r2_x, r3_x, r4_x,
    r1_w, r2_w, r3_w,
    r1_res, r2_res
);

initial begin
    rst <= 0;
    #60;
    rst <= 1;
end

initial begin
	#60;
    r1_w <= -0;
    r2_w <= -2;
    r3_w <= -4;

    #20;
    r1_w <= r1_w - 2;
    r2_w <= r2_w - 2;
    r3_w <= r3_w - 4;

    #20;
    r1_w <= r1_w - 2;
    r2_w <= r2_w - 2;
    r3_w <= r3_w - 4;

    #20;

    #20;
    r1_w <= -0;
    r2_w <= -2;
    r3_w <= -4;

    #20;
    r1_w <= r1_w - 2;
    r2_w <= r2_w - 2;
    r3_w <= r3_w - 4;

    #20;
    r1_w <= r1_w - 2;
    r2_w <= r2_w - 2;
    r3_w <= r3_w - 4;
end

initial begin
	#60;
    r1_x <= 3;
    r2_x <= 1;
    r3_x <= 5;
    r4_x <= 3;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;

    #20;
    r1_x <= -5;
    r2_x <= -3;
    r3_x <= -2;
    r4_x <= 2;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;
end


initial begin
    clk <= 0;
    forever begin
        #10;
        clk <= ~clk;
    end
end

endmodule


// Optimized Version
module winograd2d_optimized_tb();

// TEST SIGNALS
reg clk, rst;
reg signed [31:0] r1_x, r2_x, r3_x, r4_x;
reg signed [31:0] r1_w, r2_w, r3_w;
wire signed [31:0] r1_res, r2_res;

// PORT MAP
winograd2d_optimized DUT3
(
    clk,
    rst,
    r1_x, r2_x, r3_x, r4_x,
    r1_w, r2_w, r3_w,
    r1_res, r2_res
);

initial begin
    rst <= 0;
    #60;
    rst <= 1;
end

initial begin
	#60;
    r1_w <= -0;
    r2_w <= -2;
    r3_w <= -4;

    #20;
    r1_w <= r1_w - 2;
    r2_w <= r2_w - 2;
    r3_w <= r3_w - 4;

    #20;
    r1_w <= r1_w - 2;
    r2_w <= r2_w - 2;
    r3_w <= r3_w - 4;
end

initial begin
	#60;
    r1_x <= 3;
    r2_x <= 1;
    r3_x <= 5;
    r4_x <= 3;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;
end


initial begin
    clk <= 0;
    forever begin
        #10;
        clk <= ~clk;
    end
end

endmodule


// Optimized Version with error correction
module winograd2d_optimized_error_correction_tb();

// TEST SIGNALS
reg clk, rst;
reg signed [31:0] r1_x, r2_x, r3_x, r4_x;
reg signed [31:0] r1_w, r2_w, r3_w;
wire signed [31:0] r1_res, r2_res;

// PORT MAP
winograd2d_optimized_error_correction DUT6
(
    clk,
    rst,
    r1_x, r2_x, r3_x, r4_x,
    r1_w, r2_w, r3_w,
    r1_res, r2_res
);

initial begin
    rst <= 0;
    #60;
    rst <= 1;
end

initial begin
	#60;
    r1_w <= -0;
    r2_w <= -2;
    r3_w <= -4;

    #20;
    r1_w <= r1_w - 2;
    r2_w <= r2_w - 2;
    r3_w <= r3_w - 4;

    #20;
    r1_w <= r1_w - 2;
    r2_w <= r2_w - 2;
    r3_w <= r3_w - 4;
end

initial begin
	#60;
    r1_x <= 3;
    r2_x <= 1;
    r3_x <= 5;
    r4_x <= 3;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;

    #20;
    r1_x <= r1_x + 1;
    r2_x <= r2_x + 1;
    r3_x <= r3_x + 1;
    r4_x <= r4_x + 1;
end


initial begin
    clk <= 0;
    forever begin
        #10;
        clk <= ~clk;
    end
end

endmodule