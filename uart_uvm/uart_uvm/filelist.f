// RTL
rtl/uart_if.sv
rtl/transmitter.sv
rtl/baud_rate_generator.sv
rtl/receiver.sv

// UVM testbench (order matters: base classes before classes that use them)
tb/uart_txn.sv
tb/uart_sequence.sv
tb/uart_driver.sv
tb/tx_monitor.sv
tb/rx_monitor.sv
tb/uart_scoreboard.sv
tb/uart_agent.sv
tb/uart_env.sv
tb/uart_test.sv
tb/tb_top.sv
