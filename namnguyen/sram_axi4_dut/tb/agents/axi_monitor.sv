//======================================
// AXI Monitor
//======================================
class axi_monitor extends uvm_monitor;
  `uvm_component_utils(axi_monitor)

  virtual axi_if vif;
  uvm_analysis_port #(axi_seq_item) item_collected_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
      `uvm_error("build_phase", "Virtual interface not found")
    end
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      collect_transactions();
    end
  endtask

  task collect_transactions();
    axi_seq_item item;
    
    // Monitor write transactions
    @(posedge vif.clk);
    if (vif.awvalid && vif.awready) begin
      item = axi_seq_item::type_id::create("item");
      item.xfer_type = axi_seq_item::AXI_WRITE;
      item.addr = vif.awaddr;
      item.id = vif.awid;
      item.len = vif.awlen;
      item.burst = vif.awburst;
      
      // Wait for data
      @(posedge vif.clk);
      while (!(vif.wvalid && vif.wready)) @(posedge vif.clk);
      item.data = vif.wdata;
      
      item_collected_port.write(item);
      `uvm_info("axi_monitor", $sformatf("Write monitored: %s", item.convert2string()), UVM_MEDIUM)
    end
    
    // Monitor read transactions
    if (vif.arvalid && vif.arready) begin
      item = axi_seq_item::type_id::create("item");
      item.xfer_type = axi_seq_item::AXI_READ;
      item.addr = vif.araddr;
      item.id = vif.arid;
      item.len = vif.arlen;
      item.burst = vif.arburst;
      
      // Wait for response
      @(posedge vif.clk);
      while (!(vif.rvalid && vif.rready)) @(posedge vif.clk);
      item.read_data = vif.rdata;
      
      item_collected_port.write(item);
      `uvm_info("axi_monitor", $sformatf("Read monitored: %s", item.convert2string()), UVM_MEDIUM)
    end
  endtask

endclass
