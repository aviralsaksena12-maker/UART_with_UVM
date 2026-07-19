module baud_rate_generator(
    input clk,
    output tx_en,
    output rx_en
);
  // Assuming 50MHz clock (20ns period), target baud ~9600
  // tx_en: 50MHz / 9600 = 5208.33 -> 5208
  // rx_en: 16x oversample -> 5208/16 = 325.5 -> 325
  
  reg [12:0] tx_counter = 0;
  reg [8:0]  rx_counter = 0;    // FIXED: 9 bits is enough for 325

  always @(posedge clk) begin
    if (tx_counter >= 5208)
      tx_counter <= 0;
    else
      tx_counter <= tx_counter + 1'b1;
  end
  
  always @(posedge clk) begin
    if (rx_counter >= 325)
      rx_counter <= 0;
    else
      rx_counter <= rx_counter + 1'b1;
  end
  
  assign tx_en = (tx_counter == 0) ? 1'b1 : 1'b0;
  assign rx_en = (rx_counter == 0) ? 1'b1 : 1'b0;
endmodule
