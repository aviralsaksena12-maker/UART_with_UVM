interface uart_if(input clk);
  logic rst_n;

  logic tx_en;
  logic tx_start;
  logic [7:0] data_in;
  logic tx_out;
  logic busy;
  logic tx_done;

  logic rx_en;
  logic rx_start;
  logic [7:0] data_out;
  logic rx_in;
  logic rx_done;

endinterface
