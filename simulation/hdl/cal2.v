`timescale 1ns/10ps
`include "g.v"
module cal2 # (
    parameter integer SIZE = 20
)
(
    input [SIZE - 1:0] x,
    input [SIZE - 1:0] y,
    input [SIZE - 1:0] z,
    output [SIZE - 1:0] o
);
    wire [SIZE - 1:0] tmp;
    /*
    wire [SIZE:0] tmp = y + z;
    wire [SIZE - 1:0] add = (!tmp[SIZE]&&tmp[SIZE-1])?20'h7ffff:
                            (tmp[SIZE]&&!tmp[SIZE-1])?20'hfffff:
                            tmp;
                            */
    wire [SIZE:0]add = tmp + z;
    assign o = (tmp[SIZE-1]^z[SIZE-1])?add[SIZE-1:0]:
               ((!add[SIZE]&&add[SIZE-1])?20'h7ffff:
               (add[SIZE]&&!add[SIZE-1])?20'h80000:
               add[SIZE-1:0]);
    //assign o = tmp + z;
    g f(
        .x(x),
        .y(y),
        .o(tmp)
    );
endmodule
