module top_B_x_B_tb();

// TEST SIGNALS
reg clk, rst;
reg signed [31:0] x1, x2, x3, x4;
wire signed [31:0] r1, r2, r3, r4;

// PORT MAP
top_B_x_B DUT2
(
    clk,
    rst,
    x1, x2, x3, x4,
    r1, r2, r3, r4
);

initial begin
	rst <= 0;
	#60;
	rst <= 1;

    x1 <= 0;
    x2 <= 1;
    x3 <= 2;
    x4 <= 3;

    #10;

    forever begin
        #10;
        x1 <= x1 + 1;
        x2 <= x2 + 2;
        x3 <= x3 + 3;
        x4 <= x4 + 4;
        #10;
    end
end

initial begin
    clk <= 0;
    forever begin
        #10;
        clk <= ~clk;
    end
end

endmodule