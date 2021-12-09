module lcd(
    input CLOCK_50,
	 input PS2_CLK,
	 input PS2_DAT,
    
	 input [3:0]KEY,
	 
	 output [17:0]LEDR,
	 output [7:0]LEDG,
	 
    output LCD_RS,
    output LCD_RW,
    output LCD_EN,
    output LCD_ON,
	 output LCD_BLON,
    output [7:0]LCD_DATA
);




wire en;
wire [7:0]char;

assign LEDG = char;
assign LEDR[4:0] = S;

keyboard kb(CLOCK_50, PS2_CLK, PS2_DAT, en, char);

reg [255:0]name;

reg [4:0]S;
reg [4:0]NS;


parameter prog = 5'd0,
          start = 5'd1,
          p1Move = 5'd2,
			 p1Attack = 5'd3,
			 p1Aim = 5'd4,
			 p2Move = 5'd5,
			 p2Attack = 5'd6,
			 p2Aim = 5'd7;
			 
			 



always@(posedge CLOCK_50) begin
    
	   if (char == 8'h66 & en == 1'b1) 
		   S <= start;
			
		 else if (char == 8'h5A & en == 1'b1) 
		   S <= NS;
			
		else
		   S <= S;
		
	    
end 

always @(posedge CLOCK_50) begin
    
        case(S)
		      prog:
				  name <= "Loading                         ";
		      start:
				  name <= "Laser Lift      BattleBoard     ";
				p1Move:
				  name <= "Player 1 move   Select moves    ";

				p1Attack:
				  name <= "Player 1 attack Select Attack   ";
				p1Aim:
				  name <= "Player 1 aim    Select Aim      ";
				p2Move:
				  name <= "Player 2 move                   ";
				p2Attack:
				  name <= "Player 2 Attack                 ";
				p2Aim:
				  name <= "Player 2 Aim                    ";
		  endcase
	
end
		  

	 





lcd_control lcd(CLOCK_50, en, name, LCD_RS, LCD_RW, LCD_EN, LCD_DATA);
 
endmodule 