// 32.768 kHz to 1 Hz Divider
// George Smart, M1GEO
// https://www.george-smart.co.uk/Numitron-Clock
// 19/10/2019 - 25/11/2019

module pps_divider(
    input	clk,
	input	rstn,
    output	pps,
	output	fst
);
	
	reg [14:0] count;
	
	always @ (posedge clk  or negedge rstn) begin
		if (~rstn) begin
			count <= 'b0;
		end else begin
			count <= count + 1'b1;
		end
	end
	
	assign pps = count[14]; // pulse per second
	assign fst = count[10]; // fast for colons
endmodule
