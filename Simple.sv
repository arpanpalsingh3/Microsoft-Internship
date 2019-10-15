module simple (clk, reset, w, out); 
	input logic clk, reset, w; 
	output logic out; 
	
	//State Variables.
	enum {A, B, C} ps, ns; 
	
	//next state logic 
	always_comb 
		case(ps)
			A: if (w)	ns = B;
				else		ns = A;
			B: if (w)	ns = C; 
				else 		ns = A;
			C: if (w) 	ns = C; 
				else 		ns = A;
		endcase
		
		//output logic - could also be another always, or part of above block 
		
		assign out = (ps==C);
		
		//DFFs
		always_ff @(posedge clk)
			if (reset)
				ps <= A;
			else 
				ps <= ns; 
				
endmodule

module simple_testbench(); 
	logic clk, reset, w; 
	logic out; 
	
	simple dut (clk, reset, w, out); 
	
	//set up the clock 
	parameter CLOCK_PERIOD = 100; 
	initial begin 
		clk <= 0; 
		forever # (CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	//set up the inputs to the design. Each line is a clock cycle 
	
	initial begin	
		                    @(posedge clk);	
		reset <= 1;         @(posedge clk);	
		reset <= 0; w <= 0; @(posedge clk);	
		                    @(posedge clk);	
		                    @(posedge clk);	
		                    @(posedge clk);	
		            w <= 1; @(posedge clk);	
		            w <= 0; @(posedge clk);	
		            w <= 1; @(posedge clk);	
		                    @(posedge clk);	
		                    @(posedge clk);	
		                    @(posedge clk);	
		            w <= 0; @(posedge clk);	
		                    @(posedge clk);	
		$stop; // End the simulation.	
	end	
endmodule		
