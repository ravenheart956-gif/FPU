module Pre_Norm(
    input clk,rst,
    input logic [31:0] FP1_Adj,FP2_Adj,
    output logic [7:0] diff,
    output logic [23:0] Man_1out,Man_2Shifted
);

logic [23:0] Man1,Man2;
logic [7:0] diff_comb

assign diff_comb = FP1_Adj[30:23] + ~FP2_Adj[30:23] + 1'b1;

assign Man1 = {1'b1,FP1_Adj[22:0]};
assign Man2 = {1'b1,FP2_Adj[22:0]};


always_ff @(posedge clk)begin
    if(rst)begin
        diff <= 8'd0;
        Man_1out <= 24'd0;
        Man_2Shifted <= 24'd0;
    end
    else begin
        diff <= diff_comb;
        Man_1out <= Man1;
        Man_2Shifted <= Man2 >> diff;
    end
end 
    


endmodule

