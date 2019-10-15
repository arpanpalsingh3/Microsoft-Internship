module hazardlights ( clk, w, out);
	input logic clk,  w;
	output logic [2:0] out;
	
	
	enum {A, B, C} ps, ns; 
	
	
	always_comb 
	case(w) 
		2'b00: begin 
			case (ps)
			A: begin out = 3'b101; ns = B; end
			
			B: begin out = 3'b010; ns = A; end
		endcase end
		
		2'b01: begin 
			case (ps)
			A: begin out = 3'b001; ns = B; end 
			
			B: begin out = 3'b010; ns = C; end 
			
			C: begin out = 3'b100; ns = A; end
		endcase end 
		
		2'b10: begin 
			case (ps)
			A: begin out = 3'b100; ns = B; end 
			
			B: begin out = 3'b010; ns = C; end 
			
			C:	begin out = 3'b001; ns = A; end 
		endcase end 
		default: begin out = 3'b000; ns =A; end
	endcase 
	
	
	
	always_ff @(posedge clk)
		ps <= ns; 
endmodule 
			
