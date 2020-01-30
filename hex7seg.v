// HEX to 7-SEGMENT Decoder
// George Smart, M1GEO
// https://www.george-smart.co.uk/Numitron-Clock
// 19/10/2019 - 25/11/2019

module hexto7segment(
    input  [3:0] hex,
    output [6:0] segs
);

	reg[6:0] r_seg;
	
	always @(hex) begin
		case (hex)
            4'h0 : r_seg <= 7'b0111111;
            4'h1 : r_seg <= 7'b0000110;
            4'h2 : r_seg <= 7'b1011011;
            4'h3 : r_seg <= 7'b1001111;
            4'h4 : r_seg <= 7'b1100110;
            4'h5 : r_seg <= 7'b1101101;
            4'h6 : r_seg <= 7'b1111101;
            4'h7 : r_seg <= 7'b0000111;
            4'h8 : r_seg <= 7'b1111111;
            4'h9 : r_seg <= 7'b1101111;
            4'hA : r_seg <= 7'b1110111;
            4'hB : r_seg <= 7'b1111100;
            4'hC : r_seg <= 7'b0111001;
            4'hD : r_seg <= 7'b1011110;
            4'hE : r_seg <= 7'b1111001;
            4'hF : r_seg <= 7'b1110001;
		endcase
	end

	assign segs = r_seg;
endmodule