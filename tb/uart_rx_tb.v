`timescale 1ns/1ps

module uart_rx_tb;

reg clk;
reg reset;
reg rx;
wire [7:0] data_out;
wire data_valid;

uart_rx uut(
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .data_out(data_out),
    .data_valid(data_valid)
);

integer i;
reg [7:0] test_byte;
parameter CLKS_PER_BIT = 16;

task send_byte;
    input [7:0] byte_in;
    integer j;
    begin
        rx = 1'b0;
        repeat(CLKS_PER_BIT) @(posedge clk);
        for(j=0; j<8; j=j+1) begin
            rx = byte_in[j];
            repeat(CLKS_PER_BIT) @(posedge clk);
        end
        rx = 1'b1;
        repeat(CLKS_PER_BIT) @(posedge clk);
    end
endtask

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("uart_rx.vcd");
    $dumpvars(0,uart_rx_tb);

    $monitor("Time=%0t,rx=%b,data_out=%h,data_valid=%b",$time,rx,data_out,data_valid);

    reset=1; rx=1; #20;
    reset=0; #20;

    $display("--- Test 1: Receive 0x55 ---");
    send_byte(8'h55);
    #20;

    $display("--- Test 2: Receive 0xAA ---");
    send_byte(8'hAA);
    #20;

    $display("--- Test 3: Receive 0xFF ---");
    send_byte(8'hFF);
    #20;

    $display("--- Test 4: Receive 0x00 ---");
    send_byte(8'h00);
    #20;

    $finish;

end
endmodule