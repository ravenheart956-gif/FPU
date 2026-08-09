module Pre_Norm(
    input clk,rst,
    input [31:0] in1,
    input [31:0] in2,
);

reg [31:0] in1_reg;
reg [31:0] in2_reg;
reg [7:0] del_E;

assign del_E = in1_reg[30:23] - in2_reg[30:23];

always @(posedge clk) begin
    if (rst)begin
        in2_reg <= 32'd0;
        in1_reg <= 32'd0;
        del_E <= 8'd0;
    end
    else begin
        // The numbers are then arranged in such a way that the exponents are the same, These numbers are then givin as output . This simplifies the next step, Addition and Substraction
    end
end

endmodule

// Step 2 : Alter the Numbers so that the exponents are equal

// This kind of normalisation will only work for Addition and Subtraction , When It comes to division and multiplication the exponents are also changing

endmodule