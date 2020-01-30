// Noise display
// George Smart, M1GEO
// https://www.george-smart.co.uk/Numitron-Clock
// 19/10/2019 - 25/11/2019

module noise(
	input clk,
	input rstn,
	output reg [6:0] noiseA,
	output reg [6:0] noiseB,
	output reg [6:0] noiseC,
	output reg [6:0] noiseD,
	output reg [6:0] noiseE,
	output reg [6:0] noiseF,
	output reg [6:0] noiseG,
	output reg [6:0] noiseH
);

	wire [9:0] noise_out;
	LFSR_Plus #(.W(10)) noise_high ( .clk(clk), .n_reset(rstn), .enable(1'b1), .u_noise_out(noise_out), .g_noise_out() );
	
	always @(noise_out[2:0]) begin
		case (noise_out[2:0])
            3'h0 : noiseA <= noise_out[9:3];
            3'h1 : noiseB <= noise_out[9:3];
            3'h2 : noiseC <= noise_out[9:3];
            3'h3 : noiseD <= noise_out[9:3];
            3'h4 : noiseE <= noise_out[9:3];
            3'h5 : noiseF <= noise_out[9:3];
            3'h6 : noiseG <= noise_out[9:3];
            3'h7 : noiseH <= noise_out[9:3];
		endcase
	end

endmodule