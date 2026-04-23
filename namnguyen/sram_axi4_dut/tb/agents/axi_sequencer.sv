//======================================
// AXI Sequencer
// Custom sequencer for AXI transactions
//======================================
class axi_sequencer extends uvm_sequencer #(axi_seq_item);
  `uvm_component_utils(axi_sequencer)

  // Configuration properties
  int max_transactions = 100;
  
  // Statistics
  int write_count = 0;
  int read_count = 0;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("axi_sequencer", "Build phase completed", UVM_LOW)
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("axi_sequencer", $sformatf("Max transactions: %d", max_transactions), UVM_LOW)
  endfunction

  // Task to track sequences
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("axi_sequencer", "Run phase completed", UVM_LOW)
  endtask

endclass
