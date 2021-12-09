module point(
	 input update, 
	 input en, 
	 input rst, 
	 input i,
	 input [2:0]xMove, 
	 input [2:0]yMove, 
	 output reg [2:0]x, 
	 output reg [2:0]y);
	 
	 reg [2:0]xReal;
	 reg [2:0]yReal;
	 
	 always @(*) begin
	      case({xMove[2], yMove[2]}) 
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
	 
	 always @(posedge update or posedge rst) begin 
	      if (rst == 1'b1) begin 
			    if (i == 0) begin
				     x <= 5'd2;
					  y <= 5'd2;
				 end else begin
				     x <= 5'd6;
					  y <= 5'd6;
				 end 
			end else begin  
	          if (en == 1'b1) begin
				     case({xMove[2], yMove[2]}) 
					      2'b00: begin                       
							   if (x + xReal > 5) begin 
								    x <= 5;
							   end else begin
								    x <= x + xReal;
								end 
							   if (y + yReal > 5) begin 
								    y <= 5;
							   end else begin
								    y <= y + yReal;
								end 
							end 2'b10: begin
							   if (x < xReal) begin 
								    x <= 0;
							   end else begin
								    x <= x - xReal;
								end 
							   if (y + yReal > 5) begin 
								    y <= 5;
							   end else begin
								    y <= y + yReal;
								end 
							end 2'b01: begin
							   if (x + xReal > 5) begin 
								    x <= 5;
							   end else begin
								    x <= x + xReal;
								end 
							   if (y < yReal) begin 
								    y <= 0;
							   end else begin
								    y <= y - yReal;
								end 
							end 2'b11: begin 
							   if  (x < xReal) begin 
								    x <= 0;
							   end else begin
								    x <= x - xReal;
								end
							   if (y < yReal) begin 
								    y <= 0;
							   end else begin
								    y <= y - yReal;
									 
								end 
							end
					 endcase
			  end	 
		end	
	end 						    
endmodule						   	
							
								