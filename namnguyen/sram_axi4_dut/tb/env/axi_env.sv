//======================================
// AXI Environment
//======================================
class axi_env extends uvm_env;
  `uvm_component_utils(axi_env)

  axi_agent agent;
  axi_scoreboard scoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = axi_agent::type_id::create("agent", this);
    scoreboard = axi_scoreboard::type_id::create("scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.item_collected_port.connect(scoreboard.analysis_imp);
  endfunction

endclass
