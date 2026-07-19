`uvm_analysis_imp_decl(_exp)
`uvm_analysis_imp_decl(_act)

class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)

    uvm_analysis_imp_exp #(uart_txn, uart_scoreboard) exp_imp;
    uvm_analysis_imp_act #(uart_txn, uart_scoreboard) act_imp;

    uart_txn expected_q[$];
    int unsigned match_cnt    = 0;
    int unsigned mismatch_cnt = 0;
    int unsigned total_cnt    = 0;    // Added for end-of-test detection

    function new(string name, uvm_component parent);
      super.new(name, parent);
      exp_imp = new("exp_imp", this);
      act_imp = new("act_imp", this);
    endfunction

    function void write_exp(uart_txn txn);
      expected_q.push_back(txn);
    endfunction

    function void write_act(uart_txn txn);
      total_cnt++;    // Track total received
      if (expected_q.size() == 0) begin
        `uvm_error("SCB", $sformatf("Got byte 0x%0h from RX but nothing was expected!", txn.data))
        mismatch_cnt++;
        return;
      end
      begin
        uart_txn exp = expected_q.pop_front();
        if (exp.data === txn.data) begin
          `uvm_info("SCB", $sformatf("PASS: sent 0x%0h, received 0x%0h", exp.data, txn.data), UVM_LOW)
          match_cnt++;
        end else begin
          `uvm_error("SCB", $sformatf("FAIL: sent 0x%0h, received 0x%0h", exp.data, txn.data))
          mismatch_cnt++;
        end
      end
    endfunction

    function void report_phase(uvm_phase phase);
      `uvm_info("SCB", $sformatf("Scoreboard summary: %0d passed, %0d failed, %0d total",
                                  match_cnt, mismatch_cnt, total_cnt), UVM_LOW)
    endfunction
endclass
