//======================================
// AXI Scoreboard
//======================================
class axi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_scoreboard)

  uvm_analysis_imp #(axi_seq_item, axi_scoreboard) analysis_imp;
  
  int write_count = 0;
  int read_count = 0;
  bit [31:0] memory [bit[31:0]];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_imp = new("analysis_imp", this);
  endfunction

  function void write(axi_seq_item item);
    if (item.xfer_type == axi_seq_item::AXI_WRITE) begin
      memory[item.addr] = item.data;
      write_count++;
      `uvm_info("scoreboard", $sformatf("Write: Addr=0x%h Data=0x%h", item.addr, item.data), UVM_MEDIUM)
    end else begin
      if (memory.exists(item.addr)) begin
        if (memory[item.addr] == item.read_data) begin
          read_count++;
          `uvm_info("scoreboard", $sformatf("Read PASS: Addr=0x%h Data=0x%h", item.addr, item.read_data), UVM_MEDIUM)
        end else begin
          `uvm_error("scoreboard", $sformatf("Read FAIL: Addr=0x%h Expected=0x%h Got=0x%h", 
              item.addr, memory[item.addr], item.read_data))
        end
      end else begin
        read_count++;
        memory[item.addr] = item.read_data;
        `uvm_info("scoreboard", $sformatf("Read: Addr=0x%h Data=0x%h (first read)", item.addr, item.read_data), UVM_MEDIUM)
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("scoreboard", $sformatf("Writes: %d, Reads: %d", write_count, read_count), UVM_LOW)
  endfunction

endclass
