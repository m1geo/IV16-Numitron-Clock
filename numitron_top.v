// Numitron FPGA Clock Top Level
// George Smart, M1GEO
// https://www.george-smart.co.uk/Numitron-Clock
// 19/10/2019 - 25/11/2019

module numitron_top(
	input CLK_32K,
	input nRESET,
	input H_ADJ,
	input M_ADJ,
	input NOISE_BUT,
	output pps,
	output [6:0] segA,
	output [6:0] segB,
	output [6:0] segC,
	output [6:0] segD,
	output [6:0] segE,
	output [6:0] segF,
	output [3:0] col
);

wire CLK_1HZ; // one pulse per second
wire CLK_16HZ; // 16 pulse per second

wire [3:0] hl; // low hours digit
wire [3:0] hh; // high hours digit
wire [3:0] ml; // low minutes digit
wire [3:0] mh; // high minutes digit
wire [3:0] sl; // low seconds digit
wire [3:0] sh; // high seconds digit

wire [6:0] d_hours;   // display hours
wire [6:0] d_minutes; // display minutes
wire [6:0] d_seconds; // display seconds

wire [6:0] w_segA;
wire [6:0] w_segB;
wire [6:0] w_segC;
wire [6:0] w_segD;
wire [6:0] w_segE;
wire [6:0] w_segF;

// Divide 32.768 kHz system clock down to 1 Hz
pps_divider opps_div(.clk(CLK_32K), .rstn(nRESET), .pps(CLK_1HZ), .fst(CLK_16HZ));

// Debounce Set Buttons
wire m_adj_db;
button_debounce m_adj_dbr(.clk(CLK_32K), .rstn(nRESET), .but_in(M_ADJ), .but_out(m_adj_db));
wire h_adj_db;
button_debounce h_adj_dbr(.clk(CLK_32K), .rstn(nRESET), .but_in(H_ADJ), .but_out(h_adj_db));
wire noise_db;
button_debounce noise_dbr(.clk(CLK_32K), .rstn(nRESET), .but_in(NOISE_BUT), .but_out(noise_db));

// Convert 4-bit hex into 7-segment data
hexto7segment s0(.segs(w_segF), .hex(sl));
hexto7segment s1(.segs(w_segE), .hex(sh));
hexto7segment m0(.segs(w_segD), .hex(ml));
hexto7segment m1(.segs(w_segC), .hex(mh));
hexto7segment h0(.segs(w_segB), .hex(hl));
hexto7segment h1(.segs(w_segA), .hex(hh));

// Convert decimal number (00-99) to two BCD nibbles
dec2bcd hrs(.decimal(d_hours), .bcd_low(hl), .bcd_high(hh));
dec2bcd mns(.decimal(d_minutes), .bcd_low(ml), .bcd_high(mh));
dec2bcd scs(.decimal(d_seconds), .bcd_low(sl), .bcd_high(sh));

// Counters
wire sec_ovfl;
counter #(.MAX_VAL(59)) sec_cnt (.pulse(CLK_1HZ), .rstn(nRESET), .value(d_seconds), .ovfl(sec_ovfl));

wire min_ovfl;
wire min_inc;
assign min_inc = sec_ovfl | m_adj_db;
counter #(.MAX_VAL(59)) min_cnt(.pulse(min_inc), .rstn(nRESET), .value(d_minutes), .ovfl(min_ovfl));

wire hrs_ovfl; // never used
wire hrs_inc;
assign hrs_inc = min_ovfl | h_adj_db;
counter #(.MAX_VAL(23)) hrs_cnt(.pulse(hrs_inc), .rstn(nRESET), .value(d_hours), .ovfl(hrs_ovfl));

// Random noise
wire [6:0] noiseA, noiseB, noiseC, noiseD, noiseE, noiseF, noiseG;
noise nse ( .clk(CLK_16HZ), .rstn(nRESET), .noiseA(noiseA), .noiseB(noiseB), .noiseC(noiseC), .noiseD(noiseD), .noiseE(noiseE), .noiseF(noiseF), .noiseG(noiseG), .noiseH() );
reg noise_db_latch;
always @(posedge noise_db) begin
	noise_db_latch <= ~noise_db_latch; // toggle state, not instantaneous.
end

// Drive Segments & Colons
assign segA = noise_db_latch ? ~noiseA : ~w_segA ; // if noise_db is high (pulled up) show time, else, show noise.
assign segB = noise_db_latch ? ~noiseB : ~w_segB ;
assign segC = noise_db_latch ? ~noiseC : ~w_segC ;
assign segD = noise_db_latch ? ~noiseD : ~w_segD ;
assign segE = noise_db_latch ? ~noiseE : ~w_segE ;
assign segF = noise_db_latch ? ~noiseF : ~w_segF ;
assign col =  noise_db_latch ? ~noiseG[3:0] : ~{CLK_1HZ, CLK_1HZ, CLK_1HZ, CLK_1HZ};


// Drive PPS
assign pps = CLK_1HZ;

endmodule