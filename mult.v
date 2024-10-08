module Matrix_Multiplication #(parameter N = 3, W = 8)
(
    input clk,
    input rst,
    input start,
    input [W*N*N-1:0] matrix_A,  // First matrix
    input [W*N*N-1:0] matrix_B,  // Second matrix
    output reg done,
    output reg [W*N*N-1:0] matrix_out // Resulting matrix
);

reg [W-1:0] result[N-1:0][N-1:0]; // Result matrix
wire [W-1:0] A[N-1:0][N-1:0]; // Flattened input matrix A
wire [W-1:0] B[N-1:0][N-1:0]; // Flattened input matrix B

generate
    genvar x, y;
    for (x = 0; x < N; x = x + 1) begin
        for (y = 0; y < N; y = y + 1) begin
            assign A[x][y] = matrix_A[W*(x*N + y) +: W];
            assign B[x][y] = matrix_B[W*(x*N + y) +: W];
        end
    end
endgenerate
integer i,j,k;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        done <= 0;
    end else if (start) begin
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                result[i][j] <= 0;
                for (k = 0; k < N; k = k + 1) begin
                    result[i][j] <= result[i][j] + A[i][k] * B[k][j];
                end
            end
        end
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                matrix_out[W*(i*N + j) +: W] <= result[i][j];
            end
        end
        done <= 1;
    end
end

endmodule
