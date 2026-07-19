class rx_monitor extends uvm_monitor;
    `uvm_component_utils(rx_monitor)
    virtual uart_if vif;
    uvm_analysis_port #(uart_txn) ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
        `uvm_fatal("RXMON", "virtual interface not set for rx_monitor")
    endfunction

    task run_phase(uvm_phase phase);
      forever begin
        uart_txn txn;
        @(posedge vif.clk);
        if (vif.rx_done) begin
          txn = uart_txn::type_id::create("txn");
          txn.data = vif.data_out;
          ap.write(txn);
        end
      end
    endtask
endclass
