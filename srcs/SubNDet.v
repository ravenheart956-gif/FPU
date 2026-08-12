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


  assign normal =(|in[30:23]);
  

/*EXCEPTIONS*/
assign Inf = (in[30:23] == 8'd255 && (in[22:0] == 23'b0));
assign NaN = ((in[30:23] == 8'd255) && !(in[22:0] == 23'b0));

assign man = {normal , in[22:0]};

always @(posedge clk) begin
    if(rst)begin
        man_reg <= 24'd0;
    end
    else begin
        man_reg <= man;
    end
end


endmodule
