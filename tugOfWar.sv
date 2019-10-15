module tugOfWar(clk, reset, x,y, out, hexOut, hexOut1, control);
	input logic clk, reset;
	input logic x;
	input logic [8:0] y; 
	input logic control;
	output logic [8:0] out; 
	output logic [6:0] hexOut, hexOut1;
	
	
	logic dff1, dff2, dff3, dff4;
	logic x1, y1;
	logic [9:0] LFSR =  1023; 
	logic feedback;
	assign feedback = LFSR[9];
	enum {A, B, C, D, E, F, G, H, I, h0, h1, h2, h3, h4, h5, h6, h7, i0, i1,i2,i3,i4,i5,i6,i7} ps, ns, counter1, counter2, nextcount, nextcount1 ;
	
	
	always_comb 
		case(counter1)
		h0 : begin hexOut = 7'b1000000; nextcount = h1;  end
		h1 : begin hexOut = 7'b1111001; nextcount = h2;  end 
		h2 : begin hexOut = 7'b0100100; nextcount = h3;  end 
		h3 : begin hexOut = 7'b0110000; nextcount = h4;  end
		h4 : begin hexOut = 7'b0011001; nextcount = h5;  end 
		h5 : begin hexOut = 7'b0010010; nextcount = h6;  end 
		h6 : begin hexOut = 7'b0000010; nextcount = h7;  end 
		h7 : begin hexOut = 7'b1111000; nextcount = h7;  end 
		default: begin hexOut = 7'b1000000; nextcount = h0; end
	endcase

	always_comb
		case(counter2)
		i0 : begin hexOut1 = 7'b1000000; nextcount1 = i1; end
		i1 : begin hexOut1 = 7'b1111001; nextcount1 = i2; end 
		i2 : begin hexOut1 = 7'b0100100; nextcount1 = i3; end 
		i3 : begin hexOut1 = 7'b0110000; nextcount1 = i4; end
		i4 : begin hexOut1 = 7'b0011001; nextcount1 = i5; end 
		i5 : begin hexOut1 = 7'b0010010; nextcount1 = i6; end 
		i6 : begin hexOut1 = 7'b0000010; nextcount1 = i7; end 
		i7 : begin hexOut1 = 7'b1111000; nextcount1 = i7; end 
		default: begin hexOut1 = 7'b1000000; nextcount1 = i0; end
	endcase 
	
	always_comb
		case({y1, x1}) //different cases of x (the buttons)
			
		2'b01: begin 

		
				case(ps) //check the state it's at currently and change to the next accordingly to move with right 
				
				A: begin out = 9'b000011111;  ns = A; end
				
				B: begin out = 9'b000011110;  ns = A; end
				
				C: begin out = 9'b000011100;  ns = B; end
				
				D: begin out = 9'b000011000;  ns = C; end
				
				E: begin out = 9'b000010000;  ns = D; end
				
				F: begin out = 9'b000110000;  ns = E; end
				
				G: begin out = 9'b001110000;  ns = F; end
				
				H: begin out = 9'b011110000;  ns = G; end
				
				I: begin out = 9'b111110000;  ns = I; end
				
				default: begin out = 9'b000010000;  ns = D; end
				
				endcase 
				end 
			
		
		2'b10: begin 
				case(ps) //check the state it's at currently and change to the next accordingly to move with left
				
				A: begin out = 9'b000011111; ns = A; end
				
				B: begin out = 9'b000011110; ns = C; end
				
				C: begin out = 9'b000011100; ns = D; end
				
				D: begin out = 9'b000011000; ns = E; end
				
				E: begin out = 9'b000010000; ns = F; end
				
				F: begin out = 9'b000110000; ns = G; end
				
				G: begin out = 9'b001110000; ns = H; end
				
				H: begin out = 9'b011110000; ns = I; end
				
				I: begin out = 9'b111110000; ns = I; end
				
				default: begin  out = 9'b000010000;  ns = F; end 
				 
				endcase 
				
				end
				
		default: begin 
				case(ps)
				
				
				A: begin out = 9'b000011111;  ns = E; end
				
				B: begin out = 9'b000011110;  ns = B; end
				
				C: begin out = 9'b000011100;  ns = C; end
				
				D: begin out = 9'b000011000;  ns = D; end
				
				E: begin out = 9'b000010000;  ns = E; end
				
				F: begin out = 9'b000110000;  ns = F; end
				
				G: begin out = 9'b001110000;  ns = G; end
				
				H: begin out = 9'b011110000;  ns = H; end
				
				I: begin out = 9'b111110000;  ns = E; end
				
				default: begin  out = 9'b000010000; ns = E; end
				
				endcase end 
				
		endcase
		
		
		
always_ff @(posedge clk) 
	begin 
		LFSR[0] <= feedback; 
		LFSR[1] <= LFSR[0];
		LFSR[2] <= LFSR[1] ^ feedback;
		LFSR[3] <= LFSR[2] ^ feedback; 
		LFSR[4] <= LFSR[3] ^ feedback;  
		LFSR[5] <= LFSR[4] ^ feedback;
		LFSR[6] <= LFSR[5] ^ feedback;
		LFSR[7] <= LFSR[6]; 
		LFSR[8] <= LFSR[7];
		LFSR[9] <= LFSR[8];
end
		
			
			
always_ff @(posedge clk)  
	if (~reset)  begin 
		ps <= E; 
	 end
	else begin 
		ps <= ns; end
		
		
		
always_ff @(posedge clk) begin 
	if (~reset) begin 
		counter1 <= h0;
		counter2 <= i0; end 
	else if (ps == A) begin 
		counter1 <= nextcount; end
	else if (ps == I) begin 
		counter2 <= nextcount1; end
		end
	

always_ff @(posedge clk) begin 
	if( ~reset) begin 
		dff1 <= 0;
		dff2 <= 0;
		//dff3 <= 0;
		//dff4 <= 0;
		x1 <= 0; 
		 end
	else begin 
	dff1 <= x;
	dff2 <= dff1;
	x1 <= (dff2 & ~dff1);
	//dff3 <= y;
	//dff4 <= dff3;
	//y1 <= (dff4 & ~dff3);
	end end 


always_ff @(posedge clk) begin 
 
	if({10'b0000000000,y}>LFSR & control)
		y1 <= 1;
	else 	
		y1 <= 0; end 

		
		
endmodule 	



module tugOfWar_testbench();
	 logic clk, reset;
	 logic x;
	 logic [8:0] y; 
	 logic [8:0] out; 
	 logic [6:0] hexOut, hexOut1;
	
	tugOfWar dut (.clk, .reset, .x, .y, .out, .hexOut, .hexOut1); 
	
	
	//set up the clock 
	parameter CLOCK_PERIOD = 100; 
	initial begin 
		clk <= 0; 
		forever # (CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	initial begin	
	
x = 0; y = 10'b0010101010;		@(posedge clk);
								@(posedge clk);	
reset = 0;					@(posedge clk); 
								@(posedge clk);	
reset = 1; 					@(posedge clk);
								@(posedge clk);
x = 1; 						@(posedge clk);
x = 0;						@(posedge clk);
								@(posedge clk);	
x = 1; 						@(posedge clk);
x = 0;						@(posedge clk);
								@(posedge clk);	
x = 1; 						@(posedge clk);
x = 0;						@(posedge clk);
								@(posedge clk);	
x = 1; 						@(posedge clk);
x = 0;						@(posedge clk);
								@(posedge clk);	
x = 1; 						@(posedge clk);
x = 0;						@(posedge clk);
								@(posedge clk);	
x = 1; 						@(posedge clk);
x = 0;						@(posedge clk);
								@(posedge clk);	
x = 1; 						@(posedge clk);
x = 0;						@(posedge clk);

									
															
	end	
endmodule 
 	
		
		
		
		
		