`timescale 1ns/10ps

module g #(
    parameter integer SIZE = 20,
    //[1][7][12]
    parameter integer MUL = 20'h00f00
)(
    input  [SIZE - 1:0] x,
    input  [SIZE - 1:0] y,
    output [SIZE - 1:0] o
);
    wire x_s = x[SIZE-1];
    wire y_s = y[SIZE-1];
    wire [SIZE - 1:0] x_n = (x_s)?(~x + 1):(x);
    wire [SIZE - 1:0] y_n = (y_s)?(~y + 1):(y);

    wire [SIZE * 2 - 1:0] min = (x_n >= y_n)?{20'd0, y_n}:{20'd0, x_n};

    wire [SIZE * 2 - 1:0] muled = min * MUL;

    wire [SIZE - 1:0] pre_o = muled[31:12];

    assign o = (x_s ^ y_s)?(~pre_o + 1):(pre_o);
endmodule