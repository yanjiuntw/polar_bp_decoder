module test;
    reg  [19:0] x;
    reg  [19:0] y;
    wire [19:0] o;

    add f(
        .x(x),
        .y(y),
        .o(o)
    );

    initial begin
        #10
        x <= 20'b0_0000000_000000000000;
        y <= 20'b0_0000001_000000000000;
        #10
        $display("out=%x",o);
        #10
        $finish;
    end
endmodule