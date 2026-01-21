class trans1 extends uvm_sequence_item;
  `uvm_object_utils(trans1)

  // =========================================================================
  // Signals/Ports
  // =========================================================================
  // Inputs
  rand logic reset_n;
 
  rand logic is_write;
  rand logic [31:0] wdata;
  rand logic [31:0] rdata;

  // Conditions
  rand int delay;
  rand logic write_only;
  rand logic read_only;

  // Outputs
  logic wfull;
  logic rempty;
  
  // =========================================================================
  // Constraints
  // =========================================================================

  function new(string name = "trans1");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    trans1 tr;
    if (!$cast(tr, rhs)) `uvm_fatal("trans", "cast ERROR. Illegal do_copy() cast")
    super.do_copy(rhs);

    reset_n = tr.reset_n;

  endfunction

  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    trans1 tr;
    bit eq;
    if (!$cast(tr, rhs)) `uvm_fatal("trans1", "cast ERROR. Illegal do_compare() cast")
    eq = super.do_compare(rhs, comparer);
    eq &= (reset_n == tr.reset_n);
    return (eq);
  endfunction

  // -------------------------------------------------------
  // Print functions
  // -------------------------------------------------------
  virtual function string input2string();
    return ($sformatf("rst_n=%b", reset_n));
  endfunction

  virtual function string output2string();
    return ($sformatf("dout=%4h", reset_n));
  endfunction

  virtual function string convert2string();
    return ({input2string(), "  ", output2string()});
  endfunction
endclass
