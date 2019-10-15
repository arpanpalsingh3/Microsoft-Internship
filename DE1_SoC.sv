module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW); 	
	input  logic         CLOCK_50; // 50MHz clock.	
	output logic  [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 		
	output logic  [9:0]  LEDR; 		
	input  logic  [3:0]  KEY; // True when not pressed, False when pressed	
	input  logic  [9:0]  SW; 			
	
	// Generate clk off of CLOCK_50, whichClock picks rate.	
	logic [31:0] clk;		
	logic [31:0] secondclk; 
	logic [31:0] thirdclk;
	clock_divider cdiv (CLOCK_50, clk);	
	clock_divider cdiv2 (CLOCK_50, secondclk);
	clock_divider cdiv3 (CLOCK_50, thirdclk);
	
	fillFunction x (.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .start(KEY[0]), .num(SW[8:6]), .size(SW[5:3]), .vectors(SW[2:0]), .reset(KEY[1]), .ledOut_cycle(LEDR[0]), .ledOut_clk(LEDR[9]), .clk(clk[23]), .clk2(secondclk[22]), .clk3(thirdclk[0]), .ledOut_rdempty(LEDR[1]));
		
endmodule		
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...	
module clock_divider (clock, divided_clocks);	
	input  logic          clock;	
	output logic  [31:0]  divided_clocks;	
		
	initial	
		divided_clocks <= 0;	
			
	always_ff @(posedge clock)	
		divided_clocks <= divided_clocks + 1;	
endmodule		

