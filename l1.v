`timescale 1ns/10ps
module l1 #
(
    parameter integer SIZE = 20
)
(
    input  [SIZE - 1:0] x,
    input  [SIZE - 1:0] y,
    input  [SIZE - 1:0] z,
    output [SIZE - 1:0] o
);
    reg y_s, z_s;
    reg [SIZE - 1:0] y_n, z_n, tmp;

    reg o_s;
    reg [SIZE - 2:0] o_n;
    

    g f(
        .x(x),
        .y({o_s,o_n}),
        .o(o)
    ); 

    always@(*)begin
        y_s = y[SIZE - 1];
        y_n = {1'b0, y[SIZE - 2:0]};
        z_s = z[SIZE - 1];
        z_n = {1'b0, z[SIZE - 2:0]};

        o_n = (tmp[19])?19'b111_1111_1111_1111_1111:tmp[18:0];

        if (y_s ^ z_s)begin
            if (y_n > z_n)begin
                tmp = y_n - z_n;
                o_s = y_s;
            end else begin
                tmp = z_n - y_n;
                o_s = z_s;
            end
        end else begin
            o_s = y_s;
            tmp = y_n + y_n;
        end        
    end
endmodule