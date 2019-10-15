module fillFunction (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, start, num, size, vectors, reset, ledOut_cycle, ledOut_clk, clk, clk2, clk3, ledOut_rdempty);
	//input logic 
	input logic start, reset, clk, clk2, clk3;
	input logic [2:0] num; 
	input logic [2:0] size, vectors; 
	//outputlogic 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic ledOut_cycle, ledOut_clk, ledOut_rdempty;
	//general code logic 
	logic going;
	logic [6:0] numHold; 
	logic [31:0] counter; 
	logic dff1, dff2, press; 
	//Fifo Logic 
	logic writeData,rdreq, wrempty, wrfull, rdempty, rdfull;
	logic [5:0] q; 
	parameter LOG_DEPTH = 8;
	parameter WIDTH = 6; 
	// struct for all my states	
struct { 
	logic [2:0] counter_vectors, counter_size;
	logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5;
} regs_ff, regs_next;
	
	//comb code 	
always_comb begin 
	regs_next = regs_ff;
		
		
	
	ledOut_cycle = going;
	{HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} = {regs_ff.hex0, regs_ff.hex1, regs_ff.hex2, regs_ff.hex3, regs_ff.hex4, regs_ff.hex5};

	case(num) 
	4'b000:  numHold = 7'b1000000;
	4'b001:	numHold = 7'b1111001;
	4'b010:	numHold = 7'b0100100;
	4'b011:  numHold = 7'b0110000;
	4'b100:	numHold = 7'b0011001;
	4'b101:	numHold = 7'b0010010;
	4'b110:  numHold = 7'b0000010;
	4'b111:	numHold = 7'b1111000;
  default : numHold = 7'b1111111;
	endcase
	ledOut_rdempty = rdempty;

if(going) begin 
	
		if( regs_ff.counter_vectors >= 3) begin 
			if (regs_ff.counter_size != 0) begin 
				regs_next.hex0 = numHold;
				regs_next.hex1 = numHold;
				regs_next.hex2 = numHold;
				regs_next.hex3 = numHold;
				regs_next.hex4 = numHold;
				regs_next.hex5 = numHold;
				regs_next.counter_size = regs_next.counter_size -1;
				end
		end
	
		if (regs_ff.counter_vectors == 2) begin 
			if(regs_ff.counter_size != 0) begin	
				regs_next.hex0 = numHold;
				regs_next.hex1 = numHold;
				regs_next.hex2 = numHold;
				regs_next.hex3 = numHold;
				regs_next.hex4 = 7'b1111111;
				regs_next.hex5 = 7'b1111111; 
				regs_next.counter_size = regs_next.counter_size -1;
				end
		end 
	
		if (regs_ff.counter_vectors == 1) begin 
			if(regs_ff.counter_size != 0) begin 
				regs_next.hex0 = numHold;
				regs_next.hex1 = numHold;
				regs_next.hex2 = 7'b1111111;
				regs_next.hex3 = 7'b1111111;
				regs_next.hex4 = 7'b1111111;
				regs_next.hex5 = 7'b1111111;
				regs_next.counter_size = regs_next.counter_size -1;
			   end
		 end 
	
		if(regs_ff.counter_vectors == 0) begin 
			if(regs_ff.counter_size <1000000) begin 
				regs_next.hex0 = 7'b1111111;
				regs_next.hex1 = 7'b1111111;
				regs_next.hex2 = 7'b1111111;
				regs_next.hex3 = 7'b1111111;
				regs_next.hex4 = 7'b1111111;
				regs_next.hex5 = 7'b1111111; 
				regs_next.counter_size = regs_next.counter_size -1;
				end
		 end

	end	
	
		if (regs_next.counter_size == 0) begin 
				regs_next.counter_size = size; 
			if(regs_ff.counter_vectors >= 3) begin 
				regs_next.counter_vectors = regs_next.counter_vectors - 3; end 
			else begin 
				regs_next.counter_vectors = 0; end 
			end
			
	
	
end

always_ff @(posedge clk) begin   // This is to reset it. Its reset, make all leds turn off 

	if(~reset) begin 
		going <= 0;
		regs_ff.counter_vectors <= 0;
		regs_ff.counter_size <= 0;
		regs_ff.hex0 <= 7'b1111111;
		regs_ff.hex1 <= 7'b1111111;
		regs_ff.hex2 <= 7'b1111111;
		regs_ff.hex3 <= 7'b1111111;
		regs_ff.hex4 <= 7'b1111111;
		regs_ff.hex5 <= 7'b1111111;
	end else begin
	
		regs_ff<= regs_next;
		rdreq <= 0; 
		
			
		if(going == 0 && rdempty == 0 ) begin  
			going <= 1;
			rdreq <= 1; 
			regs_ff.counter_size <= q[5:3];
			regs_ff.counter_vectors <= q[2:0]; end 
			
		if (going == 1 && regs_ff.counter_vectors == 0)
			going <= 0;
	end
		

end 

always_ff @(posedge clk2) begin 
	counter <= counter + 1; // the ticking clock cycles 
	ledOut_clk <= counter;
	
end 

 always_ff @(posedge clk3) begin 
	if(~reset) begin 
		dff1 <= 0;
		dff2 <= 0;
		press <= 0; end 
	else begin 
		dff1 <= ~start;
		dff2 <= dff1;
		press <= (dff2 & ~dff1); end 
end  



dcfifo dcfifo_component
    (
        .rdclk            (clk),   // slow clock for reading from the fifo 
        .wrreq            (press),
        .aclr             (~reset),
		  
        .data             ({size, vectors}),  //the data that im writing into the fifi (The num, the size and the number of vectors)
        .rdreq            (rdreq), //the request to read the fifo data 
        .wrclk            (clk3),  //the fast clock by which im sending my data in 	
        .wrempty          (wrempty), //checks if the fifo is empty when writing to it (dont need)
        .wrfull           (wrfull), // checks if the fifo is full when writing to it (need to check before writing in)
        .q                (q),  		// shows the data read from the reqest operation 
        .rdempty          (rdempty),  // checks if the fifo is empty when reading from it (need to check before reading in and KEEP checking until empty) 
        .rdfull           (rdfull),  // checks if the fifo is full when reading from it (dont need)
        .wrusedw          (),
        .rdusedw          ()
    );

    defparam
        dcfifo_component.add_usedw_msb_bit = "ON",
        dcfifo_component.intended_device_family = "Stratix V",
        dcfifo_component.lpm_hint = "RAM_BLOCK_TYPE=MLAB", //"RAM_BLOCK_TYPE=MLAB" : "RAM_BLOCK_TYPE=M20K",
        dcfifo_component.lpm_numwords = 2**LOG_DEPTH,
        dcfifo_component.lpm_showahead = "ON",
        dcfifo_component.lpm_type = "dcfifo",
        dcfifo_component.lpm_width = WIDTH,
        dcfifo_component.lpm_widthu = LOG_DEPTH+1,
        dcfifo_component.overflow_checking = "OFF",
        dcfifo_component.rdsync_delaypipe = 5,
        dcfifo_component.read_aclr_synch = "ON",
        dcfifo_component.underflow_checking = "OFF",
        dcfifo_component.use_eab = "ON",
        dcfifo_component.write_aclr_synch = "ON",
        dcfifo_component.wrsync_delaypipe = 5;


	
endmodule 



























// TESTBENCH 






module fillFunction_testbench(); 
	logic start, reset, clk, clk2, clk3, valid;
	logic [3:0] num; 
	logic [2:0] size, vectors; 
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic ledOut_cycle;
	logic [31:0] ledOut_clk;
	
fillFunction dut (.start, .reset, .clk, .clk2, .clk3, .num, .size, .vectors, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .ledOut_cycle, .ledOut_clk);

	//set up the clock 
	parameter CLOCK_PERIOD = 100; 
	initial begin 
		clk <= 0; 
		forever # (CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	initial begin 
	start = 1;												@(posedge clk);
	reset = 1;												@(posedge clk);
	num = 0001; size = 010; vectors = 100; 		@(posedge clk);
																@(posedge clk);
																@(posedge clk); 
	start = 0; 												@(posedge clk); 
	start = 1;												@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk); 
																@(posedge clk);
																@(posedge clk);


$stop;// End simulation 

end 

endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
