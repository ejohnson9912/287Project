module keyboard (input clock,
					  input  data,
					  output reg [7:0]prevKey,
					  output reg done);
					  

reg [3:0]index;					  
reg [7:0]currKey = 8'hf0;





reg [2:0]S;
reg [2:0]NS;

parameter startBit = 3'd0,
          getData = 3'd1,
			 update = 3'd2;
			 
			 
			 


always@(negedge clock) begin
    case(S)
	      startBit: begin
			    index <= 0;
		   end
			getData: begin
			    currKey[index] <=  data;
				 index <= index + 1'b1;
				 if(index >= 8) 
				    done <= 1'd1;
				 else 
				    done <= 1'b0;
				    
			end
			update: begin
				 prevKey <= currKey;
			    done <= 1'b0;
		       
			end
			
	 endcase
    
end

always @(*) begin
    case(S) 
	     startBit:
		     NS <= getData;
		  getData: begin
		     if (index < 8) 
              NS <= getData;
           else 
              NS <= update; 
	     end		  
		  update:
		      NS <= startBit;
		  
		endcase
end



always @(negedge clock) begin
    S <= NS;
	 
end


		
endmodule 
    
					  
					  