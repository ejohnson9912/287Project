module character(
        input clk,
		  input en,
		  input rst,
		  input [2:0]i,
	     input [5:0]hit,
	     input [2:0]cost,
		  output [3:0]speed,
		  output [4:0]dodge,
		  output reg [8:0]health,
		  output reg [4:0]special);
		  
		  reg [5:0]damage;
		  reg [2:0]price;
		  assign dodge = 5'd13;
		  
		  wire [8:0]maxHealth = 9'd175;
	     wire [4:0]maxSpecial = 5'd10;
		  
		  always @(*) begin
		      if (hit[5] == 1'b1) begin
				    damage = -hit;
				 end else begin
				    damage = hit;
			    end 
				 if (cost[2] == 1'b1) begin
				    price = -cost;
				 end else begin
				    price = -cost;
			    end 
	     end
		 
		  
		  
		  always@(posedge clk or negedge rst) begin
		      if (rst == 1'b0) begin
				   health <= maxHealth;
					special <= maxSpecial;
				end else begin
		          if(en == 1'b1) begin
					     if (hit[5] == 1'b0) begin 
							    if (health - damage > maxHealth) begin
								     health <= 0;
								 end else begin  
								     health <= health - damage;
								 end 
						  end else begin 
						       if (health + damage > maxHealth) begin
								     health <= maxHealth;
								 end else begin  
								     health <= health + damage;
								 end 
							end
							if (cost[2] == 1'b0) begin 
							    if (special - price > maxSpecial) begin
								     special <= 0;
								 end else begin  
								     special <= special - price;
								 end 
						  end else begin 
						       if (special + price > maxSpecial) begin
								     special <= maxSpecial;
								 end else begin  
								     special <= special + price;
								 end 
							end
		    	 	  end else begin

			           health <= health;
					     special <= special;
				    end
					 
				end
		end
		
endmodule 	