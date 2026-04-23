//======================================
// AXI Interface
//======================================
interface axi_if (input logic clk, input logic rst_n);

  // Write Address Channel
  logic [31:0] awaddr;
  logic        awvalid;
  logic        awready;
  logic [1:0]  awburst;
  logic [7:0]  awlen;
  logic [3:0]  awid;

  // Write Data Channel
  logic [31:0] wdata;
  logic        wvalid;
  logic        wready;
  logic        wlast;

  // Write Response Channel
  logic [3:0]  bid;
  logic [1:0]  bresp;
  logic        bvalid;
  logic        bready;

  // Read Address Channel
  logic [31:0] araddr;
  logic        arvalid;
  logic        arready;
  logic [1:0]  arburst;
  logic [7:0]  arlen;
  logic [3:0]  arid;

  // Read Data Channel
  logic [3:0]  rid;
  logic [31:0] rdata;
  logic [1:0]  rresp;
  logic        rvalid;
  logic        rlast;
  logic        rready;

endinterface
