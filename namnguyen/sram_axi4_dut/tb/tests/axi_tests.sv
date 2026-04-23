//======================================
// AXI Base Test
//======================================
class axi_base_test extends uvm_test;
  `uvm_component_utils(axi_base_test)

  axi_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = axi_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info("axi_base_test", "Test started", UVM_LOW)
  endtask

endclass

//======================================
// AXI Write Test
//======================================
class axi_write_test extends axi_base_test;
  `uvm_component_utils(axi_write_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_write_seq write_seq;
    phase.raise_objection(this);
    
    write_seq = axi_write_seq::type_id::create("write_seq");
    write_seq.start(env.agent.sequencer);
    
    phase.drop_objection(this);
  endtask

endclass

//======================================
// AXI Read Test
//======================================
class axi_read_test extends axi_base_test;
  `uvm_component_utils(axi_read_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_read_seq read_seq;
    phase.raise_objection(this);
    
    read_seq = axi_read_seq::type_id::create("read_seq");
    read_seq.start(env.agent.sequencer);
    
    phase.drop_objection(this);
  endtask

endclass

//======================================
// AXI Mixed Test
//======================================
class axi_mixed_test extends axi_base_test;
  `uvm_component_utils(axi_mixed_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_write_seq write_seq;
    axi_read_seq read_seq;
    phase.raise_objection(this);
    
    write_seq = axi_write_seq::type_id::create("write_seq");
    read_seq = axi_read_seq::type_id::create("read_seq");
    
    write_seq.start(env.agent.sequencer);
    read_seq.start(env.agent.sequencer);
    
    phase.drop_objection(this);
  endtask

endclass
