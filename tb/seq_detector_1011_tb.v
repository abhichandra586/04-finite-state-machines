`timescale 1ns/1ps

module seq_detector_1011_tb;

reg clk;
reg reset;
reg in;
wire out;

seq_detector_1011 uut(
    .clk(clk),
    .reset(reset),
    .in(in),
    .out(out)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("seq_detector_1011.vcd");
    $dumpvars(0,seq_detector_1011_tb);

    $monitor("Time=%0t,clk=%b,reset=%b,in=%b,out=%b",$time,clk,reset,in,out);

    reset=1; in=0; #10;
    reset=0;

    $display("--- Test 1: Send 1,0,1,1 --- expect out=1 ---");
    in=1; #10;
    in=0; #10;
    in=1; #10;
    in=1; #10;

    $display("--- Test 2: Reset then 1,0,1,1 again ---");
    reset=1; #10;
    reset=0;
    in=1; #10;
    in=0; #10;
    in=1; #10;
    in=1; #10;

    $display("--- Test 3: Send 0,0,0,0 --- expect out stays 0 ---");
    reset=1; #10;
    reset=0;
    in=0; #10;
    in=0; #10;
    in=0; #10;
    in=0; #10;

    $display("--- Test 4: Send 1,1,0,1,1 --- expect out=1 ---");
    reset=1; #10;
    reset=0;
    in=1; #10;
    in=1; #10;
    in=0; #10;
    in=1; #10;
    in=1; #10;

    $display("--- Test 5: Overlapping 1,0,1,0,1,1 ---");
    reset=1; #10;
    reset=0;
    in=1; #10;
    in=0; #10;
    in=1; #10;
    in=0; #10;
    in=1; #10;
    in=1; #10;

    $finish;

end
endmodule