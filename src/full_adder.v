`timescale 1ns/1ps
module full_adder(
	input A,
	input B,
	input carry_in,
	output sum_out,
	output carry_out
);

	assign sum_out = carry_in ^ A ^ B;
	assign carry_out = (A & B) | (A & carry_in) | (B & carry_in);
endmodule
