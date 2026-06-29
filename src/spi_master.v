module spi_master(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] mosi_data,
    output reg mosi,
    output reg sclk,
    output reg cs,
    output reg [7:0] miso_data,
    input wire miso,
    output reg done
);

parameter IDLE = 2'b00;
parameter TRANSFER = 2'b01;
parameter FINISH = 2'b10;

parameter CLKS_PER_HALF = 4;

reg [1:0] current_state;
reg [2:0] bit_index;
reg [3:0] clk_count;
reg [7:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= IDLE;
        mosi <= 1'b0;
        sclk <= 1'b0;
        cs <= 1'b1;
        miso_data <= 8'h00;
        done <= 1'b0;
        bit_index <= 3'd7;
        clk_count <= 0;
        shift_reg <= 8'h00;
    end
    else begin
        case(current_state)

            IDLE: begin
                sclk <= 1'b0;
                cs <= 1'b1;
                done <= 1'b0;
                bit_index <= 3'd7;
                clk_count <= 0;
                if(start) begin
                    shift_reg <= mosi_data;
                    cs <= 1'b0;
                    current_state <= TRANSFER;
                end
            end

            TRANSFER: begin
                if(clk_count < CLKS_PER_HALF - 1) begin
                    clk_count <= clk_count + 1;
                end
                else begin
                    clk_count <= 0;
                    sclk <= ~sclk;
                    if(sclk == 1'b0) begin
                        mosi <= shift_reg[bit_index];
                    end
                    else begin
                        miso_data[bit_index] <= miso;
                        if(bit_index == 0) begin
                            current_state <= FINISH;
                        end
                        else begin
                            bit_index <= bit_index - 1;
                        end
                    end
                end
            end

            FINISH: begin
                cs <= 1'b1;
                sclk <= 1'b0;
                done <= 1'b1;
                current_state <= IDLE;
            end

            default: begin
                current_state <= IDLE;
                cs <= 1'b1;
            end

        endcase
    end
end

endmodule