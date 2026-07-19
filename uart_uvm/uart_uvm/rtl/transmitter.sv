module transmitter(
    input clk,
    input tx_start,
    input rst_n,          // ACTIVE-LOW reset
    input tx_en,
    input [7:0] data_in,
    output reg tx_out,
    output reg busy,
    output reg tx_done
);
  parameter idle_state  = 2'b00;
  parameter start_state = 2'b01;
  parameter data_state  = 2'b10;
  parameter stop_state  = 2'b11;
  
  reg [1:0] state, next;
  reg [7:0] shift_reg;
  reg [2:0] bit_cnt;

  always @(posedge clk) begin
    if (!rst_n)           // FIXED: Active-low reset
      state <= idle_state;
    else
      state <= next;
  end

  always @(*) begin
    next = state;
    case (state)
      idle_state:  if (tx_start)              next = start_state;
      start_state: if (tx_en)                 next = data_state;
      data_state:  if (tx_en && bit_cnt == 7) next = stop_state;
      stop_state:  if (tx_en)                 next = idle_state;
      default:                                next = idle_state;
    endcase
  end

  always @(posedge clk) begin
    if (!rst_n) begin     // FIXED: Active-low reset
      tx_out   <= 1'b1;
      busy     <= 1'b0;
      tx_done  <= 1'b0;
      bit_cnt  <= 3'd0;
      shift_reg<= 8'd0;
    end else begin
      tx_done <= 1'b0;
      case (state)
        idle_state: begin
          tx_out <= 1'b1;
          busy   <= 1'b0;
          if (tx_start) begin
            shift_reg <= data_in;
            busy      <= 1'b1;
            bit_cnt   <= 3'd0;
          end
        end

        start_state: begin
          if (tx_en)
            tx_out <= 1'b0;
        end

        data_state: begin
          if (tx_en) begin
            tx_out  <= shift_reg[bit_cnt];
            bit_cnt <= bit_cnt + 1'b1;
          end
        end

        stop_state: begin
          if (tx_en) begin
            tx_out  <= 1'b1;
            busy    <= 1'b0;
            tx_done <= 1'b1;
          end
        end
      endcase
    end
  end
endmodule
