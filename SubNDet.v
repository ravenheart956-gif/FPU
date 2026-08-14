module SubNDet(
    input clk,
    input rst,
    input [31:0] in1,in2
    output normal1,normal2,
    output Inf1,Inf2,
    output NaN1,NaN2,
    output [31:0] reg FP1_Adj,FP2_Adj;
    output reg [23:0] man_reg1,man_reg2
);

wire [23:0] man1,man2;
reg [31:0] in_reg1,in_reg2;

always @(posedge clk) begin
    if(rst)begin
        in_reg1 <= 32'd0;
        in_reg2 <= 32'd0;
    end
    else begin
        in_reg1 <= in1;
        in_reg2 <= in2;
    end
end

always @(posedge clk) begin
    if(in1 > in2)begin
        FP1_Adj <= in1;
        FP2_Adj <= in2;
    end
    else begin
        FP1_Adj <= in2;
        FP2_Adj <= in1;
    end
end

assign normal1 = (|in_reg1[30:23]);
assign normal2 = (|in_reg2[30:23]);

assign Inf1 = (in_reg1[30:23] == 8'd255 && (in_reg1[22:0] == 23'b0));
assign Inf2 = (in_reg2[30:23] == 8'd255 && (in_reg2[22:0] == 23'b0));

assign NaN1 = ((in_reg1[30:23] == 8'd255) && !(in_reg1[22:0] == 23'b0));
assign NaN2= ((in_reg2[30:23] == 8'd255) && !(in_reg2[22:0] == 23'b0));

assign man1 = {normal1 , in_reg1[22:0]};
assign man2 = {normal2 , in_reg2[22:0]};

always @(posedge clk) begin
    if(rst)begin
        man_reg1 <= 24'd0;
        man_reg2 <= 24'd0;
    end
    else begin
        man_reg1 <= man1;
        man_reg2 <= man2;
    end
end


endmodule
