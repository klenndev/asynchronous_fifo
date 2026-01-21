`include "CLK_CYCLE.sv"

module clkgen (
    output logic clk_wr,
    output logic clk_rd
);

  initial begin
    clk_wr <= 0;
    forever #(`CLK_CYCLE_SND / 2) clk_wr <= ~clk_wr;
  end

    initial begin
    clk_rd <= 0;
    forever #(`CLK_CYCLE_RCV / 2) clk_rd <= ~clk_rd;
  end

endmodule
