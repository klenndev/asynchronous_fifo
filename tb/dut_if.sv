`include "CLK_CYCLE.sv"

interface dut_if (
    input clk_wr,
    input clk_rd
);

    logic reset_n;              // Dummy

    logic wclk;
    logic wrst_n;

    logic wren;
    logic [31:0] wdata;

    logic rclk;
    logic rrst_n;

    logic rden;

    logic [31:0] rdata;
    logic wfull;
    logic rempty;

  clocking cb1 @(posedge clk_wr);
    default input #1step output #1;
  endclocking

  clocking cb2 @(posedge clk_rd);
    default input #1step output #1;
  endclocking
endinterface
