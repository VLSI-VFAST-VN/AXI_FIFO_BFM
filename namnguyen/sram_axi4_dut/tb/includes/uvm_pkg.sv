//======================================
// UVM Test Package
// Updated with new directory structure
//======================================
package uvm_tb_pkg;
  import uvm_pkg::*;
  
  `include "uvm_macros.svh"
  
  // Data types
  `include "data/axi_seq_item.sv"
  
  // Interfaces included separately in top_tb.sv
  
  // Sequences
  `include "sequences/axi_sequences.sv"
  
  // Agent components
  `include "agents/axi_sequencer.sv"
  `include "agents/axi_driver.sv"
  `include "agents/axi_monitor.sv"
  `include "agents/axi_agent.sv"
  
  // Environment
  `include "env/axi_scoreboard.sv"
  `include "env/axi_env.sv"
  
  // Tests
  `include "tests/axi_tests.sv"

endpackage
