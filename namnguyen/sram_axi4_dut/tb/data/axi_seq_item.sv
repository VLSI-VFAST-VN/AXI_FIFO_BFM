//======================================
// AXI Sequence Item
// Defines the transaction for AXI bus
//======================================
class axi_seq_item extends uvm_sequence_item;
  `uvm_object_utils(axi_seq_item)

  // Transaction type
  typedef enum {
    AXI_WRITE,
    AXI_READ
  } axi_xfer_type_e;

  rand axi_xfer_type_e xfer_type;
  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand bit [7:0]  len;
  rand bit [1:0]  burst;
  rand bit [3:0]  id;
  bit [1:0] resp;
  bit [31:0] read_data;

  function new(string name = "axi_seq_item");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    axi_seq_item rhs_;
    if (!$cast(rhs_, rhs)) begin
      `uvm_error("do_copy", "Cast failed")
    end
    super.do_copy(rhs);
    xfer_type = rhs_.xfer_type;
    addr = rhs_.addr;
    data = rhs_.data;
    len = rhs_.len;
    burst = rhs_.burst;
    id = rhs_.id;
    resp = rhs_.resp;
    read_data = rhs_.read_data;
  endfunction

  function string convert2string();
    string s;
    s = $sformatf("Type:%s Addr:0x%h Data:0x%h Len:%d ID:%d", 
        xfer_type.name(), addr, data, len, id);
    return s;
  endfunction

endclass
