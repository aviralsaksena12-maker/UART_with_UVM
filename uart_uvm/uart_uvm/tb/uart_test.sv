class uart_test extends uvm_test;
    `uvm_component_utils(uart_test)
    uart_env env;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = uart_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
      uart_sequence seq;
      int timeout_cycles;
      
      phase.raise_objection(this);
      
      seq = uart_sequence::type_id::create("seq");
      seq.num_txns = 10;
      seq.start(env.agent.sqr);
      
     
      // Each byte: 1 start + 8 data + 1 stop = 10 bits
      // At 5209 cycles/bit with 10ns clock = ~520.9 us per byte
      // 10 bytes = ~5.2ms. Wait with timeout margin.
      timeout_cycles = 0;
      while ((env.scb.match_cnt + env.scb.mismatch_cnt) < 10 && timeout_cycles < 1_000_000) begin
        @(posedge env.agent.drv.vif.clk);
        timeout_cycles++;
      end
      
      if (timeout_cycles >= 1_000_000)
        `uvm_error("TEST", "Timeout waiting for all transactions to complete!")
      
      #1000;  // Small margin for final bit propagation
      phase.drop_objection(this);
    endtask
endclass
