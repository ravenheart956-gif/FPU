module SubNDet(
    input [31:0] in,
    output subnormal,
    output normal,
    output Inf,
    output NaN,
    output [23:0] man
);

assign subnormal = (in[30:23] == 8'd0 && !(in[22:0] == 23'b0));
assign normal = (!(in[30:23] == 8'd0) && !(in[22:0] == 23'b0)); /*might not need normal flag*/ /*also removed the zero flag*/

/*EXCEPTIONS*/
assign Inf = (in[30:23] == 8'd255 && (in[22:0] == 23'b0));
assign NaN = ((in[30:23] == 8'd255) && !(in[22:0] == 23'b0));

assign man = subnormal ? {1'b0,in[22:0]} : {1'b1,in[22:0]};
endmodule
