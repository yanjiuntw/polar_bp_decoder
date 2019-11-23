`timescale 1ns/10ps
`include "cal2.v"
module test;
    reg [19:0] x;
    reg [19:0] y;
    reg [19:0] z;
    wire [19:0] o;

    cal2 top(
        .x(x),
        .y(y),
        .z(z),
        .o(o)
    );
    initial begin
        #10 x <= 20'b0_0000000_000000000000;
            y <= 20'b0_0000001_000000000000;
            z <= ~20'b0_0000001_000000000000+1;
        #10 $display("out=%x",o);
        #10 $finish;
    end
endmodule
