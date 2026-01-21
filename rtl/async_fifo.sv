module async_fifo #(
    parameter int PTR_WIDTH  = 9,
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = PTR_WIDTH - 1
) (
    input logic wclk,
    input logic wrst_n,

    input logic wren,
    input logic [DATA_WIDTH-1:0] wdata,

    input logic rclk,
    input logic rrst_n,

    input logic rden,
    output logic [DATA_WIDTH-1:0] rdata,

    output logic wfull,
    output logic rempty
);

  // =======================================================
  // Nets
  // =======================================================

  // Pointers
  logic [PTR_WIDTH-1:0] wrptr;
  logic [PTR_WIDTH-1:0] rdptr;
  logic [PTR_WIDTH-1:0] rs2_wrptr;
  logic [PTR_WIDTH-1:0] ws2_rdptr;
  logic [ADDR_WIDTH-1:0] waddr;
  logic [ADDR_WIDTH-1:0] raddr;

  // FIFO memory
  logic wrcsb0;

  // =======================================================
  // Submodules
  // =======================================================

  wrptr_control #(
      .PTR_WIDTH (PTR_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) u_wrptr_control (
      .clk       (wclk),
      .reset_n   (wrst_n),
      .wren      (wren),
      .rptr_sync2(ws2_rdptr),
      .wrptr     (wrptr),
      .waddr     (waddr),
      .wfull     (wfull)
  );

  rdptr_control #(
      .PTR_WIDTH (PTR_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) u_rdptr_control (
      .clk       (rclk),
      .reset_n   (rrst_n),
      .rden      (rden),
      .wptr_sync2(rs2_wrptr),
      .rdptr     (rdptr),
      .raddr     (raddr),
      .rempty    (rempty)
  );

  sync_2stage #(
      .DATA_WIDTH(PTR_WIDTH)
  ) u_sync2_wr_to_rd (
      .clk_rcv (rclk),
      .reset_n (rrst_n),
      .data_in (wrptr),
      .sync_out(rs2_wrptr)
  );

  sync_2stage #(
      .DATA_WIDTH(PTR_WIDTH)
  ) u_sync2_rd_to_wr (
      .clk_rcv (wclk),
      .reset_n (wrst_n),
      .data_in (rdptr),
      .sync_out(ws2_rdptr)
  );

  // FIFO mem write enable
  always_comb begin : FIFO_MEM_CSB
    wrcsb0 = ~(wren && !wfull);
  end

  custom_sram_1r1w_32_256_freepdk45 #(
      .VERBOSE(0)
  ) u_sram_1r1w_32_256 (
      .clk0 (wclk),
      .csb0 (wrcsb0),
      .addr0(waddr),
      .din0 (wdata),
      .clk1 (rclk),
      .csb1 (1'b0),
      .addr1(raddr),
      .dout1(rdata)
  );

endmodule
