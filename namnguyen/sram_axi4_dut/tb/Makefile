#======================================
# Makefile for AXI4 SRAM Controller
#======================================

# Directories & Files
RTL_DIR        = ../rtl
TOP_MODULE     = top_tb
FILELIST       = filelist.f

# Test Selection
TEST_WRITE     = axi_write_test
TEST_READ      = axi_read_test
TEST_MIXED     = axi_mixed_test
TEST           ?= $(TEST_WRITE)

# Simulator Selection (default: questa)
SIM            ?= questa

#======================================
# QuestaSim Configuration
#======================================
QUESTA_CFLAGS  = -sv -timescale 1ns/1ps
QUESTA_SFLAGS  = -voptargs="+acc" +UVM_TESTNAME=$(TEST)
QUESTA_DO      = run_questa_temp.do

#======================================
# VCS Configuration
#======================================
VCS_WORK       = vcs_work
VCS_CFLAGS     = -full64 -sverilog -timescale=1ns/1ps \
                 -access +rwc +vpi +nospecify
VCS_SFLAGS     = -l $(VCS_WORK)/sim.log

#======================================
# Help Target
#======================================
.PHONY: help
help:
	@echo ""
	@echo "=================================================="
	@echo "AXI4 SRAM Controller - Testbench Makefile"
	@echo "QuestaSim 10.2c & VCS Compatible"
	@echo "=================================================="
	@echo ""
	@echo "Quick Start:"
	@echo "  make questa                  - Compile & run with QuestaSim (default)"
	@echo "  make vcs                     - Compile & run with VCS"
	@echo ""
	@echo "Test Selection:"
	@echo "  make questa TEST=axi_write_test   - Write test"
	@echo "  make questa TEST=axi_read_test    - Read test"
	@echo "  make questa TEST=axi_mixed_test   - Mixed test"
	@echo ""
	@echo "Targets:"
	@echo "  make compile-questa          - Compile for QuestaSim only"
	@echo "  make compile-vcs             - Compile for VCS only"
	@echo "  make run-questa              - Run QuestaSim"
	@echo "  make run-vcs                 - Run VCS"
	@echo "  make gui-questa              - QuestaSim GUI mode"
	@echo "  make test-all-questa         - Run all tests (QuestaSim)"
	@echo "  make test-all-vcs            - Run all tests (VCS)"
	@echo "  make clean                   - Clean all artifacts"
	@echo "  make clean-questa            - Clean QuestaSim artifacts"
	@echo "  make clean-vcs               - Clean VCS artifacts"
	@echo ""
	@echo "=================================================="
	@echo ""

.DEFAULT_GOAL := help

#======================================
# QuestaSim Targets
#======================================

# Compile and Run (QuestaSim)
.PHONY: questa
questa: compile-questa run-questa

# Compile only (QuestaSim)
.PHONY: compile-questa
compile-questa:
	@echo ""
	@echo "========== QuestaSim Compilation (10.2c) =========="
	@rm -rf work transcript
	vlib work
	vlog $(QUESTA_CFLAGS) -f $(FILELIST)
	@echo "Compilation complete!"
	@echo ""

# Run (QuestaSim)
.PHONY: run-questa
run-questa: compile-questa
	@echo ""
	@echo "========== QuestaSim Simulation =========="
	@echo "Test: $(TEST)"
	@echo "vlib work" > $(QUESTA_DO)
	@echo "vlog $(QUESTA_CFLAGS) -f $(FILELIST)" >> $(QUESTA_DO)
	@echo "vsim -voptargs=\"+acc\" +UVM_TESTNAME=$(TEST) $(TOP_MODULE)" >> $(QUESTA_DO)
	@echo "run -all" >> $(QUESTA_DO)
	@echo "quit" >> $(QUESTA_DO)
	vsim -do $(QUESTA_DO)
	@rm -f $(QUESTA_DO)
	@echo ""

# GUI Mode (QuestaSim)
.PHONY: gui-questa
gui-questa: compile-questa
	@echo ""
	@echo "========== QuestaSim Interactive Mode =========="
	vsim -voptargs="+acc" +UVM_TESTNAME=$(TEST) -gui $(TOP_MODULE) &

#======================================
# VCS Targets
#======================================

# Compile and Run (VCS)
.PHONY: vcs
vcs: compile-vcs run-vcs

# Compile only (VCS)
.PHONY: compile-vcs
compile-vcs: $(VCS_WORK)/simv

$(VCS_WORK)/simv:
	@echo ""
	@echo "========== VCS Compilation =========="
	@mkdir -p $(VCS_WORK)
	vcs $(VCS_CFLAGS) \
		-f $(FILELIST) \
		-top $(TOP_MODULE) \
		-o $(VCS_WORK)/simv \
		-l $(VCS_WORK)/compile.log
	@echo "Compilation complete!"
	@echo ""

# Run (VCS)
.PHONY: run-vcs
run-vcs: $(VCS_WORK)/simv
	@echo ""
	@echo "========== VCS Simulation =========="
	@echo "Test: $(TEST)"
	cd $(VCS_WORK) && ./simv $(VCS_SFLAGS) +UVM_TESTNAME=$(TEST)
	@echo ""

# GUI Mode (VCS)
.PHONY: gui-vcs
gui-vcs: $(VCS_WORK)/simv
	@echo ""
	@echo "========== VCS Interactive Mode =========="
	cd $(VCS_WORK) && ./simv -gui

#======================================
# Run All Tests
#======================================

.PHONY: test-all-questa
test-all-questa:
	@echo ""
	@echo "========== Running All Tests (QuestaSim 10.2c) =========="
	@make compile-questa
	@$(MAKE) run-questa TEST=$(TEST_WRITE)
	@$(MAKE) run-questa TEST=$(TEST_READ)
	@$(MAKE) run-questa TEST=$(TEST_MIXED)
	@echo "All tests complete!"
	@echo ""

.PHONY: test-all-vcs
test-all-vcs:
	@echo ""
	@echo "========== Running All Tests (VCS) =========="
	@$(MAKE) vcs TEST=$(TEST_WRITE)
	@$(MAKE) vcs TEST=$(TEST_READ)
	@$(MAKE) vcs TEST=$(TEST_MIXED)
	@echo "All tests complete!"
	@echo ""

#======================================
# Clean Targets
#======================================

.PHONY: clean
clean: clean-questa clean-vcs
	@rm -rf *.log *.vcd *.wdb *.vpd *.fsdb transcript
	@echo "All artifacts cleaned!"

.PHONY: clean-questa
clean-questa:
	@echo "Cleaning QuestaSim artifacts..."
	@rm -rf work transcript *.wdb *.vcd

.PHONY: clean-vcs
clean-vcs:
	@echo "Cleaning VCS artifacts..."
	@rm -rf $(VCS_WORK) simv simv.daidir csrc DVEfiles

#======================================
# Info
#======================================

.PHONY: info
info:
	@echo ""
	@echo "========== Configuration =========="
	@echo "Top Module:      $(TOP_MODULE)"
	@echo "Filelist:        $(FILELIST)"
	@echo "Current Test:    $(TEST)"
	@echo ""
	@echo "Test Options:"
	@echo "  - $(TEST_WRITE)"
	@echo "  - $(TEST_READ)"
	@echo "  - $(TEST_MIXED)"
	@echo ""
	@echo "QuestaSim Work:  work/ (default)"
	@echo "VCS Work:        $(VCS_WORK)/"
	@echo "========================================"
	@echo ""

