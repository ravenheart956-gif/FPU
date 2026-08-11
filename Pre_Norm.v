module Pre_Norm(
    input clk,rst,
    input [31:0] in1,
    input [31:0] in2,
);

reg [31:0] in1_reg;
reg [31:0] in2_reg;
wire [7:0] del_E;
wire grt;



always @(posedge clk) begin
    if (rst)begin
        in2_reg <= 32'd0;
        in1_reg <= 32'd0;
        del_E <= 8'd0;
    end
    else begin
        in1_reg <= in1;
        in2_reg <= in2;
    end
end


assign grt = (in1_reg > in2_reg);
assign del_E = grt?(in1_reg[30:23]-in2_reg[30:23]):(in2_reg[30:23]-in1_reg[30:23]);



endmodule

