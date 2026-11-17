
module register_file_tb;

    logic clk;
    logic reset;

    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [4:0] rd_addr;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] rd_data;

    logic wr_en;

    register_file_32x32 dut (
        .clk(clk),
        .reset(reset),

        .rs1_addr(rs1_addr),
        .rs1_data(rs1_data),

        .rs2_addr(rs2_addr),
        .rs2_data(rs2_data),

        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .wr_en(wr_en)
    );

    // Clock generation: 10 ns period
    always #5 clk <= ~clk;

    initial begin

        clk = 0;
        reset = 1;
        wr_en = 0;

        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr  = 0;
        rd_data  = 0;

        // Reset
        #10;
        reset = 0;

        // Write 25 into x5
        @(negedge clk);
        wr_en = 1;
        rd_addr = 5;
        rd_data = 25;

        @(posedge clk);
        #1;

        // Disable write
        wr_en = 0;

        // Read x5 through both ports
        rs1_addr = 5;
        rs2_addr = 5;

        #1;

        $display("Read port 1 = %0d", rs1_data);
        $display("Read port 2 = %0d", rs2_data);

        if (rs1_data == 25 && rs2_data == 25)
            $display("PASS: Both read ports work");
        else
            $display("FAIL: Read operation");

        // Attempt to write 100 into x0
        @(negedge clk);
        wr_en = 1;
        rd_addr = 0;
        rd_data = 100;

        @(posedge clk);
        #1;

        wr_en = 0;
        rs1_addr = 0;

        #1;

        $display("x0 value = %0d", rs1_data);

        if (rs1_data == 0)
            $display("PASS: x0 remains zero");
        else
            $display("FAIL: x0 was modified");

        $finish;

    end

endmodule
