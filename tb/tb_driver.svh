class tb_driver extends uvm_driver #(trans1);
  `uvm_component_utils(tb_driver)

  virtual dut_if vif;

  trans1 tr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    initialize();
    forever begin
      `uvm_info("driver.runphase", "...getting next item", UVM_FULL)
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      `uvm_info("driver.runphase", "...item done", UVM_FULL)
      seq_item_port.item_done();
    end
  endtask

  virtual task initialize();  // Does not use the clocking block
    `uvm_info("init", "Initializion signals", UVM_FULL)

    vif.reset_n <= 0;  // Assert reset and stimulate input to verify reset works
    repeat (2) @vif.cb1;  // @(posedge clk)
  endtask

  virtual task drive_item(trans1 tr);
    `uvm_info("drive_item", tr.input2string(), UVM_FULL)
    vif.reset_n <= 1'b1;
    vif.rden <= 1'b1;
    vif.wptr_sync2 <= 'h1A;
    repeat (100) @vif.cb1;
  endtask

endclass
