
module instruction_decoder_tb;

    logic [31:0] instruction;

    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [3:0] alu_op;
    logic reg_write;
    logic valid;

    instruction_decoder dut (

        .instruction(instruction),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .alu_op(alu_op),
        .reg_write(reg_write),
        .valid(valid)

    );

    initial begin

        // Test ADD x3, x1, x2
        instruction = 32'h002081b3;
        #5;

        $display("ADD TEST");
        $display("rs1 = x%0d", rs1);
        $display("rs2 = x%0d", rs2);
        $display("rd = x%0d", rd);
        $display("alu_op = %b", alu_op);
        $display("reg_write = %b", reg_write);
        $display("valid = %b", valid);

        if (rs1 == 1 && rs2 == 2 && rd == 3 &&
            alu_op == 4'b0000 && reg_write && valid)
            $display("PASS: ADD decoded correctly");
        else
            $display("FAIL: ADD decoding");

        // Test SUB x3, x7, x1
        instruction = 32'h401381b3;
        #5;

        $display("\nSUB TEST");
        $display("rs1 = x%0d", rs1);
        $display("rs2 = x%0d", rs2);
        $display("rd = x%0d", rd);
        $display("alu_op = %b", alu_op);
        $display("reg_write = %b", reg_write);
        $display("valid = %b", valid);

        if (rs1 == 7 && rs2 == 1 && rd == 3 &&
            alu_op == 4'b0001 && reg_write && valid)
            $display("PASS: SUB decoded correctly");
        else
            $display("FAIL: SUB decoding");

        // Test unsupported instruction
        instruction = 32'h00000013;
        #5;

        $display("\nINVALID INSTRUCTION TEST");
        $display("valid = %b", valid);
        $display("reg_write = %b", reg_write);

        if (!valid && !reg_write)
            $display("PASS: Unsupported instruction rejected");
        else
            $display("FAIL: Invalid instruction");

        $finish;

    end

endmodule
