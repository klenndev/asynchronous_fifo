class tb_driver_rd extends uvm_driver #(trans1);
  `uvm_component_utils(tb_driver_rd)

  virtual dut_if vif;

  trans1 tr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    //initialize();
    forever begin
      `uvm_info("driver.runphase", "...getting next item", UVM_FULL)
      seq_item_port.get_next_item(tr);
      if (!tr.write_only) begin
        drive_item(tr);
      end
      `uvm_info("driver.runphase", "...item done", UVM_FULL)
      seq_item_port.item_done();
    end
  endtask

  virtual task initialize();  // Does not use the clocking block
    `uvm_info("init", "Initializion signals", UVM_FULL)

    vif.rrst_n <= 0;  // Assert reset and stimulate input to verify reset works
    vif.rden <= 0;
    repeat (2) @vif.cb2;  // @(posedge clk)
  endtask

  virtual task drive_item(trans1 tr);
    `uvm_info("drive_item", tr.input2string(), UVM_FULL)
    vif.rrst_n <= 1'b1;
    vif.rden <= !tr.is_write;
    @vif.cb2;
  endtask

endclass
