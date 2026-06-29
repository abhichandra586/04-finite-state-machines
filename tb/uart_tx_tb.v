`timescale 1ns/1ps

module uart_tx_tb;

reg clk;
reg reset;
reg send;
reg [7:0] data;
wire tx;
wire busy;

uart_tx uut(
    .clk(clk),
    .reset(reset),
    .send(send),
    .data(data),
    .tx(tx),
    .busy(busy)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("uart_tx.vcd");
    $dumpvars(0,uart_tx_tb);

    $monitor("Time=%0t,tx=%b,busy=%b,send=%b,data=%h",$time,tx,busy,send,data);

    reset=1; send=0; data=8'h00; #20;
    reset=0; #10;

    $display("--- Test 1: Send 0x55 (01010101) ---");
    data=8'h55; send=1; #10;
    send=0;
    @(negedge busy);
    #20;

    $display("--- Test 2: Send 0xAA (10101010) ---");
    data=8'hAA; send=1; #10;
    send=0;
    @(negedge busy);
    #20;

    $display("--- Test 3: Send 0xFF (11111111) ---");
    data=8'hFF; send=1; #10;
    send=0;
    @(negedge busy);
    #20;

    $display("--- Test 4: Send 0x00 (00000000) ---");
    data=8'h00; send=1; #10;
    send=0;
    @(negedge busy);
    #20;

    $finish;

end
endmodule