module Matrix_Inversion_Top #(parameter N = 3, W = 8) // N: Matrix size, W: Data width
(
    input clk,
    input rst,
    input start,
    input [W*N*N-1:0] matrix_in,  // Input matrix (flattened)
    output reg done,
    output [W*N*N-1:0] matrix_out // Output matrix (flattened)
);

// Internal signals
wire [W*N*N-1:0] L_out, D_out, L_inv_out, final_matrix;
wire LDL_done, Inv_done, Mul_done;

// Instantiate LDL Factorization module
LDL_Factorization #(.N(N), .W(W)) LDL (
    .clk(clk),
    .rst(rst),
    .start(start),
    .matrix_in(matrix_in),
    .done(LDL_done),
    .L_out(L_out),
    .D_out(D_out)
);

// Instantiate Triangular Matrix Inversion module
Triangular_Inversion #(.N(N), .W(W)) TriInv (
    .clk(clk),
    .rst(rst),
    .start(LDL_done),
    .L_in(L_out),
    .done(Inv_done),
    .L_inv_out(L_inv_out)
);

// Instantiate Matrix Multiplication module (L_inv * D * L_inv^T)
Matrix_Multiplication #(.N(N), .W(W)) MatMul (
    .clk(clk),
    .rst(rst),
    .start(Inv_done),
    .matrix_A(L_inv_out),
    .matrix_B(D_out),
    .done(Mul_done),
    .matrix_out(final_matrix)
);

// Done signal
always @(posedge clk or posedge rst) begin
    if (rst) begin
        done <= 0;
    end else if (Mul_done) begin
        done <= 1;
    end
end

assign matrix_out = final_matrix;

endmodule
