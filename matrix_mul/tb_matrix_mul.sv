`timescale 1ns / 1ps

module tb_matrix_mul;

    parameter BITS = 8;
    parameter WIDTH = 3;
    parameter HEIGHT_A = 2;
    parameter WIDTH_B = 3;

    logic clk;
    logic reset;
    logic [BITS-1:0] i_array_a [HEIGHT_A-1:0][WIDTH-1:0];
    logic [BITS-1:0] i_array_b [WIDTH-1:0][WIDTH_B-1:0];

    logic [2*BITS-1:0] o_array_res [HEIGHT_A-1:0][WIDTH_B-1:0];

    matrix_mul #(
        .BITS(BITS),
        .WIDTH(WIDTH),
        .HEIGHT_A(HEIGHT_A),
        .WIDTH_B(WIDTH_B)
    ) uut (
        .clk(clk),
        .reset(reset),
        .i_array_a(i_array_a),
        .i_array_b(i_array_b),
        .o_array_res(o_array_res)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;

        #10 reset = 1;
        
        i_array_a[0][0] = 4'b0011; // 3
        i_array_a[0][1] = 4'b0100; // 4
        i_array_a[0][2] = 4'b0101; // 5
        i_array_a[1][0] = 4'b0110; // 6
        i_array_a[1][1] = 4'b0111; // 7
        i_array_a[1][2] = 4'b1000; // 8

        i_array_b[0][0] = 4'b0001; // 1
        i_array_b[0][1] = 4'b0010; // 2
        i_array_b[0][2] = 4'b0011; // 3
        i_array_b[1][0] = 4'b0100; // 4
        i_array_b[1][1] = 4'b0101; // 5
        i_array_b[1][2] = 4'b0110; // 6
        i_array_b[2][0] = 4'b0111; // 7
        i_array_b[2][1] = 4'b1000; // 8
        i_array_b[2][2] = 4'b1001; // 9

        #10;
        
        $display("Initial matrix A:");
        for (int i = 0; i < HEIGHT_A; i++) begin
            for (int j = 0; j < WIDTH; j++) begin
                $write("%0d ", i_array_a[i][j]);
            end
            $display("");
        end

        $display("Initial matrix B:");
        for (int i = 0; i < WIDTH; i++) begin
            for (int j = 0; j < WIDTH_B; j++) begin
                $write("%0d ", i_array_b[i][j]);
            end
            $display("");
        end

        #100;

        $display("Result matrix:");
        for (int i = 0; i < HEIGHT_A; i++) begin
            for (int j = 0; j < WIDTH_B; j++) begin
                $write("%0d ", o_array_res[i][j]);
            end
            $display("");
        end
        
        #10 reset = 0;

        #10 reset = 1;
        
        i_array_a[0][0] = 4'b0001; // 1
        i_array_a[0][1] = 4'b0000; // 0
        i_array_a[0][2] = 4'b0000; // 0
        i_array_a[1][0] = 4'b0000; // 0
        i_array_a[1][1] = 'hFB; // -5
        i_array_a[1][2] = 4'b0000; // 0

        i_array_b[0][0] = 4'b0001; // 1
        i_array_b[0][1] = 4'b0010; // 2
        i_array_b[0][2] = 4'b0011; // 3
        i_array_b[1][0] = 4'b0100; // 4
        i_array_b[1][1] = 4'b0101; // 5
        i_array_b[1][2] = 4'b0110; // 6
        i_array_b[2][0] = 4'b0111; // 7
        i_array_b[2][1] = 4'b1000; // 8
        i_array_b[2][2] = 4'b1001; // 9

        #10;
        
        $display("Initial matrix A:");
        for (int i = 0; i < HEIGHT_A; i++) begin
            for (int j = 0; j < WIDTH; j++) begin
                $write("%0d ", i_array_a[i][j]);
            end
            $display("");
        end

        $display("Initial matrix B:");
        for (int i = 0; i < WIDTH; i++) begin
            for (int j = 0; j < WIDTH_B; j++) begin
                $write("%0d ", i_array_b[i][j]);
            end
            $display("");
        end

        #100;

        $display("Result matrix:");
        for (int i = 0; i < HEIGHT_A; i++) begin
            for (int j = 0; j < WIDTH_B; j++) begin
                $write("%0d ", o_array_res[i][j]);
            end
            $display("");
        end
        $finish;
    end

endmodule
