class test_wrFull_readEmpty extends test_base;
  `uvm_component_utils(test_wrFull_readEmpty)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    tr_sequence_wrfull seq;
    tr_sequence_rd_tillempty seq_rd;
    
    seq = tr_sequence_wrfull::type_id::create("seq");
    seq_rd = tr_sequence_rd_tillempty::type_id::create("seq_rd");

    phase.raise_objection(this);
    `uvm_info("test_wrFull_readEmpty", "start sequence...", UVM_FULL)
    seq.start(e.agnt_wr.sqr);
    seq_rd.start(e.agnt_rd.sqr);
    phase.drop_objection(this);
  endtask

endclass
