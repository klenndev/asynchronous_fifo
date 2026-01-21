
// Only include the code if it has not already been included
`ifndef TB_PKG__SV
`define TB_PKG__SV 

`include "CLK_CYCLE.sv"

`include "uvm_macros.svh"
import uvm_pkg::*;

package tb_pkg;
  import uvm_pkg::*;  // import uvm base  classes

  `include "trans1.svh"
  `include "tr_sequence_wrfull.svh"
  `include "tr_sequence_rd_tillempty.svh"

  `include "tb_driver_wr.svh"
  `include "tb_driver_rd.svh"
  `include "tb_sequencer.svh"
  `include "tb_agent.svh"

  `include "env.svh"

  `include "test_base.svh"
  `include "test_wrFull_readEmpty.svh"

endpackage

`endif
