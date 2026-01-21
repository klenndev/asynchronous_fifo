module async_fifo_sva #(
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
    input logic [DATA_WIDTH-1:0] rdata,

    input logic wfull,
    input logic rempty,

    // Internal signals
    input logic [ADDR_WIDTH-1:0] wraddr,
    input logic [ADDR_WIDTH-1:0] rdaddr,
    input logic [ PTR_WIDTH-1:0] wrptr,
    input logic [ PTR_WIDTH-1:0] rdptr
);

	int wr_count = 0;
	logic [DATA_WIDTH-1:0] queue [$];
	logic [DATA_WIDTH-1:0] expected_data;

  // Push data on write
  always @(posedge wclk) begin
    if (wrst_n && wren && !wfull) queue.push_back(wdata);
  end

	// Pop data on read
	always @(posedge rclk) begin
		if (rrst_n && rden && !rempty) begin
			expected_data = queue.pop_front();
		end
	end

	// ========================================================
	// Output properties
	// ========================================================
	property wr_reset_full_p;
		@(posedge wclk) (!wrst_n) |=> (wfull == 0);
	endproperty

	property rd_reset_empty_p;
		@(posedge rclk) (!rrst_n) |=> (rempty == 1);
	endproperty

	// ========================================================
	// Internal signal properties
	// ========================================================
	property wr_full_wren_dont_increment_p;
		@(posedge wclk) disable iff (!wrst_n) (wfull && wren) |=> $stable(wraddr);
	endproperty

	property rd_full_wren_dont_increment_p;
		@(posedge rclk) disable iff (!rrst_n) (rempty && rden) |=> $stable(rdaddr);
	endproperty
	
	// The grey-coded pointers must only change 1 bit per valid write/read.
	property wr_grey_code_increment_behavior_p;
		@(posedge wclk) disable iff (!wrst_n) (wren && !wfull && $past(wrst_n)) |=> $onehot(wrptr ^ $past(wrptr));
	endproperty
 
	property rd_grey_code_increment_behavior_p;
		@(posedge rclk) disable iff (!rrst_n) (rden && !rempty && $past(rrst_n)) |=> $onehot(rdptr ^ $past(rdptr));
	endproperty

	// Data integrity. What first goes in, first goes out.
  property fifo_order_p;
    @(posedge rclk) disable iff (!rrst_n) (rden && !rempty) |=> (rdata == expected_data);
  endproperty

	// wfull and rempty cannot be True at the same time.
	property both_wfull_rempty_p;
		@(posedge wclk) disable iff (!wrst_n || !rrst_n) !(wfull && rempty); 
	endproperty

	// ========================================================
	// Assertions
	// ========================================================
	wr_reset_full_a : assert property(wr_reset_full_p) 
		else $fatal(1, "Assertion failed");
	rd_reset_empty_a : assert property(rd_reset_empty_p)
		else $fatal(1, "Assertion failed");
	wr_full_wren_dont_increment_a : assert property(wr_full_wren_dont_increment_p)
		else $fatal(1, "Assertion failed");
	rd_full_wren_dont_increment_a : assert property(rd_full_wren_dont_increment_p)
		else $fatal(1, "Assertion failed");
	wr_grey_code_increment_behavior_a : assert property(wr_grey_code_increment_behavior_p)
		else $fatal(1, "Assertion failed");
	rd_grey_code_increment_behavior_a : assert property(rd_grey_code_increment_behavior_p)
		else $fatal(1, "Assertion failed");
	fifo_order_a : assert property(fifo_order_p)
		else $fatal(1, "Assertion failed");
	both_wfull_rempty_a : assert property(both_wfull_rempty_p)
		else $fatal(1, "Assertion failed");
		
endmodule
