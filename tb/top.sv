
`include "uvm_macros.svh"

`include "CLK_CYCLE.sv"
`include "clkgen.sv"

`include "tb_pkg.sv"
`include "dut_if.sv"
`include "async_fifo_sva.sv"

module top;
  import uvm_pkg::*;  // import uvm base  classes
  import tb_pkg::*;  // import testbench classes

  localparam int DATA_WIDTH = 32;
  localparam int PTR_WIDTH = 9;

  logic clk_wr;
  logic clk_rd;

  // instantiate real DUT interface
  dut_if dif (
    .clk_wr(clk_wr), 
    .clk_rd(clk_rd)
  );

  // Instantiate clock generator
  clkgen u_clkgen (
      .clk_wr(clk_wr),
      .clk_rd(clk_rd)
  );

  // DUT
  async_fifo #(
      .PTR_WIDTH (PTR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  ) u_async_fifo (
      .wclk  (clk_wr),
      .wrst_n(dif.wrst_n),
      .wren  (dif.wren),
      .wdata (dif.wdata),

      .rclk  (clk_rd),
      .rrst_n(dif.rrst_n),
      .rden  (dif.rden),
      .rdata (dif.rdata),

      .wfull (dif.wfull),
      .rempty(dif.rempty)
  );

  initial begin
    uvm_resource_db#(virtual dut_if)::set("*", "vif", dif);  // UVM-style
    run_test("test_wrFull_readEmpty");
  end
endmodule

// ========================================================
// Bind SVA
// ========================================================
bind async_fifo async_fifo_sva #(
    .PTR_WIDTH (PTR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) async_fifo_sva_inst (
    .wclk  (wclk),
    .wrst_n(wrst_n),
    .wren  (wren),
    .wdata (wdata),
    .rclk  (rclk),
    .rrst_n(rrst_n),
    .rden  (rden),
    .rdata (rdata),
    .wfull (wfull),
    .rempty(rempty),
    .wraddr(waddr),
    .rdaddr(raddr),
    .wrptr (wrptr),
    .rdptr (rdptr)
);
