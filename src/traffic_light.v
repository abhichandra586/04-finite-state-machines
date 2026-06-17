module traffic_light(
    input wire clk,
    input wire reset,
    output reg red,
    output reg yellow,
    output reg green
);

parameter RED=2'b00;
parameter GREEN=2'b01;
parameter YELLOW=2'b10;

reg [1:0] current_state, next_state;
reg [2:0] counter;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= RED;
        counter <= 3;
    end
    else begin
        if(counter == 0) begin
            current_state <= next_state;
            case(next_state)
                RED: counter <= 3;
                GREEN: counter <= 3;
                YELLOW: counter <= 1;
                default: counter <= 3;
            endcase
        end
        else
            counter <= counter-1;
    end
end

always @(*) begin
    case(current_state)
        RED: next_state = GREEN;
        GREEN: next_state = YELLOW;
        YELLOW: next_state = RED;
        default: next_state = RED;
    endcase
end

always @(*) begin
    red = 0;
    yellow = 0;
    green = 0;
    case(current_state)
        RED: red = 1;
        GREEN: green = 1;
        YELLOW: yellow = 1;
    endcase
end

endmodule