class tr_sequence_wrfull extends uvm_sequence #(trans1);
  `uvm_object_utils(tr_sequence_wrfull)

  function new(string name = "tr_sequence_wrfull");
    super.new(name);
  endfunction

  int num_repeat_do_item = 300;

  task body;
    trans1 tr = trans1::type_id::create("tr");

    `uvm_info("body", "to do item", UVM_FULL)
    repeat (num_repeat_do_item) write_item(tr);
    disable_write(tr);                          // Disable write
  endtask

  task write_item(trans1 tr);
    `uvm_info("write_item", "executing", UVM_FULL)
    start_item(tr);
    assert (tr.randomize())
    else `uvm_fatal("tr_sequence_wrfull", "tr_sequence_wrfull randomization failed!");
    tr.is_write   = 1;
    tr.write_only = 1;
    tr.read_only = 0;
    finish_item(tr);
  endtask

  task disable_write(trans1 tr);
    `uvm_info("disable_write", "stopping write transactions", UVM_FULL)
    start_item(tr);
    assert (tr.randomize())
    else `uvm_fatal("tr_sequence_wrfull", "tr_sequence_wrfull randomization failed!");
    tr.is_write   = 0;
    tr.read_only = 0;
    finish_item(tr);
  endtask

endclass
