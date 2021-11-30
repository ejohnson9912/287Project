module attack(
       input clk,
		 input en,
		 input rst, 
		 input [2:0]i, 
		 input [2:0]j,
		 input [4:0]dodge,
		 input [4:0]aim,
		 output [4:0]spread,
		 output [4:0]range,
		 output reg [3:0]load,
		 output reg [5:0]damage);
		 
		 
		 reg [4:0]gap;
		 wire [5:0]maxDamage = 6'd36;
		 wire [3:0]clip = 4'd15;
		 
		 assign spread = 4'd9;
		 
		
			     
		 always@(*) begin
		     if (dodge > aim) begin
			      gap <= dodge - aim;
			  end else begin 
			      gap <= aim - dodge;
				end 
		 end 
		 
		 
		 always @(posedge clk or negedge rst) begin
		      if (rst == 1'b0) begin 
			       load <= clip;
				    damage <= 6'b0;
			   end else begin 
			       
		          if (en == 1'b1) begin
				       if (spread <= gap | load == 4'b0) begin
				   	     damage <= 6'b0;
				    	 end else if (gap == 5'd0) begin
						     damage <= maxDamage;
					    end else begin	
 				    	     damage <= (((spread - gap) * maxDamage) / gap);
					    end	
						 if (load == 4'b0) begin 
						     load = 4'b0;
					    end else begin 
						     load <= load - 4'b1;
						 end 
				    end
	         end
	     end  
endmodule 