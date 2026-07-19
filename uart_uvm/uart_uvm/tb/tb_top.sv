`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_top;
  bit clk;
  always #5 clk = ~clk;  // 100MHz clock (10ns period)

  uart_if intf(clk);

  baud_rate_generator u_baud (
    .clk   (clk),
    .tx_en (intf.tx_en),
    .rx_en (intf.rx_en)
  );

  transmitter u_tx (
    .clk      (clk),
    .rst_n    (intf.rst_n),
    .tx_en    (intf.tx_en),
    .tx_start (intf.tx_start),
    .data_in  (intf.data_in),
    .tx_out   (intf.tx_out),
    .busy     (intf.busy),
    .tx_done  (intf.tx_done)
  );

  reciever u_rx (
    .clk      (clk),
    .rst_n    (intf.rst_n),
    .rx_en    (intf.rx_en),
    .rx_in    (intf.rx_in),
    .data_out (intf.data_out),
    .rx_done  (intf.rx_done)
  );

  assign intf.rx_in = intf.tx_out;  // Loopback: TX -> RX

  initial begin
    intf.rst_n    = 1'b0;   // Assert reset
    intf.tx_start = 1'b0;
    intf.data_in  = 8'd0;
    #100;                   // Hold reset for 100ns
    intf.rst_n = 1'b1;      // Release reset
  end

  // UVM startup
  initial begin
    uvm_config_db#(virtual uart_if)::set(null, "*", "vif", intf);
    run_test("uart_test");
  end
endmodule
