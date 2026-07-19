class uart_driver extends uvm_driver #(uart_txn);
    `uvm_component_utils(uart_driver)
    virtual uart_if vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
        `uvm_fatal("DRV", "virtual interface not set for driver")
    endfunction

    task run_phase(uvm_phase phase);
      // Wait for reset to be released
      wait(vif.rst_n === 1'b1);
      @(posedge vif.clk);
      
      forever begin
        uart_txn txn;
        seq_item_port.get_next_item(txn);

        @(posedge vif.clk);
        vif.data_in  <= txn.data;
        vif.tx_start <= 1'b1;
        
        @(posedge vif.clk);
        vif.tx_start <= 1'b0;

        // Wait for transmission to complete
        wait (vif.tx_done === 1'b1);
        @(posedge vif.clk);

        seq_item_port.item_done();
      end
    endtask
endclass
