`timescale 1ns/1ps

module traffic_light_tb;

reg clk;
reg reset;
wire red;
wire yellow;
wire green;

traffic_light uut(
    .clk(clk),
    .reset(reset),
    .red(red),
    .yellow(yellow),
    .green(green)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("traffic_light.vcd");
    $dumpvars(0,traffic_light_tb);

    $monitor("Time=%0t,clk=%b,reset=%b,red=%b,yellow=%b,green=%b",$time,clk,reset,red,yellow,green);

    reset=1; #10;
    reset=0; #200;
    reset=1; #10;
    reset=0; #100;

    $finish;

end
endmodule