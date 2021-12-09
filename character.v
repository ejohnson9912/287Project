module character(
		  input update,
		  input en,
		  input rst,
		  input [2:0]i,
	     input [5:0]damage,
	     input [2:0]cost,
		  output reg [2:0]speed,
		  output reg [2:0]dodge,
		  output reg [8:0]health,
		  output reg [4:0]special,
		  output reg [2:0]color);
		  
//		  reg [5:0]damage;
//		  reg [2:0]price;
		  
		  reg [8:0]maxHealth;
		  reg [4:0]maxSpecial;
		  
		  
//		  always @(*) begin
//		      if (hit[5] == 1'b1) begin
//				    damage = -hit;
//				 end else begin
//				    damage = hit;
//			    end 
//				 if (cost[2] == 1'b1) begin
//				    price = -cost;
//				 end else begin
//				    price = -cost;
//			    end 
//	     end
		  
		  always @(*) begin
		      case(i) 
				    0: begin
					    maxHealth = 9'd175;
						 speed = 4'd4;
						 dodge = 5'd5;
						 maxSpecial = 4'd8;
						 color = 3'b110;
					 end
					    
					 1: begin
					    maxHealth = 9'd150;
						 speed = 4'd6;
						 dodge = 5'd7;
						 maxSpecial = 4'd10;
						 color = 3'b011;
					 end
					 2: begin
					    maxHealth = 9'd200;
						 speed = 4'd2;
						 dodge = 5'd5;
						 maxSpecial = 4'd10;
						 color = 3'b101;
					 end
					 default: begin
					    maxHealth = 9'd150;
						 speed = 4'd7;
						 dodge = 5'd7;
						 maxSpecial = 4'd8;
						 color = 3'b010;
					 end
			   endcase
		  end
		 
		  
		  
		  always@(posedge update or posedge rst) begin
		      if (rst == 1'b1) begin
				   health <= maxHealth;
					special <= maxSpecial;
				end else begin
		          if(en == 1'b1) begin
					      
							    if (health - damage > maxHealth) begin
								     health <= 0;
								 end else begin  
								     health <= health - damage;
								 end 
						 
					 end
				end
		  end
		
endmodule 

// if(en == 1'b1) begin
//					      
//							    if (health - damage > maxHealth) begin
//								     health <= 0;
//								 end else begin  
//								     health <= health - damage;
//								 end 
//						  end else begin 
//						       if (health + damage > maxHealth) begin
//								     health <= maxHealth;
//								 end else begin  
//								     health <= health + damage;
//								 end 
//							end
//							if (cost[2] == 1'b0) begin 
//							    if (special - price > maxSpecial) begin
//								     special <= 0;
//								 end else begin  
//								     special <= special - price;
//								 end 
//						  end else begin 
//						       if (special + price > maxSpecial) begin
//								     special <= maxSpecial;
//								 end else begin  
//								     special <= special + price;
//								 end 
//							end
//		    	 	 end 
//					 
//				end	