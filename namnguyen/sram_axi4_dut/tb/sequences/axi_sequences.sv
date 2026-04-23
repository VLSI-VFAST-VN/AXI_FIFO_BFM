//======================================
// AXI Base Sequence
//======================================
class axi_base_seq extends uvm_sequence #(axi_seq_item);
  `uvm_object_utils(axi_base_seq)

  function new(string name = "axi_base_seq");
    super.new(name);
  endfunction

endclass

//======================================
// AXI Write Sequence
//======================================
class axi_write_seq extends axi_base_seq;
  `uvm_object_utils(axi_write_seq)

  rand int num_txns = 5;

  constraint num_txns_c {
    num_txns inside {[1:20]};
  }

  function new(string name = "axi_write_seq");
    super.new(name);
  endfunction

  task body();
    axi_seq_item item;
    repeat (num_txns) begin
      item = axi_seq_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with {
        xfer_type == axi_seq_item::AXI_WRITE;
        addr inside {[32'h0 : 32'h1000]};
        len == 0;
        burst == 2'b01;  // INCR
      }) else `uvm_error("body", "Randomize failed")
      finish_item(item);
      `uvm_info("axi_write_seq", $sformatf("Write item: %s", item.convert2string()), UVM_MEDIUM)
    end
  endtask

endclass

//======================================
// AXI Read Sequence
//======================================
class axi_read_seq extends axi_base_seq;
  `uvm_object_utils(axi_read_seq)

  rand int num_txns = 5;

  constraint num_txns_c {
    num_txns inside {[1:20]};
  }

  function new(string name = "axi_read_seq");
    super.new(name);
  endfunction

  task body();
    axi_seq_item item;
    repeat (num_txns) begin
      item = axi_seq_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with {
        xfer_type == axi_seq_item::AXI_READ;
        addr inside {[32'h0 : 32'h1000]};
        len == 0;
        burst == 2'b01;  // INCR
      }) else `uvm_error("body", "Randomize failed")
      finish_item(item);
      `uvm_info("axi_read_seq", $sformatf("Read item: %s", item.convert2string()), UVM_MEDIUM)
    end
  endtask

endclass

//======================================
// AXI Mixed Sequence
//======================================
class axi_mixed_seq extends axi_base_seq;
  `uvm_object_utils(axi_mixed_seq)

  rand int num_txns = 10;

  constraint num_txns_c {
    num_txns inside {[2:30]};
  }

  function new(string name = "axi_mixed_seq");
    super.new(name);
  endfunction

  task body();
    axi_seq_item item;
    repeat (num_txns) begin
      item = axi_seq_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with {
        addr inside {[32'h0 : 32'h1000]};
        len == 0;
        burst == 2'b01;  // INCR
      }) else `uvm_error("body", "Randomize failed")
      finish_item(item);
      `uvm_info("axi_mixed_seq", $sformatf("Mixed item: %s", item.convert2string()), UVM_MEDIUM)
    end
  endtask

endclass
