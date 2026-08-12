`timescale 1ns/1ps


module tb_SubNDet;

    logic        clk;
    logic        rst;
    logic [31:0] in;
    logic        normal, Inf, NaN;
    logic [23:0] man_reg;

    SubNDet dut (
        .clk     (clk),
        .rst     (rst),
        .in      (in),
        .normal  (normal),
        .Inf     (Inf),
        .NaN     (NaN),
        .man_reg (man_reg)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Hierarchical probe of internal (purely combinational) man wire
    wire [23:0] man_p = dut.man;

    // ==========================================================
    // SVA: reset
    // ==========================================================
    property p_reset_man_reg;
        @(posedge clk) rst |=> (man_reg == 24'd0);
    endproperty
    a_reset_man_reg: assert property(p_reset_man_reg)
        else $error("[%0t] man_reg not cleared one cycle after rst", $time);

    // ==========================================================
    // SVA: combinational decode correctness (same-cycle, no $past needed)
    // ==========================================================
    property p_normal_correct;
        @(posedge clk) disable iff(rst) normal == |in[30:23];
    endproperty
    a_normal_correct: assert property(p_normal_correct)
        else $error("[%0t] normal mismatch: got %b exp %b (in=%h)",
                     $time, normal, |in[30:23], in);

    property p_inf_correct;
        @(posedge clk) disable iff(rst)
            Inf == ((in[30:23] == 8'd255) && (in[22:0] == 23'd0));
    endproperty
    a_inf_correct: assert property(p_inf_correct)
        else $error("[%0t] Inf mismatch (in=%h)", $time, in);

    property p_nan_correct;
        @(posedge clk) disable iff(rst)
            NaN == ((in[30:23] == 8'd255) && (in[22:0] != 23'd0));
    endproperty
    a_nan_correct: assert property(p_nan_correct)
        else $error("[%0t] NaN mismatch (in=%h)", $time, in);

    property p_inf_nan_mutex;
        @(posedge clk) disable iff(rst) !(Inf && NaN);
    endproperty
    a_inf_nan_mutex: assert property(p_inf_nan_mutex)
        else $error("[%0t] Inf and NaN asserted simultaneously", $time);

    property p_exp255_implies_normal;
        @(posedge clk) disable iff(rst) ((Inf || NaN) |-> normal);
    endproperty
    a_exp255_implies_normal: assert property(p_exp255_implies_normal)
        else $error("[%0t] normal should be 1 when exponent field is all ones", $time);

    property p_exp0_implies_not_normal;
        @(posedge clk) disable iff(rst) ((in[30:23] == 8'd0) |-> !normal);
    endproperty
    a_exp0_implies_not_normal: assert property(p_exp0_implies_not_normal)
        else $error("[%0t] normal should be 0 when exponent field is zero", $time);


    
 
    // ==========================================================
    // SVA: no unknowns once out of reset
    // ==========================================================
    property p_no_x(logic sig);
        @(posedge clk) disable iff(rst) !$isunknown(sig);
    endproperty
    a_no_x_normal:  assert property(p_no_x(normal))  else $error("[%0t] normal is X/Z", $time);
    a_no_x_inf:     assert property(p_no_x(Inf))     else $error("[%0t] Inf is X/Z", $time);
    a_no_x_nan:     assert property(p_no_x(NaN))     else $error("[%0t] NaN is X/Z", $time);


    task automatic drive(input [31:0] val);
        @(negedge clk);
        in = val;
    endtask

    initial begin
        rst = 1;
        in  = 32'd0;
        repeat (2) @(negedge clk);
        rst = 0;

        drive(32'h3FC00000); repeat(3) @(negedge clk); // +1.5   (normal)
        drive(32'hC0000000); repeat(3) @(negedge clk); // -2.0   (normal)
        drive(32'h00000000); repeat(3) @(negedge clk); // +0
        drive(32'h80000000); repeat(3) @(negedge clk); // -0
        drive(32'h00400000); repeat(3) @(negedge clk); // subnormal
        drive(32'h007FFFFF); repeat(3) @(negedge clk); // largest subnormal
        drive(32'h7F800000); repeat(3) @(negedge clk); // +Inf
        drive(32'hFF800000); repeat(3) @(negedge clk); // -Inf
        drive(32'h7FC00000); repeat(3) @(negedge clk); // quiet NaN
        drive(32'h7F800001); repeat(3) @(negedge clk); // signaling NaN
        drive(32'h7F7FFFFF); repeat(3) @(negedge clk); // max normal
        drive(32'h00800000); repeat(3) @(negedge clk); // smallest normal

        drive(32'h3F800000);           // 1.0
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;
        drive(32'h40490FDB);           // pi
        repeat(3) @(negedge clk);

        for (int i = 0; i < 300; i++) begin
            drive($urandom());
            @(negedge clk);
        end

        repeat(4) @(negedge clk);
        $display("=== Simulation finished at time %0t ===", $time);
        $finish;
    end

endmodule
