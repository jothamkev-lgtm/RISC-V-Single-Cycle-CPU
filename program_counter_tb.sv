
module program_counter_tb;

    logic clk;
    logic reset;
    logic [31:0] pc;

    program_counter dut (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    // 10 ns clock period
    always #5 clk <= ~clk;

    initial begin

        clk = 0;
        reset = 1;

        // Apply reset
        @(posedge clk);
        #1;

        $display("PC after reset = %0d", pc);

        reset = 0;

        // Check next five PC values
        repeat (5) begin

            @(posedge clk);
            #1;

            $display("PC = %0d", pc);

        end

        $finish;

    end

endmodule
