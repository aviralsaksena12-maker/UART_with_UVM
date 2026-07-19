class uart_sequence extends uvm_sequence #(uart_txn);
    `uvm_object_utils(uart_sequence)

    int unsigned num_txns = 10;

    function new(string name = "uart_sequence");
      super.new(name);
    endfunction

    task body();
      uart_txn txn;
      repeat (num_txns) begin
        txn = uart_txn::type_id::create("txn");
        start_item(txn);
        assert(txn.randomize());
        finish_item(txn);
      end
    endtask
endclass
