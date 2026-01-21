class tb_agent extends uvm_agent;
  `uvm_component_utils(tb_agent)

  virtual dut_if vif;

  uvm_analysis_port #(trans1) ap;
  tb_driver_wr drv_wr;
  tb_driver_rd drv_rd;
  //tb_monitor mon;
  tb_sequencer sqr;

  bit is_writer = 1;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    ap = new("ap", this);

    if (!uvm_config_db#(bit)::get(this, "", "is_writer", is_writer)) begin
      `uvm_info("agent", "is_writer not set", UVM_LOW)
    end
    if (is_active == UVM_ACTIVE) begin
      if (is_writer) begin
        drv_wr = tb_driver_wr::type_id::create("drv_wr", this);
      end else begin
        drv_rd = tb_driver_rd::type_id::create("drv_rd", this);
      end
      sqr = tb_sequencer::type_id::create("sqr", this);
    end
    //mon = tb_monitor::type_id::create("mon", this);

    get_vif();
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // if (is_active == UVM_ACTIVE) begin
    //   drv_wr.seq_item_port.connect(sqr.seq_item_export);
    //   drv_wr.vif = vif;  // resouce_db::get is done here, forward handle to monitor
    // end
    if (is_active == UVM_ACTIVE) begin
      if (is_writer) begin
          drv_wr.seq_item_port.connect(sqr.seq_item_export);
          drv_wr.vif = vif;
      end else begin
          drv_rd.seq_item_port.connect(sqr.seq_item_export);
          drv_rd.vif = vif;
      end
    end
    //mon.ap.connect(ap);
    //mon.vif = vif;  // forward vif handle
  endfunction

  function void get_vif();
    string passwd = get_full_name();
    if (!uvm_resource_db#(virtual dut_if)::read_by_name(passwd, "vif", vif, this))
      `uvm_fatal("NOVIF", {"virtual interface must be set for:", passwd, ".vif"})
  endfunction

endclass
