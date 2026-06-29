`timescale 1ns/1ps

module debounce_tb;

reg clk;
reg reset;
reg btn;
wire btn_out;

debounce uut(
    .clk(clk),
    .reset(reset),
    .btn(btn),
    .btn_out(btn_out)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("debounce.vcd");
    $dumpvars(0,debounce_tb);

    $monitor("Time=%0t,btn=%b,btn_out=%b",$time,btn,btn_out);

    reset=1; btn=0; #20;
    reset=0; #10;

    $display("--- Test 1: Clean press ---");
    btn=1; #300;
    btn=0; #300;

    $display("--- Test 2: Bouncing press ---");
    btn=1; #20;
    btn=0; #20;
    btn=1; #20;
    btn=0; #20;
    btn=1; #300;
    btn=0; #300;

    $display("--- Test 3: Short glitch --- should be filtered ---");
    btn=1; #30;
    btn=0; #300;

    $display("--- Test 4: Async reset during press ---");
    btn=1; #100;
    reset=1; #20;
    reset=0; #200;

    $finish;

end
endmodule