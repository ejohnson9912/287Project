module rand(
    input clk,
	 input en,
	 input rst,
	 input [4:0]dodge,
	 output reg [4:0]num);
	 
	 reg [4:0] seed;
	 
	 always @(posedge clk or negedge rst) begin
	     if (rst == 1'b0) begin
		      num <= seed;
				seed <= dodge;
			end else begin
			   seed <= {seed[2] ~^ seed[3], !seed[4], seed[1:0], seed[4] ^ seed[2]};
				num <= (seed % dodge);
			end
	 end 
	  
endmodule 	 