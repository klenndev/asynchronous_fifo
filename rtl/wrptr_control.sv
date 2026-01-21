
module wrptr_control #(
    parameter int PTR_WIDTH = 9,
    parameter int ADDR_WIDTH = PTR_WIDTH-1
) (
    input logic clk,
    input logic reset_n,

    input logic wren,
    input logic [PTR_WIDTH-1:0] rptr_sync2,

    output logic [PTR_WIDTH-1:0] wrptr,
    output logic [ADDR_WIDTH-1:0] waddr,
    output logic wfull
);
  
  // Nets
  logic [PTR_WIDTH-1:0] wrgray_next;
  logic [PTR_WIDTH-1:0] wrbin;
  logic [PTR_WIDTH-1:0] wptrbin_next;
  logic wfull_val;

  always_ff @(posedge clk or negedge reset_n) begin : POINTER_SEQ
    if (!reset_n) begin
      wrbin <= 'h0;
      wrptr <= 'h0;
    end else begin
      if (wren && !wfull) begin
        wrbin <= wrbin+1;
        wrptr <= wrgray_next;
      end
    end
  end

  // Gray code generator
  always_comb begin : GRAY_CODE_GEN_COMB
    wptrbin_next = (wfull || ~wren) ? wrbin : wrbin+1;
    wrgray_next = (wptrbin_next >> 1) ^ wptrbin_next;
  end

  // Full flag logic
  always_comb begin : FULL_FLAG_GEN_COMB
    wfull_val = ((rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2] != wrgray_next[PTR_WIDTH-1:PTR_WIDTH-2]) && (rptr_sync2[PTR_WIDTH-3:0] == wrgray_next[PTR_WIDTH-3:0]));
  end

  always_ff @(posedge clk or negedge reset_n) begin : FULL_FLAG_OUT_SEQ
    if (!reset_n) begin
      wfull <= 1'b0;
    end else begin
      wfull <= wfull_val;
    end
  end

  // Address mem output
  assign waddr = wrbin[ADDR_WIDTH-1:0];

endmodule
