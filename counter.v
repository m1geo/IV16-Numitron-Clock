// Counter with Overflow
// George Smart, M1GEO
// https://www.george-smart.co.uk/Numitron-Clock
// 19/10/2019 - 25/11/2019

module counter
	#(
	parameter MAX_VAL = 59
	)(
    input			pulse,
	input			rstn,
    output	[6:0]	value,
	output			ovfl
);
	
	reg [6:0] rcount;
	reg rovfl;
	
	always @ (posedge pulse or negedge rstn) begin
		if (~rstn) begin
			rcount <= 'b0;
		end else begin
			if (rcount == MAX_VAL) begin
				rcount <= 'b0;
				rovfl <= 'b1;
			end else begin
				rcount <= rcount + 1'b1;
				rovfl <= 'b0;
			end
		end
	end
	
	assign ovfl = rovfl;
	assign value = rcount;
endmodule
