class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)
    uvm_sequencer #(uart_txn) sqr;
    uart_driver               drv;
    tx_monitor                txmon;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sqr   = uvm_sequencer#(uart_txn)::type_id::create("sqr", this);
      drv   = uart_driver::type_id::create("drv", this);
      txmon = tx_monitor::type_id::create("txmon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass
