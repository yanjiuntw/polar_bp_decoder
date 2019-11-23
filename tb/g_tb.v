`timescale 1ns/10ps
`define CYCLE 10.0
module test;
    reg  [19:0] x;
    reg  [19:0] y;
    wire [19:0] o;

    g top(
        .x(x),
        .y(y),
        .o(o)
    );

    initial begin
        #10 x <= 20'b1_0000010_100000000000;
            y <= 20'b0_0000011_000000000000;
        #10 $display("out=%x",o);
        #10 $finish;
    end



endmodule
