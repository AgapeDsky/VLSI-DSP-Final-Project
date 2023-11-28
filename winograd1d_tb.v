module winograd1d_tb();

reg signed [31:0] r1_x, r2_x, r3_x, r4_x;
reg signed [31:0] r1_w, r2_w, r3_w;
wire signed [31:0] r1_res, r2_res;

winograd1d DUT4
(
    r1_x, r2_x, r3_x, r4_x,
    r1_w, r2_w, r3_w,
    r1_res, r2_res
);

initial begin
	#60;
    r1_w <= 0;
    r2_w <= 1;
    r3_w <= 2;

    forever begin
        #20;
        r1_w <= r1_w + 2;
        r2_w <= r2_w + 2;
        r3_w <= r3_w + 4;
    end
end

initial begin
	#60;
    r1_x <= 3;
    r2_x <= 1;
    r3_x <= 0;
    r4_x <= 3;

    forever begin
        #20;
        r1_x <= r1_x - 1;
        r2_x <= r2_x - 1;
        r3_x <= r3_x - 1;
        r4_x <= r4_x - 1;
    end
end

endmodule


module winograd1d_error_correction_tb();

reg signed [31:0] r1_x, r2_x, r3_x, r4_x;
reg signed [31:0] r1_w, r2_w, r3_w;
wire signed [31:0] r1_res, r2_res;

winograd1d_error_correction DUT5
(
    r1_x, r2_x, r3_x, r4_x,
    r1_w, r2_w, r3_w,
    r1_res, r2_res
);

initial begin
	#60;
    r1_w <= 0;
    r2_w <= 1;
    r3_w <= 2;

    forever begin
        #20;
        r1_w <= r1_w + 2;
        r2_w <= r2_w + 2;
        r3_w <= r3_w + 4;
    end
end

initial begin
	#60;
    r1_x <= 3;
    r2_x <= 1;
    r3_x <= 0;
    r4_x <= 3;

    forever begin
        #20;
        r1_x <= r1_x - 1;
        r2_x <= r2_x - 1;
        r3_x <= r3_x - 1;
        r4_x <= r4_x - 1;
    end
end

endmodule