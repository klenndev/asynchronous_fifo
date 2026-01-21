class tr_sequence_rd_tillempty extends uvm_sequence #(trans1);
  `uvm_object_utils(tr_sequence_rd_tillempty)

  function new(string name = "tr_sequence_rd_tillempty");
    super.new(name);
  endfunction

  int num_repeat_do_item = 300;

  task body;
    trans1 tr = trans1::type_id::create("tr");

    `uvm_info("body", "to do item", UVM_FULL)
    repeat (num_repeat_do_item) read_item(tr);
  endtask

  task read_item(trans1 tr);
    `uvm_info("read_item", "executing", UVM_FULL)
    start_item(tr);
    assert (tr.randomize())
    else `uvm_fatal("tr_sequence_rd_tillempty", "tr_sequence_rd_tillempty randomization failed!");
    tr.is_write   = 0;
    tr.write_only = 0;
    tr.read_only = 1;
    finish_item(tr);
  endtask

endclass
