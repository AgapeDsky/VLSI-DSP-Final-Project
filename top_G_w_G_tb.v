module top_G_w_G_tb();

// TEST SIGNALS
reg clk, rst;
reg signed [31:0] w1, w2, w3;
wire signed [31:0] r1, r2, r3, r4;

// PORT MAP
top_G_w_G DUT1
(
    clk,
    rst,
    w1, w2, w3,
    r1, r2, r3, r4
);

initial begin
    rst <= 0;
    #60;
    rst <= 1;
end

initial begin
	#60;
    w1 <= 0;
    w2 <= 2;
    w3 <= 4;

    #20;
    w1 <= w1 + 2;
    w2 <= w2 + 2;
    w3 <= w3 + 4;

    #20;
    w1 <= w1 + 2;
    w2 <= w2 + 2;
    w3 <= w3 + 4;
end

initial begin
    clk <= 0;
    forever begin
        #10;
        clk <= ~clk;
    end
end

endmodule