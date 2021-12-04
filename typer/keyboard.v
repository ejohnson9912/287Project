 module keyboard (input clock,
					   input data,
				   	output reg done,
					   output reg [7:0]prevKey);
					  

reg [3:0]index;					  
reg [7:0]currKey = 8'hf0;

reg [2:0]S;
reg [2:0]NS;

parameter startBit = 3'd0,
          getData = 3'd1,
			 update = 3'd2,
			 finish = 3'd3;
			 // can not add extra states
			 
			 


always@(negedge clock) begin
    case(S)
	      startBit: begin
			index = 0;
		   end
			getData: begin
			    currKey[index] <= data;
				 index <= index + 1'b1;
				 
		   end
			update: begin
			    
				 prevKey <= currKey;
			    done = 1'b1;
		       
			end
			finish:
			    done = 1'b0;
			
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
		      NS <= finish;
		  finish:
		      NS <= startBit;
		  
		  
		endcase
end



always @(negedge clock) begin
    S <= NS;
end


		
endmodule 
    
					  
					  