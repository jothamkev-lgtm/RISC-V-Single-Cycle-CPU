
module instruction_decoder (

    input logic [31:0] instruction,

    // Register addresses
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,

    // ALU control
    output logic [3:0] alu_op,

    // Register file write control
    output logic reg_write,

    // Instruction validity
    output logic valid

);

    // Extract instruction fields
    logic [6:0] opcode;
    logic [6:0] funct7;
    logic [2:0] funct3;

    always_comb begin

        opcode = instruction[6:0];
        rd     = instruction[11:7];
        funct3 = instruction[14:12];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        funct7 = instruction[31:25];

        // Default values
        alu_op    = 4'b0000;
        reg_write = 1'b0;
        valid     = 1'b0;

        // R-type ADD
        if (opcode == 7'b0110011 &&
            funct3 == 3'b000 &&
            funct7 == 7'b0000000) begin

            alu_op    = 4'b0000;
            reg_write = 1'b1;
            valid     = 1'b1;

        end

        // R-type SUB
        else if (opcode == 7'b0110011 &&
                 funct3 == 3'b000 &&
                 funct7 == 7'b0100000) begin

            alu_op    = 4'b0001;
            reg_write = 1'b1;
            valid     = 1'b1;

        end

    end

endmodule
