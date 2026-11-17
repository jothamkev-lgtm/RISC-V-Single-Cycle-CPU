`timescale 1ns / 1ps

module instruction_memory (
    input  logic [3:0]  addr,
    output logic [31:0] instruction
);

    // 16 locations, each 32 bits
    logic [31:0] mem [0:15];

    // Function to encode R-type instructions using bit shifts
    function automatic logic [31:0] encode_r (
        input logic [4:0] rd,
        input logic [4:0] rs1,
        input logic [4:0] rs2,
        input logic [2:0] funct3,
        input logic       is_sub
    );
        logic [6:0] funct7;
        begin
            funct7 = is_sub ? 7'b0100000 : 7'b0000000;
            encode_r = (32'(funct7) << 25) |
                       (32'(rs2)    << 20) |
                       (32'(rs1)    << 15) |
                       (32'(funct3) << 12) |
                       (32'(rd)     << 7)  |
                       32'b0110011; // R-type opcode
        end
    endfunction

    // Preload instructions
    initial begin
        // Default all locations to NOP (addi x0, x0, 0)
        for (int i = 0; i < 16; i++) begin
            mem[i] = 32'h00000013;
        end

        // Five ADD instructions (funct3 = 3'b000, is_sub = 1'b0)
        mem[0] = encode_r(5'd3, 5'd1, 5'd2, 3'b000, 1'b0); // ADD x3, x1, x2
        mem[1] = encode_r(5'd4, 5'd3, 5'd2, 3'b000, 1'b0); // ADD x4, x3, x2
        mem[2] = encode_r(5'd5, 5'd4, 5'd1, 3'b000, 1'b0); // ADD x5, x4, x1
        mem[3] = encode_r(5'd6, 5'd5, 5'd2, 3'b000, 1'b0); // ADD x6, x5, x2
        mem[4] = encode_r(5'd7, 5'd6, 5'd1, 3'b000, 1'b0); // ADD x7, x6, x1

        // Five SUB instructions (funct3 = 3'b000, is_sub = 1'b1)
        mem[5] = encode_r(5'd3, 5'd7, 5'd1, 3'b000, 1'b1); // SUB x3, x7, x1
        mem[6] = encode_r(5'd4, 5'd3, 5'd2, 3'b000, 1'b1); // SUB x4, x3, x2
        mem[7] = encode_r(5'd5, 5'd4, 5'd1, 3'b000, 1'b1); // SUB x5, x4, x1
        mem[8] = encode_r(5'd6, 5'd5, 5'd2, 3'b000, 1'b1); // SUB x6, x5, x2
        mem[9] = encode_r(5'd7, 5'd6, 5'd1, 3'b000, 1'b1); // SUB x7, x6, x1
    end

    // Asynchronous instruction read
    always_comb begin
        instruction = mem[addr];
    end

endmodule
