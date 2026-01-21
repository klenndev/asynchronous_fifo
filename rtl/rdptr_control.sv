module rdptr_control #(
    parameter int PTR_WIDTH  = 9,
    parameter int ADDR_WIDTH = PTR_WIDTH - 1
) (
    input logic clk,
    input logic reset_n,

    input logic rden,
    input logic [PTR_WIDTH-1:0] wptr_sync2,

    output logic [PTR_WIDTH-1:0] rdptr,
    output logic [ADDR_WIDTH-1:0] raddr,
    output logic rempty
);

  // Nets
  logic [PTR_WIDTH-1:0] rdgray_next;
  logic [PTR_WIDTH-1:0] rdbin;
  logic [PTR_WIDTH-1:0] rptrbin_next;
  logic rempty_val;

  always_ff @(posedge clk or negedge reset_n) begin : POINTER_SEQ
    if (!reset_n) begin
      rdbin <= 'h0;
      rdptr <= 'h0;
    end else begin
      if (rden && !rempty) begin
        rdbin <= rdbin + 1;
        rdptr <= rdgray_next;
      end
    end
  end

  // Gray code generator
  always_comb begin : GRAY_CODE_GEN_COMB
    rptrbin_next = rempty ? rdbin : rdbin + 1;
    rdgray_next  = (rptrbin_next >> 1) ^ rptrbin_next;
  end

  always_comb begin : EMPTY_FLAG_COMB
    rempty_val = (wptr_sync2 == rdgray_next);
  end

  always_ff @(posedge clk or negedge reset_n) begin : EMPTY_FLAG_SEQ
    if (!reset_n) begin
      rempty <= 1'b1;
    end else begin
      rempty <= rempty_val;
    end
  end

  // Address mem output
  assign raddr = rdbin[ADDR_WIDTH-1:0];

endmodule
