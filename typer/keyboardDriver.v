module keyboardDriver(input CLK,
                      input PS2_CLK,
							 input [3:0]KEY,
							 input PS2_DAT,
							 output [17:0]LEDR,
							 output [7:0]LEDG);
							 
	
    wire [7:0]char; // current character
	 wire done; // for when data tranfer is done
	 
	 wire rst;
	 
	 reg [7:0]i = 1; // for testing
	 
	 assign LEDR[7:0] = i;
	 assign LEDG[7:0] = char;
	 assign rst =  KEY[0];
	 assign LEDR[17] = done;
	 
	 reg [1:0]S;
	 reg [1:0]NS;
	 
	 parameter start = 2'd0,
	           delay = 2'd1,
				  update = 2'd2;
				  
	
	keyboard typer(PS2_CLK, PS2_DAT, character, done);
				  
	 
	 always @(posedge CLK or negedge rst) begin
	     if (rst == 1'b0) begin
		      i <= 0;
		  end else begin
		  
	     case (S) 
		      start: begin
				end
				delay: begin
				end
				update: begin
				    if (char == 8'h75)
					     i <= i + 1;
					 else if (char == 8'h72)
					     i <= i - 1;
					 else 
					     i <= i;
				end
		  endcase
		  
		  end
	 end
	 
	 always @(*) begin
	     case (S) 
		      start: begin
				end
				delay: begin
				    if (done == 1'b1) 
					     NS <= update;
					 else
					     NS <= delay;
				end
				update: begin
				    NS <= delay;
				end
		  endcase
	 end
	 
	 always @(posedge CLK or negedge rst) begin
	     if(rst == 1'b0)
	         S <= start;
		  else 
		      S <= NS;
	 end
endmodule

				
				
				
							 