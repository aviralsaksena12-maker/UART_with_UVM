class uart_env extends uvm_env;
    `uvm_component_utils(uart_env)
    uart_agent       agent;
    rx_monitor       rxmon;
    uart_scoreboard  scb;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent = uart_agent::type_id::create("agent", this);
      rxmon = rx_monitor::type_id::create("rxmon", this);
      scb   = uart_scoreboard::type_id::create("scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      agent.txmon.ap.connect(scb.exp_imp);
      rxmon.ap.connect(scb.act_imp);
    endfunction
endclass
