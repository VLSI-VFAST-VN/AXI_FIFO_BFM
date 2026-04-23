//======================================
// AXI Driver
//======================================
class axi_driver extends uvm_driver #(axi_seq_item);
  `uvm_component_utils(axi_driver)

  virtual axi_if vif;
  axi_seq_item item;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif)) begin
      `uvm_error("build_phase", "Virtual interface not found")
    end
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(item);
      drive_item(item);
      seq_item_port.item_done();
    end
  endtask

  task drive_item(axi_seq_item item);
    if (item.xfer_type == axi_seq_item::AXI_WRITE) begin
      drive_write(item);
    end else begin
      drive_read(item);
    end
  endtask

  task drive_write(axi_seq_item item);
    // Drive write address
    @(posedge vif.clk);
    vif.awaddr <= item.addr;
    vif.awvalid <= 1'b1;
    vif.awlen <= item.len;
    vif.awburst <= item.burst;
    vif.awid <= item.id;
    
    wait(vif.awready == 1'b1);
    @(posedge vif.clk);
    vif.awvalid <= 1'b0;
    
    // Drive write data
    @(posedge vif.clk);
    vif.wdata <= item.data;
    vif.wvalid <= 1'b1;
    vif.wlast <= 1'b1;
    
    wait(vif.wready == 1'b1);
    @(posedge vif.clk);
    vif.wvalid <= 1'b0;
    
    // Wait for write response
    vif.bready <= 1'b1;
    wait(vif.bvalid == 1'b1);
    @(posedge vif.clk);
    vif.bready <= 1'b0;
    
    `uvm_info("axi_driver", $sformatf("Write completed: %s", item.convert2string()), UVM_HIGH)
  endtask

  task drive_read(axi_seq_item item);
    // Drive read address
    @(posedge vif.clk);
    vif.araddr <= item.addr;
    vif.arvalid <= 1'b1;
    vif.arlen <= item.len;
    vif.arburst <= item.burst;
    vif.arid <= item.id;
    
    wait(vif.arready == 1'b1);
    @(posedge vif.clk);
    vif.arvalid <= 1'b0;
    
    // Wait for read data
    vif.rready <= 1'b1;
    wait(vif.rvalid == 1'b1);
    item.read_data = vif.rdata;
    @(posedge vif.clk);
    vif.rready <= 1'b0;
    
    `uvm_info("axi_driver", $sformatf("Read completed: %s", item.convert2string()), UVM_HIGH)
  endtask

endclass
