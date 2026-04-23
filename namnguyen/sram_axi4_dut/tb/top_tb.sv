//======================================
// AXI4 SRAM Testbench Top Module
//======================================
`include "interfaces/axi_if.sv"

module top_tb;
  import uvm_pkg::*;
  import uvm_tb_pkg::*;

  `include "uvm_macros.svh"

  logic clk;
  logic rst_n;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation
  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  // AXI Interface instance
  axi_if axi_if_i (
    .clk(clk),
    .rst_n(rst_n)
  );

  // DUT instance
  m_vlsi_axi4_sram #(
    .PARA_DATA_WD(32),
    .PARA_ADDR_WD(32),
    .PARA_ID_WD(4),
    .PARA_LEN_WD(8),
    .PARA_FIFO_DEPTH(8)
  ) dut_i (
    .i_clk(clk),
    .i_rst_n(rst_n),
    
    // Write Address
    .i_awaddr(axi_if_i.awaddr),
    .i_awvalid(axi_if_i.awvalid),
    .o_awready(axi_if_i.awready),
    .i_awburst(axi_if_i.awburst),
    .i_awlen(axi_if_i.awlen),
    .i_awid(axi_if_i.awid),
    
    // Write Data
    .i_wdata(axi_if_i.wdata),
    .i_wvalid(axi_if_i.wvalid),
    .o_wready(axi_if_i.wready),
    .i_wlast(axi_if_i.wlast),
    
    // Write Response
    .o_bid(axi_if_i.bid),
    .o_bresp(axi_if_i.bresp),
    .o_bvalid(axi_if_i.bvalid),
    .i_bready(axi_if_i.bready),
    
    // Read Address
    .i_araddr(axi_if_i.araddr),
    .i_arvalid(axi_if_i.arvalid),
    .o_arready(axi_if_i.arready),
    .i_arburst(axi_if_i.arburst),
    .i_arlen(axi_if_i.arlen),
    .i_arid(axi_if_i.arid),
    
    // Read Data
    .o_rid(axi_if_i.rid),
    .o_rdata(axi_if_i.rdata),
    .o_rresp(axi_if_i.rresp),
    .o_rvalid(axi_if_i.rvalid),
    .o_rlast(axi_if_i.rlast),
    .i_rready(axi_if_i.rready),
    
    // SRAM Interface (tied off for now)
    .o_sram_addr(),
    .o_sram_wdata(),
    .o_sram_we(),
    .o_sram_oe(),
    .i_sram_rdata(32'h0)
  );

  // UVM Test execution
  initial begin
    uvm_config_db#(virtual axi_if)::set(null, "*", "vif", axi_if_i);
    
    run_test("axi_write_test");
  end

  // Waveform dumping
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, top_tb);
  end

  // Simulation timeout
  initial begin
    #100000;
    $display("Simulation timeout!");
    $finish;
  end

endmodule
