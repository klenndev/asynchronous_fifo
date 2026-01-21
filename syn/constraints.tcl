
create_clock -name clk_wr -period 2.50 [get_ports wclk]
create_clock -name clk_rd -period 6.00 [get_ports rclk]

set_clock_uncertainty 0.20 [get_clocks clk_wr]
set_clock_uncertainty 0.48 [get_clocks clk_rd]

# CDC
set_clock_groups -asynchronous -group [get_clocks clk_wr] -group [get_clocks clk_rd]

# Pointers
set wr_ptr_reg [get_cells -hierarchical u_wrptr_control/wrptr*]
set rd_ptr_reg [get_cells -hierarchical u_rdptr_control/rdptr*]

# Synchronizer
set wr_sync_dest [get_cells -hierarchical u_sync2_wr_to_rd/sync_store*]
set rd_sync_dest [get_cells -hierarchical u_sync2_rd_to_wr/sync_store*]

set_max_delay 2.5 -from $wr_ptr_reg -to $wr_sync_dest
set_max_delay 2.5 -from $rd_ptr_reg -to $rd_sync_dest

set_min_delay 0.0 -from $wr_ptr_reg -to $wr_sync_dest
set_min_delay 0.0 -from $rd_ptr_reg -to $rd_sync_dest

# External delays
set_input_delay 0.5 -clock clk_wr [get_ports {wren wdata[*] wrst_n}]
set_input_delay 1.2 -clock clk_rd [get_ports {rden rrst_n}]

set_output_delay 0.5 -clock clk_wr [get_ports {wfull}]
set_output_delay 1.2 -clock clk_rd [get_ports {rempty rdata}]

# Resets
set_false_path -from [get_ports wrst_n]
set_false_path -from [get_ports rrst_n]

# Design Constraints
set_max_fanout 15.0 [current_design]
set_load 10 [all_outputs]
set_driving_cell -lib_cell BUF_X4 [all_inputs]