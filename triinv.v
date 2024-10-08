module Triangular_Inversion #(parameter N = 3, W = 8)
(
    input clk,
    input rst,
    input start,
    input [W*N*N-1:0] L_in,  // Input lower triangular matrix
    output reg done,
    output reg [W*N*N-1:0] L_inv_out // Inverted matrix
);

reg [W-1:0] L_inv[N-1:0][N-1:0]; // Matrix to store inverse
wire [W-1:0] L[N-1:0][N-1:0]; // Flattened input matrix

generate
    genvar x, y;
    for (x = 0; x < N; x = x + 1) begin
        for (y = 0; y <= x; y = y + 1) begin
            assign L[x][y] = L_in[W*(x*N + y) +: W];
        end
    end
endgenerate

integer k, i, j;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        done <= 0;
    end else if (start) begin
        // Invert diagonal elements
        for (k = 0; k < N; k = k + 1) begin
            L_inv[k][k] <= 1 / L[k][k]; // Diagonal element inversion
        end
        
        // Back substitution for off-diagonal elements
        for (i = 1; i < N; i = i + 1) begin
            for (j = 0; j < i; j = j + 1) begin
                L_inv[i][j] <= -L[i][j] / L[i][i]; // Off-diagonal inversion
            end
        end

        // Output the flattened inverted matrix
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j <= i; j = j + 1) begin
                L_inv_out[W*(i*N + j) +: W] <= L_inv[i][j];
            end
        end
        done <= 1;
    end
end

endmodule
