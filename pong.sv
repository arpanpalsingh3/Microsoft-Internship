/*module pong (out, x, y, reset, clk, hexOut, hexOut1);
	input logic x, y, clk, reset;
	output logic [9:0] out;
	output logic [6:0] hexOut, hexOut1;
	
	logic dff1, dff2, dff3, dff4;
	logic x1, y1;
	
	enum {A, B, C, D, E, F, G, H, I, J} ps, ns;
	
	enum {h0, h1, h2, h3, h4, h5, h6, h7} counter1, nextcount;
	
	enum {i0, i1,i2,i3,i4,i5,i6,i7} counter2, nextcount1;  
	
	enum {right, left} direction; 
	
	logic [3:0] counter; 
	
	
	
	always_ff @(posedge clk)
	begin 
		if (reset) begin
			counter <= 0;
			direction <= right;
		end else begin
			if (count && direction == right) begin
				counter <= counter + 1;
			end
			else if (count && direction == left) begin
				counter <= counter - 1;
			end
			
			direction <= direction_next;
		end
	end
	
	
	always_comb begin  
		count = 0;
		direction_next = direction;
		
		if (counter > 2 && counter < 9) begin
			count = 1;
		end
		
		if (counter == 2 && left_paddle) begin
			direction_next = right;
		end
	
	
	end
	
	

	
	
	
	
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
	
	
	always begin 
		case(direction ) 
			right: case(ps) 
					A: begin out = 10'b1000000000; ns = I; end
					B: begin 
						out = 10'b0100000000; 
						if (y) begin 
							direction = right;
							ns = C; end
						else begin 
							direction = right;
							ns = B; end
							end
					C: begin out = 10'b0010000000; ns = D; end 
					D: begin out = 10'b0001000000; ns = E; end 
					E: begin out = 10'b0000100000; ns = F; end 
					F: begin out = 10'b0000010000; ns = G; end
					G: begin out = 10'b0000001000; ns = H; end
					H: begin out = 10'b0000000100; ns = I; end
					I: begin
						out = 10'b0000000010;  
						if (x) begin 
							direction = left; 
							ns = H; end 
						else begin 
							direction = right;
							ns = J; end
							end 
					J: begin out = 10'b0000000001; ns = B; end 
					default: begin out = 10'b0100000000; ns = B; end 
				endcase
			
			left: case(ps)
					A: begin out = 10'b1000000000; ns = I; end
					B: begin
						out = 10'b0100000000;  
						if (y) begin 
							direction = right; 
							ns = C; end 
						else begin 
							direction = left;
							ns = A; end 
							end
					C: begin out = 10'b0010000000; ns = B; end 
					D: begin out = 10'b0001000000; ns = C; end 
					E: begin out = 10'b0000100000; ns = D; end 
					F: begin out = 10'b0000010000; ns = E; end 
					G: begin out = 10'b0000001000; ns = F; end
					H: begin out = 10'b0000000100; ns = G; end
					I: begin 
						out = 10'b0000000010;
						if (x) begin 
							direction = left; 
							ns = H; end 
						else begin 
							direction = left;
							ns = I; end 
						end 
					J: begin out = 10'b0000000001; ns = B; end 
					default: begin out = 10'b0000000010; ns = G; end 
				endcase 
			
			default: case(ps)
					A: begin out = 10'b1000000000; ns = A; end
					B: begin out = 10'b0100000000; ns = B; end
					C: begin out = 10'b0010000000; ns = C; end 
					D: begin out = 10'b0001000000; ns = D; end 
					E: begin out = 10'b0000100000; ns = E; end 
					F: begin out = 10'b0000010000; ns = F; end 
					G: begin out = 10'b0000001000; ns = G; end 
					H: begin out = 10'b0000000100; ns = H; end 
					I: begin out = 10'b0000000010; ns = I; end 
					J: begin out = 10'b0000000001; ns = J; end 
					default: begin out = 10'b0000000010; ns = G; end 
				endcase 
		endcase
		
		
	end	
				
	always_ff @(posedge clk) begin 
		ps <= ns; end 
			
			
	always_ff @(posedge clk) begin 
	if (reset) begin 
		counter1 <= h0;
		counter2 <= i0; end 
	else if (ps == A) begin 
		counter1 <= nextcount; end
	else if (ps == J) begin 
		counter2 <= nextcount1; end
		end
		
	/*always_ff @(posedge clk) begin 
	if( reset) begin 
		dff1 <= 0;
		dff2 <= 0;
		dff3 <= 0;
		dff4 <= 0;
		x1 <= 0; 
		y1 <= 0;
		 end
	else begin 
		dff1 <= x;
		dff2 <= dff1;
		x1 <= (dff2 & ~dff1);
		dff3 <= y;
		dff4 <= dff3;
		y1 <= (dff4 & ~dff3);
	end end */
	
endmodule */
			
			
		