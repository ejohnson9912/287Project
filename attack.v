module attack(
       input update,
		 input en, 
		 input rst, 
		 input [1:0]i, 
		 input [1:0]j,
		 input [4:0]dodge,
		 input [4:0]aim,
		 output reg [4:0]spread,
		 output reg [4:0]range,
		 output reg [3:0]load,
		 output reg [5:0]damage);
		 
		 
		 reg [4:0]gap;
		 reg [5:0]maxDamage;
		 reg [3:0]clip;
		 
		 always @(*) begin
		       case ({i, j}) 
						 4'd0: begin
							 maxDamage <= 42; // FireBall
							 spread <= 5;
							 range <= 2;
							 clip <= 3;
						 end
					    4'd1: begin
							  maxDamage <= 50; // Flaming Sword
						     spread <= 5;
							  range <= 1;
							  clip <= 2;
						 end
						 4'd2: begin
							  maxDamage <= 21; // Nova Slice
						  	  spread <= 7;
							  range <= 1;
							  clip <= 3; 
						 end
						 4'd3: begin
							  
							  maxDamage <= 0;
						  	  spread <= 0;
							  range <= 0;
							  clip <= 0;
						 end
						 4'd4: begin
							  maxDamage <= 35;
						  	  spread <= 5;
							  range <= 4;
							  clip <= 2;
						 end
				       4'd5: begin
							  maxDamage <= 28;
							  spread <= 7;
							  range <= 6;
							  clip <= 2;
						 end
			          4'd6: begin
							  maxDamage <= 27;
							  spread <= 9;
							  range <= 5;
							  clip <= 2;
						 end
						 4'd7: begin
							  maxDamage <= 0;
						  	  spread <= 0;
							  range <= 0;
							  clip <= 0;
						 end 
						 4'd8: begin
							  maxDamage <= 25;
							  spread <= 5;
							  range <= 3;
							  clip <= 2;
						 end
				       4'd9: begin
							  maxDamage <= 35;
							  spread <= 5;
							  range <= 3;
							  clip <= 2;
						 end
			          4'd10: begin
							  maxDamage <= 18;
							 spread <= 9;
							 range <= 3; 
							 clip <= 2;
                   end
						 4'd11: begin
							  maxDamage <= 0;
						  	  spread <= 0;
							  range <= 0;
							  clip <= 0;
						 end
						 4'd12: begin
							  maxDamage <= 28;
							 spread <= 5;
							 range <= 1;
							 clip <= 3;
						 end
				       4'd13: begin
							  maxDamage <= 35;
							 spread <= 7;
							 range <= 3;
							 clip <= 2;
						 end
			          4'd14: begin
							 maxDamage <= 28;
							 spread <= 5;
							 range <= 4;
							 clip <= 1;
						 end
						 4'd15: begin
						     maxDamage <= 0;
						  	  spread <= 0;
							  range <= 0;
							  clip <= 0;
				       end		 
					endcase 
		 end
		 
		
			     
		 always@(*) begin
		     if (dodge > aim) begin
			      gap <= dodge - aim;
			  end else begin 
			      gap <= aim - dodge;
				end 
		 end 
		 
		 
		 always @(posedge update or posedge rst) begin
		      if (rst == 1'b1) begin 
			       load <= clip;
				    damage <= maxDamage;
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
						     load <= 4'b0;
					    end else begin 
						     load <= load - 4'b1;
						 end
					end 
				end
	         
	     end  
endmodule 