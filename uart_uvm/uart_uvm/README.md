# UART UVM Testbench

UART transmitter/receiver RTL with a UVM-based verification testbench (loopback: TX -> RX).

## Structure

```
rtl/
  uart_if.sv               - DUT interface
  transmitter.sv            - UART transmitter FSM
  baud_rate_generator.sv    - Baud tick generator for tx_en/rx_en
  receiver.sv               - UART receiver FSM (module reciever)

tb/
  uart_txn.sv               - Sequence item (transaction)
  uart_sequence.sv          - Sequence generating random bytes
  uart_driver.sv            - Drives transactions into the transmitter
  tx_monitor.sv             - Observes bytes sent (expected)
  rx_monitor.sv             - Observes bytes received (actual)
  uart_scoreboard.sv        - Compares expected vs actual
  uart_agent.sv             - Bundles sequencer + driver + tx_monitor
  uart_env.sv               - Bundles agent + rx_monitor + scoreboard
  uart_test.sv              - Top-level UVM test
  tb_top.sv                 - Top-level module, DUT instantiation, UVM run_test

filelist.f                  - Compile order for all files
```

## Compiling (Synopsys VCS)

```bash
vcs -sverilog -timescale=1ns/1ns +vcs+flush+all +warn=all -f filelist.f -o simv
./simv
```

## Compiling (Vivado XSIM)

```bash
xvlog -sv -f filelist.f
xelab tb_top -s tb_top_sim -L uvm
xsim tb_top_sim -R
```
