module distance(
    input [3:0]diffX,
	 input [3:0]diffY,
	 output reg[2:0]dist);
	 
	 reg [3:0]xAbs, yAbs;
	 
	 always @(*) begin
	      case({diffX[3], diffY[3]}) 
			    2'b00: begin
				    xAbs = diffX;
					 yAbs = diffY;

				 end 2'b10: begin
				    xAbs = -diffX;
					 yAbs = diffY;
				 end 2'b01: begin
				    xAbs = diffX;
					 yAbs = -diffY;
				 end 2'b11: begin
				    xAbs = -diffX;
					 yAbs = -diffY;
				 end
			endcase
    end
	 always @(*) begin
	     case({yAbs, xAbs}) 
		// --------------------- yAbs = 0
		       6'd000000:
				     dist = 0;
				 6'd000001:
				     dist = 1;
				 6'd000010:
				     dist = 2;
				 6'd000011:
				     dist = 3;
				 6'd000100:
				     dist = 4;
		// --------------------- yAbs = 1
				 6'd001000:
				     dist = 1;
				 6'd001001:
				     dist = 1;
				 6'd001010:
				     dist = 2;
				 6'd001011:
				     dist = 3;
				 6'd001100:
				     dist = 4;
		// --------------------- yAbs = 2
				 6'd010000:
				     dist = 2;
				 6'd010001:
				     dist = 2;
				 6'd010010:
				     dist = 3;
				 6'd010011:
				     dist = 4;
				 6'd010100:
				     dist = 4;
		//	-------------------- yAbs = 3
				 6'd011000:
				     dist = 3;
				 6'd011001:
				     dist = 3;
				 6'd011010:
				     dist = 4;
				 6'd011011:
				     dist = 4;
				 6'd011100:
				     dist = 5;
	  // --------------------- yAbs = 4
				 6'd100000:
				     dist = 4;
				 6'd100001:
				     dist = 4;
				 6'd100010:
				     dist = 4;
				 6'd100011:
				     dist = 5;
				 6'd100100:
				     dist = 6;
			endcase
	end
endmodule 		 
				 