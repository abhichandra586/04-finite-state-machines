module debounce(
    input wire clk,
    input wire reset,
    input wire btn,
    output reg btn_out
);

parameter DEBOUNCE_LIMIT = 20;

reg [4:0] counter;
reg btn_sync0,btn_sync1;
reg btn_stable;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        btn_sync0 <= 1'b0;
        btn_sync1 <= 1'b0;
        counter <= 0;
        btn_stable <= 1'b0;
        btn_out <= 1'b0;
    end
    else begin
        btn_sync0 <= btn;
        btn_sync1 <= btn_sync0;

        if(btn_sync1 != btn_stable) begin
            counter <= counter + 1;
            if(counter == DEBOUNCE_LIMIT - 1) begin
                btn_stable <= btn_sync1;
                btn_out <= btn_sync1;
                counter <= 0;
            end
        end
        else begin
            counter <= 0;
        end
    end
end

endmodule