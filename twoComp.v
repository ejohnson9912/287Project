module twoComp(
    input [4:0]num, 
	 output reg[4:0]abs, 
	 output reg negative);
	 
	 always @(*) begin
	     if (num[4] == 1'b1) begin
		     abs = -num;
			  negative = 1'b1;
		end else begin
		     abs = num;
			  negative = 1'b0;
		end
	end
endmodule
    