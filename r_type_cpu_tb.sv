
module r_type_cpu_tb;

    logic clk;
    logic reset;

    logic [31:0] pc_debug;
    logic [31:0] instruction_debug;
    logic [31:0] alu_result_debug;

    logic [4:0] rs1_debug;
    logic [4:0] rs2_debug;
    logic [4:0] rd_debug;

    logic reg_write_debug;
    logic valid_debug;

    // Instantiate CPU

    r_type_cpu dut (

        .clk(clk),
        .reset(reset),

        .pc_debug(pc_debug),
        .instruction_debug(instruction_debug),
        .alu_result_debug(alu_result_debug),

        .rs1_debug(rs1_debug),
        .rs2_debug(rs2_debug),
        .rd_debug(rd_debug),

        .reg_write_debug(reg_write_debug),
        .valid_debug(valid_debug)

    );

    // 10 ns clock

    always #5 clk <= ~clk;

    integer i;

    initial begin

        clk = 0;
        reset = 1;

        // Reset CPU
        @(posedge clk);
        #1;

        reset = 0;

        // Initialize x1 = 10 and x2 = 3
        // Simulation-only hierarchical initialization
        dut.RF.regs[1] = 32'd10;
        dut.RF.regs[2] = 32'd3;

        $display("\n===== RISC-V CPU EXECUTION =====");

        // Execute 10 instructions
        for (i = 0; i < 10; i = i + 1) begin

            @(negedge clk);

            $display(
                "PC=%0d | Instruction=%h | rs1=x%0d | rs2=x%0d | rd=x%0d | ALU Result=%0d",
                pc_debug,
                instruction_debug,
                rs1_debug,
                rs2_debug,
                rd_debug,
                alu_result_debug
            );

            @(posedge clk);
            #1;

        end

        $display("\n===== FINAL REGISTER VALUES =====");

        for (i = 0; i < 8; i = i + 1) begin

            $display(
                "x%0d = %0d (0x%h)",
                i,
                dut.RF.regs[i],
                dut.RF.regs[i]
            );

        end

        $finish;

    end

endmodule
