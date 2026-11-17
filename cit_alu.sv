`timescale 1ns/1ps
module cit_alu #(
    parameter W = 32
)(
    input  logic [W-1:0] a,
    input  logic [W-1:0] b,
    input  logic [$clog2(W)-1:0] shamt,
    input  logic [3:0] alu_op,

    output logic [W-1:0] result,
    output logic zero,
    output logic overflow
);
    logic [W-1:0] result_internal;
    always_comb begin
        result_internal = '0;
        overflow = 1'b0;
        case (alu_op)
            4'b0000: begin
                result_internal = a + b;
                overflow =
                    (~a[W-1] & ~b[W-1] & result_internal[W-1]) |
                    ( a[W-1] &  b[W-1] & ~result_internal[W-1]);
            end
            4'b0001: begin
                result_internal = a - b;
                overflow = (~a[W-1] &  b[W-1] &  result_internal[W-1]) | 
                           ( a[W-1] & ~b[W-1] & ~result_internal[W-1]);
            end
            default: begin
                result_internal = '0;
                overflow = 1'b0;
            end
        endcase
    end
    assign result = result_internal;
    assign zero = (result == '0);
endmodule
