# UVM Testbench Filelist for AXI4 SRAM Controller
# Updated with new modular directory structure

# Include directories
+incdir+includes
+incdir+data
+incdir+interfaces
+incdir+agents
+incdir+sequences
+incdir+tests
+incdir+env

# RTL Files
../rtl/m_vlsi_fifo.sv
../rtl/m_vlsi_sram_misc.sv
../rtl/m_vlsi_arbiter.sv
../rtl/m_vlsi_axfsm.sv
../rtl/m_vlsi_axi4_sram.sv

# Testbench - Interface and Package (base)
interfaces/axi_if.sv
includes/uvm_pkg.sv

# Testbench Top
top_tb.sv
