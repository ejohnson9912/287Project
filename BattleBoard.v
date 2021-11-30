module BattleBoard(
    input clk,
	 input en, 
	 input rst,
	 input switch,
	 input [4:0]xMove, 
	 input [4:0]yMove,
	 output [6:0]HEX2,
	 output [6:0]HEX1,
	 output [6:0]HEX0,
	 
	 
	 output [6:0]HEX6,
	 output [6:0]HEX5,
	 output [6:0]HEX4);
	 
	 wire[4:0] x;
	 wire [4:0]y;
	 wire i = 1'b0;
	 
	 reg[4:0] ones;
	 reg[4:0] tens;
	 reg[4:0] huns;
	 
	 reg[4:0] ones2;
	 reg[4:0] tens2;
	 reg[4:0] huns2;
	 
	
	 
	 point pos1(clk, en, rst, i, xMove, yMove,x, y);
	 
	 rand random(clk, en ,rst, dodge, num);
	 attack a1(clk, en, rst, i, j, num, aim, spread, range, load, damage);
	 character p1(clk, en, rst, i, damage, cost, speed, dodge, health);
	 
	 always @(*) begin
	      
	      ones = x % 10;
			tens = x % 100 / 10;
			huns = x / 100;
			
			ones2 = y % 10;
			tens2 = y % 100 / 10;
			huns2 = y / 100;
			
	 end 
	 
	 
	 seven_segment(ones,HEX0);
    seven_segment(tens,HEX1);
    seven_segment(huns,HEX2);
	     
	 seven_segment(ones2,HEX4);
    seven_segment(tens2,HEX5);
    seven_segment(huns2,HEX6);
	 
endmodule 
	 