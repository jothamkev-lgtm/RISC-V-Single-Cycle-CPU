`timescale 1ns / 1ps
module register_file_32x32 (
    input logic clk,
    input logic reset,
    // Read port 1
    input  logic [4:0] rs1_addr,
    output logic [31:0] rs1_data,
    // Read port 2
    input  logic [4:0] rs2_addr,
    output logic [31:0] rs2_data,
    // Write port
    input  logic [4:0] rd_addr,
    input  logic [31:0] rd_data,
    input  logic wr_en
);
    // 32 registers, each 32 bits wide
    logic [31:0] regs [0:31];
    integer i;
    // Reset all registers
    always_ff @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else if (wr_en && rd_addr != 5'd0) begin
            regs[rd_addr] <= rd_data;
        end
    end
    // Two asynchronous read ports
    always_comb begin
        if (rs1_addr == 5'd0)
            rs1_data = 32'b0;
        else
            rs1_data = regs[rs1_addr];
        if (rs2_addr == 5'd0)
            rs2_data = 32'b0;
        else
            rs2_data = regs[rs2_addr];
    end
endmodule
