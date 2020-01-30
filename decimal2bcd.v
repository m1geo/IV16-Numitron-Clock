// Decimal to BCD
// George Smart, M1GEO
// https://www.george-smart.co.uk/Numitron-Clock
// Inspired by https://johnloomis.org/ece314/notes/devices/binary_to_BCD/bin_to_bcd.html
// 19/10/2019 - 25/11/2019

module add3(
	input [3:0] in,
	output reg [3:0] out
);

always @ (in)
	case (in)
		4'b0000: out <= 4'b0000;
		4'b0001: out <= 4'b0001;
		4'b0010: out <= 4'b0010;
		4'b0011: out <= 4'b0011;
		4'b0100: out <= 4'b0100;
		4'b0101: out <= 4'b1000;
		4'b0110: out <= 4'b1001;
		4'b0111: out <= 4'b1010;
		4'b1000: out <= 4'b1011;
		4'b1001: out <= 4'b1100;
		default: out <= 4'b0000;
	endcase
endmodule

module dec2bcd(
    input  	[6:0] decimal,
    output [3:0] bcd_low,
	output [3:0] bcd_high
	);
	
	wire [7:0] A;
	assign A = {1'b0, decimal};
	
	wire [3:0] c1,c2,c3,c4,c5,c6,c7;
	wire [3:0] d1,d2,d3,d4,d5,d6,d7;

	assign d1 = {1'b0,A[7:5]};
	assign d2 = {c1[2:0],A[4]};
	assign d3 = {c2[2:0],A[3]};
	assign d4 = {c3[2:0],A[2]};
	assign d5 = {c4[2:0],A[1]};
	assign d6 = {1'b0,c1[3],c2[3],c3[3]};
	assign d7 = {c6[2:0],c4[3]};
	add3 m1(d1,c1);
	add3 m2(d2,c2);
	add3 m3(d3,c3);
	add3 m4(d4,c4);
	add3 m5(d5,c5);
	add3 m6(d6,c6);
	add3 m7(d7,c7);
	assign bcd_low = {c5[2:0],A[0]};
	assign bcd_high = {c7[2:0],c5[3]};

endmodule