module uart_rx(
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_valid
);

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

parameter CLKS_PER_BIT = 16;
parameter HALF_BIT = 8;

reg [1:0] current_state;
reg [3:0] clk_count;
reg [2:0] bit_index;
reg [7:0] data_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= IDLE;
        clk_count <= 0;
        bit_index <= 0;
        data_reg <= 8'h00;
        data_out <= 8'h00;
        data_valid <= 1'b0;
    end
    else begin
        case(current_state)

            IDLE: begin
                data_valid <= 1'b0;
                clk_count <= 0;
                bit_index <= 0;
                if(rx == 1'b0)
                    current_state <= START;
            end

            START: begin
                if(clk_count == HALF_BIT - 1) begin
                    if(rx == 1'b0) begin
                        clk_count <= 0;
                        current_state <= DATA;
                    end
                    else
                        current_state <= IDLE;
                end
                else
                    clk_count <= clk_count + 1;
            end

            DATA: begin
                if(clk_count == CLKS_PER_BIT - 1) begin
                    clk_count <= 0;
                    data_reg[bit_index] <= rx;
                    if(bit_index == 7) begin
                        bit_index <= 0;
                        current_state <= STOP;
                    end
                    else
                        bit_index <= bit_index + 1;
                end
                else
                    clk_count <= clk_count + 1;
            end

            STOP: begin
                if(clk_count == CLKS_PER_BIT - 1) begin
                    clk_count <= 0;
                    data_out <= data_reg;
                    data_valid <= 1'b1;
                    current_state <= IDLE;
                end
                else
                    clk_count <= clk_count + 1;
            end

            default: begin
                current_state <= IDLE;
                data_valid <= 1'b0;
            end

        endcase
    end
end

endmodule