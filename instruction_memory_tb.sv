
module instruction_memory_tb;

    logic [3:0] addr;
    logic [31:0] instruction;

    instruction_memory dut (
        .addr(addr),
        .instruction(instruction)
    );

    initial begin

        $display("INSTRUCTION MEMORY TEST");

        for (int i = 0; i < 10; i++) begin

            addr = i[3:0];
            #5;

            $display(
                "Address = %0d | Instruction = %h | rd = x%0d | rs1 = x%0d | rs2 = x%0d",
                addr,
                instruction,
                instruction[11:7],
                instruction[19:15],
                instruction[24:20]
            );

        end

        $finish;

    end

endmodule
