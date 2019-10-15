module hazardLight(clk, x, out);
	input logic clk;
	input logic [1:0] x;
	output logic [2:0] out; 
	
	enum {A, B, C} ps, ns; 
	
	
	always_comb 
		case(x) 
			2'b00: begin 
				case (ps)
				A: begin out = 3'b101; ns = B; end
				
				B: begin out = 3'b010; ns = A; end
				
				default: begin out = 3'b000; ns = A; end
			endcase end
			
			2'b01: begin 
				case (ps)
				A: begin out = 3'b001; ns = B; end 
				
				B: begin out = 3'b010; ns = C; end 
				
				C: begin out = 3'b100; ns = A; end
				
				default: begin out = 3'b000; ns = A; end
			endcase end 
			
			2'b10: begin 
				case (ps)
				A: begin out = 3'b100; ns = B; end 
				
				B: begin out = 3'b010; ns = C; end 
				
				C:	begin out = 3'b001; ns = A; end 
				
				default: begin out = 3'b000; ns = A; end
			endcase end 
			
			
			default: begin out = 3'b000; ns = A; end 
		endcase 
	
	always_ff @(posedge clk)
 
			ps <= ns;
			
endmodule 

module hazard_testbench();
	logic clk; 
	logic [1:0] x;
	logic [2:0] out; 
	
	hazardLight dut (.clk, .x, .out); 
	
	
	//set up the clock 
	parameter CLOCK_PERIOD = 100; 
	initial begin 
		clk <= 0; 
		forever # (CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	initial begin	
x = 2'b00;		                    @(posedge clk);	
								  @(posedge clk);	
								  @(posedge clk);	
	x = 2'b01;	                    @(posedge clk);	
		                    @(posedge clk);	
		                    @(posedge clk);	
		                    @(posedge clk);	
x = 2'b10;								  @(posedge clk);	
								  @(posedge clk);	
		                    @(posedge clk);	
		                    @(posedge clk);	
x = 2'b11;		                    @(posedge clk);	
								  @(posedge clk);	
		                    @(posedge clk);	
		$stop; // End the simulation.	
	end	
endmodule		