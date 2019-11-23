`timescale 1ns/10ps
`include "cal1.v"
`include "cal2.v"
`define _SIZE 20
`define DECODE 0
`define ENCODE 1
`define DONE   2
module decoder # (
    parameter integer N = 8,
    parameter integer STEP = 3,
    parameter integer SIZE = `_SIZE
)
(
    input clk, 
    input rst_n,
    input en,
    input  [SIZE - 1:0] in0,
    input  [SIZE - 1:0] in1,
    input  [SIZE - 1:0] in2,
    input  [SIZE - 1:0] in3,
    input  [SIZE - 1:0] in4,
    input  [SIZE - 1:0] in5,
    input  [SIZE - 1:0] in6,
    input  [SIZE - 1:0] in7,
    output done,
    output [SIZE - 1:0] out0,
    output [SIZE - 1:0] out1,
    output [SIZE - 1:0] out2,
    output [SIZE - 1:0] out3,
    output [SIZE - 1:0] out4,
    output [SIZE - 1:0] out5,
    output [SIZE - 1:0] out6,
    output [SIZE - 1:0] out7 
);
    integer x, y, z;
    genvar i,j;

    reg [SIZE - 1:0] tmp [N - 1:0][STEP:0][1:0];
    wire [SIZE - 1:0] w [N - 1:0][STEP - 1:0][1:0];
    reg [3:0] stage;
    reg [3:0] counter;
    reg done;

    always@(*)begin
        tmp[0][0][0] = in0;
        tmp[1][0][0] = in1;
        tmp[2][0][0] = in2;
        tmp[3][0][0] = in3;
        tmp[4][0][0] = in4;
        tmp[5][0][0] = in5;
        tmp[6][0][0] = in6;
        tmp[7][0][0] = in7;
    end
    assign out0 = tmp[0][STEP][0];
    assign out1 = tmp[1][STEP][0];
    assign out2 = tmp[2][STEP][0];
    assign out3 = tmp[3][STEP][0];
    assign out4 = tmp[4][STEP][0];
    assign out5 = tmp[5][STEP][0];
    assign out6 = tmp[6][STEP][0];
    assign out7 = tmp[7][STEP][0];

        /*
    initial begin
        #20000
        
        for (y = 0; y < STEP; y = y + 1)begin
            for (x = 0; x < N/2; x=x+1)begin
                $display("tmp[%d*2][%d][0]=%x\n",x,y,tmp[x*2][y][0]);
                $display("tmp[%d+4][2-%d][1]=%x\n",x,y,tmp[x+4][2-y][1]);
                $display("tmp[%d*2+1][%d][0]=%x\n",x,y,tmp[x*2+1][y][0]);
                $display("w[%d][%d][0]=%x\n\n",x,y,w[x][y][0]);
                $display("tmp[%d][%d+1][0]=%x\n\n",x,y,tmp[x][y+1][0]);
            end
            for (x = 0; x < N/2; x=x+1)begin
                $display("tmp[%d][2-%d][1]=%x\n",x,y,tmp[x][2-y][1]);
                $display("tmp[%d*2][%d][0]=%x\n",x,y,tmp[x*2][y][0]);
                $display("tmp[%d*2+1][%d][0]=%x\n",x,y,tmp[x*2+1][y][0]);
                $display("w[%d+4][%d][0]=%x\n\n",x,y,w[x+4][y][0]);
                $display("tmp[%d+4][%d+1][0]=%x\n\n",x,y,tmp[x+4][y+1][0]);
            end
        end
        for (y = 0; y < STEP; y = y + 1)begin
            $display("-------------------------------%d---------------",y);
            for (x = 0; x < N/2; x=x+1)begin
                $display("tmp[%d][%d][1]=%x\n",x,y,tmp[x][y][1]);
                $display("tmp[%d+4][%d][1]=%x\n",x,y,tmp[x+4][y][1]);
                $display("tmp[%d*2+1][2-%d][0]=%x\n",x,y,tmp[x*2+1][2-y][0]);
                $display("w[%d*2][%d][1]=%x\n\n",x,y,w[x*2][y][1]);
                #5
                $display("tmp[%d*2][%d+1][1]=%x\n\n",x,y,tmp[x*2][y+1][1]);
            end
            for (x = 0; x < N/2; x=x+1)begin
                $display("tmp[%d][%d][1]=%x\n",x,y,tmp[x][y][1]);
                $display("tmp[%d*2][2-%d][0]=%x\n",x,y,tmp[x*2][2-y][0]);
                $display("tmp[%d+4][%d][1]=%x\n",x,y,tmp[x+4][y][1]);
                $display("w[%d*2+1][%d][1]=%x\n\n",x,y,w[x*2+1][y][1]);
                #5
                $display("tmp[%d*2+1][%d+1][1]=%x\n\n",x,y,tmp[x*2+1][y+1][1]);
            end
        end
    end
        */

    generate
        for(j = 0; j < STEP; j = j +1)
            for(i = 0; i < N/2; i = i + 1)begin
                cal1 l1(tmp[i*2][j][0],tmp[i+N/2][STEP-1-j][1],tmp[i*2+1][j][0],w[i][j][0]);
                cal2 l2(tmp[i][STEP-1-j][1],tmp[i*2][j][0],tmp[i*2+1][j][0],w[i+N/2][j][0]);
            end
        for(j = 0; j < STEP; j = j +1)
            for(i = 0; i < N/2; i = i + 1)begin
                cal1 r1(tmp[i][j][1],tmp[i+N/2][j][1],tmp[i*2+1][STEP-1-j][0],w[i*2][j][1]);
                cal2 r2(tmp[i][j][1],tmp[i*2][STEP-1-j][0],tmp[i+N/2][j][1],w[i*2+1][j][1]);
            end
    endgenerate

    always@(posedge clk, negedge rst_n)begin
        if(!rst_n)begin
            stage <= 4'd0;
            done <= 1'd0;
            counter <= 4'd0;
            for (x = 0; x < N; x = x + 1)
                for (y = 1; y <= STEP; y = y + 1)
                    for (z = 0; z < 2; z = z + 1)
                        tmp[x][y][z] <= `_SIZE'd0;
            tmp[0][0][1] <= 20'h7ffff;
            tmp[1][0][1] <= 20'h7ffff;
            tmp[2][0][1] <= 20'h7ffff;
            tmp[3][0][1] <= 20'h00000;
            tmp[4][0][1] <= 20'h7ffff;
            tmp[5][0][1] <= 20'h00000;
            tmp[6][0][1] <= 20'h00000;
            tmp[7][0][1] <= 20'h00000;
        end else begin
            case(stage)
            `DECODE:begin
                done <= 0;
                counter <= counter + 1;
                if (counter >= N-1)begin
                    counter <= 0;
                    stage <= `DONE;
                end else 
                    stage <= stage;

                for (y = 0; y < STEP; y = y + 1)
                    for (x = 0; x < N; x = x + 1)begin
                        tmp[x][y+1][0] <= w[x][y][0];
                    end
            end
            `ENCODE:begin
                done <= 0;
                counter <= counter + 1;
                if(counter >= N-1)begin
                    counter <= 0;
                    stage <= `DECODE;
                    //stage<=`DONE;
                end else 
                    stage <= stage;

                for (y = 0; y < STEP; y = y + 1)
                    for (x = 0; x < N; x = x + 1)begin
                        tmp[x][y+1][1] <= w[x][y][1];
                    end
            end
            default:begin
                done <= 1;
                if(en) 
                    stage <= `ENCODE;
                else 
                    stage <= stage;
            end
            endcase
        end      
    end
endmodule
