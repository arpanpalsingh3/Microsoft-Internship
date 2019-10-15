 	
module display7 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW); 	
	output logic  [6:0]    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 	
	output logic  [9:0]    LEDR; 	
	input  logic  [3:0]    KEY; 	
	input  logic  [9:0]		SW; 	
	
	
	
	
	always_comb begin
	
		case (SW[2:0]) 
			//          Light: s							t							o						o						b
			3'b000: begin HEX0 =  7'b0010010; HEX1 = 7'b0000111; HEX2 = 7'b0100011; HEX3 = 7'b0100011; HEX4 = 7'b0000011; HEX5 = 7'b1111111; end
		
			//          Light: s							t							a						h
			3'b001: begin HEX0 =  7'b0010010; HEX1 = 7'b0000111; HEX2 = 7'b0001000; HEX3 = 7'b0001001; HEX4 = 7'b1111111; HEX5 = 7'b1111111;end 
			//          Light: s						h							i						r						t
			3'b011: begin HEX4 =  7'b0010010; HEX3 = 7'b0001001; HEX2 = 7'b1001111; HEX1 = 7'b0101111; HEX0 = 7'b0000111; HEX5 = 7'b1111111;end
			// 			Light: d							r							e						s						s
			3'b100: begin HEX4 =  7'b0100001; HEX3 = 7'b0101111; HEX2 = 7'b0000100; HEX1 = 7'b0010010; HEX0 = 7'b0010010; HEX5 = 7'b1111111;end
			// 			light: p							a							n						t						s
			3'b101: begin HEX4 =  7'b0001100; HEX3 = 7'b0001000; HEX2 = 7'b0101011; HEX1 = 7'b0000111; HEX0 = 7'b0010010; HEX5 = 7'b1111111;end
			// 			light: b							e							l						t						s
			3'b110: begin HEX4 =  7'b0000011; HEX3 = 7'b0000100; HEX2 = 7'b1000111; HEX1 = 7'b0000111; HEX0 = 7'b0010010; HEX5 = 7'b1111111;end
			default:begin HEX3 =  7'b0001001; HEX2 = 7'b0000100; HEX1 = 7'b1000111; HEX0 = 7'b0001100; HEX4 = 7'b1111111; HEX5 = 7'b1111111;end 
		endcase
	end
	
	
	always_comb begin
	//if the mark is on, it wont be stolen, so send if its discount or not, and send off for stolen
		case(SW)
		4'b1000: LEDR[1:0] = 2'b00;
		4'b1001: LEDR[1:0] = 2'b00;
		4'b1011: LEDR[1:0] = 2'b10;
		4'b1100: LEDR[1:0] = 2'b00;
		4'b1101: LEDR[1:0] =	2'b10;
		4'b1110: LEDR[1:0] =	2'b10;
		//if mark is not on, check if expensive or not, and send discount with stolen apporpriately 
		4'b0000: LEDR[1:0] = 2'b01;
		4'b0001: LEDR[1:0] = 2'b00;
		4'b0011: LEDR[1:0] = 2'b10;
		4'b0101: LEDR[1:0] =	2'b11;
		4'b0110: LEDR[1:0] =	2'b10;
		default: LEDR[1:0] = 2'b00;
		endcase
		4'b0100: LEDR[1:0] = 2'b01;
	
	end 
	
endmodule

module display7_testbench();

	logic  [6:0]    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 	
	logic  [9:0]    LEDR; 	
	logic  [3:0]     KEY; 	
	logic  [9:0]		SW; 	
	
	
	display7 dut(.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	// Try all combinations of inputs.	
	integer i;	
	initial begin	
		SW[9:4] = 1'b0;		
		for(i = 0; i <10; i++) begin	
			SW[3:0] = i; #10;	
		end	
	end	
endmodule	