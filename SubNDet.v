module SubNDet(
    input clk,
    input rst,
    input [31:0] in,
    output normal,
    output Inf,
    output NaN,
    output reg [23:0] man_reg
);

wire [23:0] man;
reg [31:0] in_reg;

always @(posedge clk) begin
    if(rst)begin
        in_reg <= 32'd0;
    end
    else begin
        in_reg <= in;
    end
end

assign normal = (in_reg[30]|in_reg[29]|in_reg[28]|in_reg[27]|in_reg[26]|in_reg[25]|in_reg[24]|in_reg[23]);
/*EXCEPTIONS*/
assign Inf = (in_reg[30:23] == 8'd255 && (in_reg[22:0] == 23'b0));
assign NaN = ((in_reg[30:23] == 8'd255) && !(in_reg[22:0] == 23'b0));

assign man = {normal , in_reg[22:0]};

always @(posedge clk) begin
    if(rst)begin
        man_reg <= 24'd0;
    end
    else begin
        man_reg <= man;
    end
end


endmodule
