module sync_2stage #(
  DATA_WIDTH = 8
) (
    input  logic clk_rcv,
    input  logic reset_n,
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] sync_out
);

  logic [DATA_WIDTH-1:0] sync_store;

  // 2 stage synchronizer
  always_ff @(posedge clk_rcv or negedge reset_n) begin
    if (!reset_n) begin
      sync_store <= 'h0;
      sync_out   <= 'h0;
    end else begin
      sync_store <= data_in;
      sync_out   <= sync_store;
    end
  end

endmodule
