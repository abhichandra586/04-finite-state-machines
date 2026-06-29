`timescale 1ns/1ps

module spi_master_tb;

reg clk;
reg reset;
reg start;
reg [7:0] mosi_data;
reg miso;
wire mosi;
wire sclk;
wire cs;
wire [7:0] miso_data;
wire done;

spi_master uut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .mosi_data(mosi_data),
    .mosi(mosi),
    .sclk(sclk),
    .cs(cs),
    .miso_data(miso_data),
    .miso(miso),
    .done(done)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("spi_master.vcd");
    $dumpvars(0,spi_master_tb);

    $monitor("Time=%0t,cs=%b,sclk=%b,mosi=%b,miso=%b,miso_data=%h,done=%b",$time,cs,sclk,mosi,miso,miso_data,done);

    reset=1; start=0; mosi_data=8'h00; miso=1'b0; #20;
    reset=0; #10;

    $display("--- Test 1: Send 0xA5, Receive 0x5A ---");
    mosi_data=8'hA5; miso=1'b0; start=1; #10;
    start=0;
    miso=1'b0;
    @(posedge done);
    #20;

    $display("--- Test 2: Send 0xFF, Receive 0xFF ---");
    mosi_data=8'hFF; miso=1'b1; start=1; #10;
    start=0;
    @(posedge done);
    #20;

    $display("--- Test 3: Send 0x00, Receive 0x00 ---");
    mosi_data=8'h00; miso=1'b0; start=1; #10;
    start=0;
    @(posedge done);
    #20;

    $finish;

end
endmodule