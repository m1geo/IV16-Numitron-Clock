// Button debounce
// George Smart, M1GEO
// https://www.george-smart.co.uk/Numitron-Clock
// 19/10/2019 - 25/11/2019

module button_debounce(
    input  clk,
	input  rstn,
	input  but_in,
	output but_out
);

	reg [99:0] pipe;

	always @ (posedge clk  or negedge rstn) begin
		if (~rstn) begin
			pipe <= 'b0;
		end else begin
			pipe <= {pipe[98:0], but_in};
		end
	end
	
	assign but_out = !(|pipe); // or all bits together. success is all bits low. this causes output high

endmodule