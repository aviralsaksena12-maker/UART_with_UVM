module reciever (
    input clk,
    input rst_n,          
    input rx_en,
    input rx_in,
    output reg [7:0] data_out,
    output reg rx_done
);
  parameter IDLE  = 2'b00;
  parameter START = 2'b01;
  parameter DATA  = 2'b10;
  parameter STOP  = 2'b11;
  
  reg [1:0] state, next_state;
  reg [7:0] shift_reg;
  reg [2:0] bit_cnt;
  reg [3:0] tick_cnt;
  reg       start_valid;
  wire      start_detect;
  
  assign start_detect = (rx_in == 1'b0);

  always @(posedge clk) begin
    if (!rst_n)           
      state <= IDLE;
    else
      state <= next_state;
  end

  always @(*) begin
    next_state = state;
    case (state)
      IDLE:    if (start_detect)                        next_state = START;
      START:   if (rx_en && tick_cnt == 4'd15)          next_state = start_valid ? DATA : IDLE;
      DATA:    if (rx_en && tick_cnt == 4'd15 && bit_cnt == 3'd7) next_state = STOP;
      STOP:    if (rx_en && tick_cnt == 4'd15)          next_state = IDLE;
      default:                                           next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (!rst_n) begin    
      data_out    <= 8'd0;
      rx_done     <= 1'b0;
      bit_cnt     <= 3'd0;
      tick_cnt    <= 4'd0;
      shift_reg   <= 8'd0;
      start_valid <= 1'b0;
    end else begin
      rx_done <= 1'b0;
      case (state)
        IDLE: begin
          tick_cnt <= 4'd0;
          bit_cnt  <= 3'd0;
        end
        
        START: begin
          if (rx_en) begin
            tick_cnt <= tick_cnt + 1'b1;
            if (tick_cnt == 4'd7)
              start_valid <= (rx_in == 1'b0);
            if (tick_cnt == 4'd15)
              tick_cnt <= 4'd0;
          end
        end
        
        DATA: begin
          if (rx_en) begin
            tick_cnt <= tick_cnt + 1'b1;
            if (tick_cnt == 4'd7)
              shift_reg[bit_cnt] <= rx_in;
            if (tick_cnt == 4'd15) begin
              tick_cnt <= 4'd0;
              bit_cnt  <= bit_cnt + 1'b1;
            end
          end
        end
        
        STOP: begin
          if (rx_en) begin
            tick_cnt <= tick_cnt + 1'b1;
            if (tick_cnt == 4'd7) begin
              data_out <= shift_reg;
              rx_done  <= 1'b1;
            end
            if (tick_cnt == 4'd15)
              tick_cnt <= 4'd0;
          end
        end
      endcase
    end
  end
endmodule
