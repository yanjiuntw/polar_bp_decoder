module add#(
    parameter integer SIZE = 20
)
(
    input [SIZE - 1:0] x,
    input [SIZE - 1:0] y,
    output [SIZE - 1:0] o
);

    reg x_s, y_s;
    reg [SIZE - 1:0] x_n, y_n, tmp;

    reg o_s;
    reg [SIZE - 1:0] o_n;

    assign o = {o_s,o_n[SIZE - 2:0]};

    always@(*)begin
        x_s = x[SIZE - 1];
        x_n = {1'b0, x[SIZE - 2:0]};
        y_s = y[SIZE - 1];
        y_n = {1'b0, y[SIZE - 2:0]};

        o_n = (tmp[19])?19'b111_1111_1111_1111_1111:tmp[18:0];

        if(x_s ^ y_s)begin
            if(x_n > y_n)begin
                tmp = x_n - y_n;
                o_s = x_s;
            end else begin
                tmp = y_n - x_n;
                o_s = y_s;
            end
        end else begin
            o_s = x_s;
            tmp = x_n + y_n;
        end 
    end
endmodule