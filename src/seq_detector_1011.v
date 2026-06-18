`timescale 1ns/1ps

module seq_detector_1011(
    input wire clk,
    input wire reset,
    input wire in,
    output reg out
);

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

reg [1:0] current_state, next_state;

always @(posedge clk or posedge reset) begin
    if(reset)
        current_state <= S0;
    else
        current_state <= next_state;
end

always @(*) begin
    case(current_state)
        S0: next_state = in ? S1 : S0;
        S1: next_state = in ? S1 : S2;
        S2: next_state = in ? S3 : S0;
        S3: next_state = in ? S1 : S2;
        default: next_state = S0;
    endcase
end

always @(*) begin
    out = 0;
    case(current_state)
        S3: if(in) out = 1;
    endcase
end

endmodule