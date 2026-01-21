class env extends uvm_env;
  `uvm_component_utils(env)

  tb_agent agnt_wr;
  tb_agent agnt_rd;
  //tb_scoreboard sbd;

  // Functional coverage dut-output agent
  //tb_cover cov;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(this, "agnt_rd", "is_writer", 0);

    agnt_wr = tb_agent::type_id::create("agnt_wr", this);
    agnt_rd = tb_agent::type_id::create("agnt_rd", this);
    //sbd  = tb_scoreboard::type_id::create("sbd", this);
    //cov  = tb_cover::type_id::create("cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    //agnt_wr.ap.connect(sbd.axp);
    //agnt_wr.ap.connect(cov.analysis_export);
  endfunction

endclass
