module Pre_Norm(
    input clk,rst,
    input [31:0] in1,
    input [31:0] in2,
    output reg [7:0] diff
);

reg [7:0] diff_reg;

assign diff_reg = in1 + in2 + 1'b1;

always @(posedge clk ) begin
    if(rst)begin
        diff <= 8'b0;
    end
    else begin
        diff <= diff_reg;
    end
end 



endmodule

