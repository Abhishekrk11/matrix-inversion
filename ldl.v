module LDL_Factorization #(parameter N = 3, W = 8)
(
    input clk,
    input rst,
    input start,
    input [W*N*N-1:0] matrix_in,  // Input matrix (flattened)
    output reg done,
    output reg [W*N*N-1:0] L_out, // Lower triangular matrix
    output reg [W*N*N-1:0] D_out  // Diagonal matrix
);

reg [W-1:0] L[N-1:0][N-1:0]; // Lower triangular matrix
reg [W-1:0] D[N-1:0];        // Diagonal matrix
wire [W-1:0] A[N-1:0][N-1:0]; // Input matrix

// Flatten the input matrix for easier indexing
generate
    genvar x, y;
    for (x = 0; x < N; x = x + 1) begin
        for (y = 0; y < N; y = y + 1) begin
            assign A[x][y] = matrix_in[W*(x*N + y) +: W];
        end
    end
endgenerate

integer k, i, j;
reg [W-1:0] sum;  // Register for holding summation

always @(posedge clk or posedge rst) begin
    if (rst) begin
        done <= 0;
        // Initialize L and D to 0 on reset
        for (i = 0; i < N; i = i + 1) begin
            D[i] <= 0;
            for (j = 0; j < N; j = j + 1) begin
                L[i][j] <= 0;
            end
        end
    end else if (start) begin
        // LDL Factorization
        for (k = 0; k < N; k = k + 1) begin
            // Compute the diagonal element D[k]
            sum = 0;
            for (j = 0; j < k; j = j + 1) begin
                sum = sum + L[k][j] * L[k][j] * D[j];
            end
            D[k] <= A[k][k] - sum;

            // Compute the lower triangular elements L[i][k]
            for (i = k + 1; i < N; i = i + 1) begin
                sum = 0;
                for (j = 0; j < k; j = j + 1) begin
                    sum = sum + L[i][j] * L[k][j] * D[j];
                end
                L[i][k] <= (A[i][k] - sum) / D[k];
            end

            // Set diagonal elements of L to 1 (unit lower triangular matrix)
            L[k][k] <= 1;
        end
        
        // Flatten the output L and D matrices for output
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j <= i; j = j + 1) begin
                L_out[W*(i*N + j) +: W] <= L[i][j];
            end
            D_out[W*i +: W] <= D[i];
        end
        done <= 1;
    end
end

endmodule
