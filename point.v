module point(
    input clk, 
	 input en, 
	 input rst, 
	 input i,
	 input [4:0]xMove, 
	 input [4:0]yMove, 
	 output reg [4:0]x, 
	 output reg [4:0]y,
	 output reg done);
	 
	 reg [4:0]xReal;
	 reg [4:0]yReal;
	 
	 always @(*) begin
	      case({xMove[4], yMove[4]}) 
			    2'b00: begin
				    xReal = xMove;
					 yReal = yMove;

				 end 2'b10: begin
				    xReal = -xMove;
					 yReal = yMove;
				 end 2'b01: begin
				    xReal = xMove;
					 yReal = -yMove;
				 end 2'b11: begin
				    xReal = -xMove;
					 yReal = -yMove;
				 end
			endcase
    end		
	 
	 always @(posedge clk or negedge rst) begin 
	      if (rst == 1'b0) begin 
			    if (i == 0) begin
				     x <= 5'd3;
					  y <= 5'd3;
				 end else begin
				     x <= 5'd9;
					  y <= 5'd9;
				 end 
			end else begin  
			    if (en == 1'b1) begin
				     case({xMove[4], yMove[4]}) 
					      2'b00: begin                       
							   if (x + xReal > 11) begin 
								    x <= 11;
									 done <= 1'b1;
							   end else begin
								    x <= x + xReal;
									 done <= 1'b1;
								end 
							   if (y + yReal > 11) begin 
								    y <= 11;
									 done <= 1'b1;
							   end else begin
								    y <= y + yReal;
									 done <= 1'b1;
								end 
							end 2'b10: begin
							   if (x < xReal) begin 
								    x <= 0;
									 done <= 1'b1;
							   end else begin
								    x <= x - xReal;
									 done <= 1'b1;
								end 
							   if (y + yReal > 11) begin 
								    y <= 11;
									 done <= 1'b1;
							   end else begin
								    y <= y + yReal;
									 done <= 1'b1;
								end 
							end 2'b01: begin
							   if (x + xReal > 11) begin 
								    x <= 11;
									 done <= 1'b1;
							   end else begin
								    x <= x + xReal;
									 done <= 1'b1;
								end 
							   if (y < yReal) begin 
								    y <= 0;
									 done <= 1'b1;
							   end else begin
								    y <= y - yReal;
									 done <= 1'b1;
								end 
							end 2'b11: begin 
							   if  (x < xReal) begin 
								    x <= 0;
									 done <= 1'b1;
							   end else begin
								    x <= x - xReal;
									 done <= 1'b1;
								end
							   if (y < yReal) begin 
								    y <= 0;
									 done <= 1'b1;
							   end else begin
								    y <= y - yReal;
									 done <= 1'b1;
								end 
							end
					 endcase
				end else begin
				    x <= x;
					 y <= y;
			   end
		end	
	end 						    
endmodule						   	
							
								