`timescale 1ns/10ps
`include "cal1.v"
module test;
    reg [19:0] x;
    reg [19:0] y;
    reg [19:0] z;
    wire [19:0] o;

    cal1 top(
        .x(x),
        .y(y),
        .z(z),
        .o(o)
    );
    initial begin
        #10 x <= 20'h01000;
            y <= 20'h0;
            z <= 20'hff000;
        #10 $display("out=%x",o);
        #10 $finish;
    end
endmodule