module SubNDet(
    input [31:0] in,
    output subnormal,
    output normal,
    output Inf,
    output NaN,
    output zero
);

assign subnormal = (in[30:23] == 8'd0 && !(in[22:0] == 23'b0));
assign zero = (in[30:23] == 8'd0 && in[22:0] == 23'b0);
assign normal = (!(in[30:23] == 8'd0) && !(in[22:0] == 23'b0));
assign Inf = (in[30:23] == 8'd255 && (in[22:0] == 23'b0));
assign NaN = ((in[30:23] == 8'd255) && !(in[22:0] == 23'b0));
endmodule