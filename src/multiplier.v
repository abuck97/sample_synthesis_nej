`timescale 1ns/1ps
module multiplier(
    input [3:0] X,
    input [3:0] Y,
    input clk,
    input rst,
    output reg [7:0] P
);

    // partial products
    wire [3:0] pp0, pp1, pp2, pp3;
    reg [3:0] X_reg, Y_reg;
    assign pp0 = X_reg & {4{Y_reg[0]}};
    assign pp1 = X_reg & {4{Y_reg[1]}};
    assign pp2 = X_reg & {4{Y_reg[2]}};
    assign pp3 = X_reg & {4{Y_reg[3]}};


    wire cout1, cout2, cout3;
    wire [3:0] s1, s2, s3;
    adder_4_bit a1(
        .A(pp1),
        .B({1'b0,pp0[3:1]}),
        .carry_in(1'b0),
        .carry_out(cout1),
        .sum_out(s1)
    );
    adder_4_bit a2(
        .A(pp2),
        .B({cout1,s1[3:1]}),
        .carry_in(1'b0),
        .carry_out(cout2),
        .sum_out(s2)
    );
    adder_4_bit a3(
        .A(pp3),
        .B({cout2,s2[3:1]}),
        .carry_in(1'b0),
        .carry_out(cout3),
        .sum_out(s3)
    );
    always @ (posedge clk) begin
        if (rst) begin
            P <= 8'd0;
            X_reg <= 4'd0;
            Y_reg <= 4'd0;
        end else begin
            P <= {cout3, s3, s2[0], s1[0], pp0[0]};
            X_reg <= X;
            Y_reg <= Y;
        end
    end

endmodule  

module adder_4_bit(
    input [3:0] A,
    input [3:0] B,
    input carry_in,
    output [3:0] sum_out,
    output carry_out
);
    wire c0, c1, c2;
    full_adder a0(
        .A(A[0]),
        .B(B[0]),
        .carry_in(carry_in),
        .sum_out(sum_out[0]),
        .carry_out(c0)
    );
    full_adder a1(
        .A(A[1]),
        .B(B[1]),
        .carry_in(c0),
        .sum_out(sum_out[1]),
        .carry_out(c1)
    );
    full_adder a2(
        .A(A[2]),
        .B(B[2]),
        .carry_in(c1),
        .sum_out(sum_out[2]),
        .carry_out(c2)
    );
    full_adder a3(
        .A(A[3]),
        .B(B[3]),
        .carry_in(c2),
        .sum_out(sum_out[3]),
        .carry_out(carry_out)
    );
    
endmodule
