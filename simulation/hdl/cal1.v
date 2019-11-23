`timescale 1ns/10ps
`include "g.v"
module cal1 # (
    parameter integer SIZE = 20
)
(
    input [SIZE - 1:0] x,
    input [SIZE - 1:0] y,
    input [SIZE - 1:0] z,
    output [SIZE - 1:0] o
);
    wire [SIZE:0] tmp = {1'b0,y} + {1'b0,z};
    wire [SIZE - 1:0] add = (y[SIZE-1]^z[SIZE-1])?tmp[SIZE-1:0]:
                            ((!tmp[SIZE]&&tmp[SIZE-1])?20'h7ffff:
                            (tmp[SIZE]&&!tmp[SIZE-1])?20'h80000:
                            tmp[SIZE-1:0]);
    /*
    wire [SIZE - 1:0] add = (y[SIZE-1] ^ z[SIZE-1])?
                            (tmp):
                            ((tmp[SIZE-1]^y[SIZE-1])?
                            (y[SIZE-1])?
                            (20'h7ffff):
                            (20'hfffff):
                            (tmp)
                            );
                            */
    g f(
        .x(x),
        .y(add),
        .o(o)
    );
endmodule