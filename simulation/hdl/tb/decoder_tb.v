`timescale 1ns/10ps
//`include "decoder.v"
module test;
    reg clk = 0;
    reg rst = 0;
    reg [19:0]in[7:0];
    reg en;
    wire done;
    wire [19:0]out[7:0];

    decoder top(
        .clk(clk),
        .rst_n(rst),
        .en(en),
        .in0(in[0]),
        .in1(in[1]),
        .in2(in[2]),
        .in3(in[3]),
        .in4(in[4]),
        .in5(in[5]),
        .in6(in[6]),
        .in7(in[7]),
        .done(done),
        .out0(out[0]),
        .out1(out[1]),
        .out2(out[2]),
        .out3(out[3]),
        .out4(out[4]),
        .out5(out[5]),
        .out6(out[6]),
        .out7(out[7])
    );
    
    always #10 clk<=~clk;

    integer i;
    initial begin
        #5
            en <= 0;
            rst <= 1;
        #5  rst <= 0;
        #20 rst <= 1;
            in[0] <= 20'h01000;
            in[1] <= 20'hff000;
            in[2] <= 20'hff000;
            in[3] <= 20'h01000;
            in[4] <= 20'hff000;
            in[5] <= 20'h01000;
            in[6] <= 20'h01000;
            in[7] <= 20'hff000;
        @(posedge done) 
            for (i = 0; i < 8; i = i + 1)begin
                $display("out%d=%x\n",i,out[i]);
            end
            en <= 1;
        @(negedge done)
            en <= 0;
            $display();
        @(posedge done)
            for (i = 0; i < 8; i = i + 1)begin
                $display("out%d=%x\n",i,out[i]);
            end
            en<=1;
        @(negedge done)
            en <= 0;
            $display();
        @(posedge done)
            for (i = 0; i < 8; i = i + 1)begin
                $display("out%d=%x\n",i,out[i]);
            end
        #2000000 $finish;
    end
endmodule