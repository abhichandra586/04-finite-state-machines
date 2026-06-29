module uart_tx(
    input wire clk,
    input wire reset,
    input wire send,
    input wire [7:0] data,
    output reg tx,
    output reg busy
);

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

parameter CLKS_PER_BIT = 16;

reg [1:0] current_state;
reg [3:0] clk_count;
reg [2:0] bit_index;
reg [7:0] data_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= IDLE;
        tx <= 1'b1;
        busy <= 1'b0;
        clk_count <= 0;
        bit_index <= 0;
        data_reg <= 8'h00;
    end
    else begin
        case(current_state)

            IDLE: begin
                tx <= 1'b1;
                busy <= 1'b0;
                clk_count <= 0;
                bit_index <= 0;
                if(send) begin
                    data_reg <= data;
                    current_state <= START;
                    busy <= 1'b1;
                end
            end

            START: begin
                tx <= 1'b0;
                if(clk_count == CLKS_PER_BIT - 1) begin
                    clk_count <= 0;
                    current_state <= DATA;
                end
                else
                    clk_count <= clk_count + 1;
            end

            DATA: begin
                tx <= data_reg[bit_index];
                if(clk_count == CLKS_PER_BIT - 1) begin
                    clk_count <= 0;
                    if(bit_index == 7) begin
                        bit_index     <= 0;
                        current_state <= STOP;
                    end
                    else
                        bit_index <= bit_index + 1;
                end
                else
                    clk_count <= clk_count + 1;
            end

            STOP: begin
                tx <= 1'b1;
                if(clk_count == CLKS_PER_BIT - 1) begin
                    clk_count <= 0;
                    current_state <= IDLE;
                    busy <= 1'b0;
                end
                else
                    clk_count <= clk_count + 1;
            end

            default: begin
                current_state <= IDLE;
                tx <= 1'b1;
                busy <= 1'b0;
            end

        endcase
    end
end

endmodule