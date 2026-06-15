`timescale 1ns/1ps

module moore_fsm_tb;

reg clk;
reg reset;
reg in;
wire out;

moore_fsm uut(
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

    $dumpfile("moore_fsm.vcd");
    $dumpvars(0,moore_fsm_tb);

    $monitor("Time=%0t,clk=%b,reset=%b,in=%b,out=%b",
              $time,clk,reset,in,out);

    reset=1; in=0; #10;
    reset=0;

    $display("--- Test 1: Send 1,0,1 --- expect out=1 at end");
    in=1; #10;
    in=0; #10;
    in=1; #10;

    $display("--- Test 2: Reset then send 1,0,1 again ---");
    reset=1; #10;
    reset=0;
    in=1; #10;
    in=0; #10;
    in=1; #10;

    $display("--- Test 3: Send 0,0,0 --- expect out stays 0 ---");
    reset=1; #10;
    reset=0;
    in=0; #10;
    in=0; #10;
    in=0; #10;

    $display("--- Test 4: Send 1,1,0,1 --- FSM should still detect 101 ---");
    reset=1; #10;
    reset=0;
    in=1; #10;
    in=1; #10;
    in=0; #10;
    in=1; #10;

    $display("--- Test 5: Overlapping --- send 1,0,1,0,1 ---");
    reset=1; #10;
    reset=0;
    in=1; #10;
    in=0; #10;
    in=1; #10;
    in=0; #10;
    in=1; #10;

    $finish;

end
endmodule