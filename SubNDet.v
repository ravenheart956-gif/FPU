module SubNDet(
    input clk,
    input rst,
    input [31:0] in,
    output sub,
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

    assign sub = ~(in[30]&in[29]&in[28]&in[27]&in[26]&in[25]&in[24]&in[23]);  /* I have gym now,I'll fix this*/
/*EXCEPTIONS*/
assign Inf = (in[30:23] == 8'd255 && (in[22:0] == 23'b0));
assign NaN = ((in[30:23] == 8'd255) && !(in[22:0] == 23'b0));

assign man = {!sub , in[22:0]};

always @(posedge clk) begin
    if(rst)begin
        man_reg <= 24'd0;
    end
    else begin
        man_reg <= man;
    end
end


endmodule
