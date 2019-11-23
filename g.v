`timescale 1ns/10ps
module g #
(
    parameter integer SIZE = 20,
    //[1][7][12] = [s][d][f]
    parameter [SIZE - 2:0] MUL = 19'b0_0000000_111100000000 
)
(
    input  [SIZE - 1:0] x,
    input  [SIZE - 1:0] y,
    output [SIZE - 1:0] o
);

    reg x_s, y_s;
    reg [SIZE * 2 - 3:0] x_n, y_n, min, tmp;

    reg o_s;
    reg [SIZE - 2:0]o_n;

    assign o = {o_s, o_n};

    always@(*)begin
        x_s = x[SIZE - 1];
        x_n = {19'd0, x[SIZE - 2:0]};
        y_s = y[19];
        y_n = {19'd0, y[SIZE - 2:0]};

        o_s = x_s ^ y_s;
        min = (x_n > y_n)?y_n:x_n;
        tmp = min * MUL;
        o_n = tmp[30:12];
    end

endmodule
