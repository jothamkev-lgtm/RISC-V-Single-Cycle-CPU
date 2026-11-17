
module r_type_cpu (
    input logic clk,
    input logic reset,

    output logic [31:0] pc_debug,
    output logic [31:0] instruction_debug,
    output logic [31:0] alu_result_debug,

    output logic [4:0] rs1_debug,
    output logic [4:0] rs2_debug,
    output logic [4:0] rd_debug,

    output logic reg_write_debug,
    output logic valid_debug
);

    logic [31:0] pc;
    logic [3:0] imem_addr;
    logic [31:0] instruction;

    logic [4:0] rs1, rs2, rd;
    logic [3:0] alu_op;

    logic reg_write, valid;

    logic [31:0] rs1_data, rs2_data;
    logic [31:0] alu_result;
    logic zero, overflow;

    // 1. Program Counter
    program_counter PC (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    // 2. Convert byte address into instruction word address
    assign imem_addr = pc[5:2];

    // 3. Instruction Memory
    instruction_memory IMEM (
        .addr(imem_addr),
        .instruction(instruction)
    );

    // 4. Instruction Decoder
    instruction_decoder DECODER (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .valid(valid)
    );

    // 5. Register File
    register_file_32x32 RF (
        .clk(clk),
        .reset(reset),
        .rs1_addr(rs1),
        .rs1_data(rs1_data),
        .rs2_addr(rs2),
        .rs2_data(rs2_data),
        .rd_addr(rd),
        .rd_data(alu_result),
        .wr_en(reg_write && valid)
    );

    // 6. ALU
    cit_alu #(.W(32)) ALU (
        .a(rs1_data),
        .b(rs2_data),
        .shamt(5'b00000),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(zero),
        .overflow(overflow)
    );

    // Debug outputs
    assign pc_debug = pc;
    assign instruction_debug = instruction;
    assign alu_result_debug = alu_result;

    assign rs1_debug = rs1;
    assign rs2_debug = rs2;
    assign rd_debug = rd;

    assign reg_write_debug = reg_write;
    assign valid_debug = valid;

endmodule
