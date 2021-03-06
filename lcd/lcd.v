module lcd_control(
   input clock,
	input rst,
	input [255:0]data,
	output reg LCD_RS,
	output LCD_RW,
	output LCD_EN,
	output reg [7:0] LCD_DATA,
	output reg check
);
	parameter	INIT_STATE	=	0;	// Initialization state
	parameter	LOAD_STATE	=	1;	// Loading instruction state
	parameter	PUSH_STATE	=	2;	// Pushing instruction state
	parameter	IDLE_STATE	=	3;	// Standby state
	
	/* Creating Custom Characters on LCD*/


									// R0		R1		R2		R3		R5		R6		R7		R8    
	//parameter	BLANK			=	11111_11111_11111_11111_11111_11111_11111_11111; //This did create a completely blank square on first attempt
	//parameter	WINDOW		=  10001_10001_10001_10001_10001_10001_10001_11111; //This did not work; created another blank square. Method must not work. 
	
	/*reg [7:0] test [4:0] = {
											8'b00000100,
  											8'b00000100,
  											8'b00011111,
  											8'b00001110,
  											8'b00001110,
  											8'b00011111,
  											8'b00001110,
  											8'b00000100 }; */
	
	
	
	/* End of Custom Characters on LCD */
	

	reg [5:0] index;
	reg [2:0] state;
	
	reg dispClock;
   reg [25:0]counter;

	always @(posedge dispClock or posedge rst) begin
		if (rst == 1'b1) begin
			index <= 0;
			state <= INIT_STATE;
		end
		else begin
			case (state)
				INIT_STATE: begin
					index <= 0;
					state <= LOAD_STATE;
					
				end
				LOAD_STATE: begin
					state <= (index > 36 ? IDLE_STATE : PUSH_STATE);
				
				end
				PUSH_STATE: begin
					index <= index + 1;
					state <= LOAD_STATE;
				end
				IDLE_STATE : begin
					state <= IDLE_STATE;
				end
				default: begin
					index <= 0;
					state <= INIT_STATE;
				end
			endcase
		end
	end

	assign LCD_EN = (state == PUSH_STATE);
	assign LCD_RW = 0;
	
	always @(*) begin
		case (index)
				  0: {LCD_RS, LCD_DATA} = {1'b0, 8'b0011_1000};		// Function set: 8-bit operation, 2-line display, 5x8 dot character font
				  1: {LCD_RS, LCD_DATA} = {1'b0, 8'b0000_0110};		// Entry mode set: Move cursor to the right every time a character is written
				  2: {LCD_RS, LCD_DATA} = {1'b0, 8'b0000_0001};		// Clear display
						/* First Row Of Display*/						
				  3: {LCD_RS, LCD_DATA} = {1'b1,  data[255:248]}; //"A" already knows to display. How do I create custom items on the block. 5x8 				 
				  4: {LCD_RS, LCD_DATA} = {1'b1,  data[247:240]};	//"B" already works.
				  5: {LCD_RS, LCD_DATA} = {1'b1,  data[239:232]};
				  6: {LCD_RS, LCD_DATA} = {1'b1,  data[231:224]};
				  7: {LCD_RS, LCD_DATA} = {1'b1,  data[223:216]};
				  8: {LCD_RS, LCD_DATA} = {1'b1,  data[215:208]};
				  9: {LCD_RS, LCD_DATA} = {1'b1,  data[207:200]};
				 10: {LCD_RS, LCD_DATA} = {1'b1,  data[199:192]};
				 11: {LCD_RS, LCD_DATA} = {1'b1,  data[191:184]};
				 12: {LCD_RS, LCD_DATA} = {1'b1,  data[183:176]};
				 13: {LCD_RS, LCD_DATA} = {1'b1,  data[175:168]};
				 14: {LCD_RS, LCD_DATA} = {1'b1,  data[167:160]};
				 15: {LCD_RS, LCD_DATA} = {1'b1,  data[159:152]};
				 16: {LCD_RS, LCD_DATA} = {1'b1,  data[151:144]};
				 17: {LCD_RS, LCD_DATA} = {1'b1,  data[143:136]};
				 18: {LCD_RS, LCD_DATA} = {1'b1,  data[135:128]};
			 
				 19: {LCD_RS, LCD_DATA} = {1'b0, 8'b1100_0000};		// Set DDRAM address: Move cursor to the beginning of second line
			 	
				 20: {LCD_RS, LCD_DATA} = {1'b1,  data[127:120]};
				 21: {LCD_RS, LCD_DATA} = {1'b1,  data[119:112]};
				 22: {LCD_RS, LCD_DATA} = {1'b1,  data[111:104]};
				 23: {LCD_RS, LCD_DATA} = {1'b1,  data[103:96]};
				 24: {LCD_RS, LCD_DATA} = {1'b1,  data[95:88]};
				 25: {LCD_RS, LCD_DATA} = {1'b1,  data[87:80]};
				 26: {LCD_RS, LCD_DATA} = {1'b1,  data[79:72]};
				 27: {LCD_RS, LCD_DATA} = {1'b1,  data[71:64]};
				 28: {LCD_RS, LCD_DATA} = {1'b1,  data[63:56]};
				 29: {LCD_RS, LCD_DATA} = {1'b1,  data[55:48]};
				 30: {LCD_RS, LCD_DATA} = {1'b1,  data[47:40]};
				 31: {LCD_RS, LCD_DATA} = {1'b1,  data[39:32]};
				 32: {LCD_RS, LCD_DATA} = {1'b1,  data[31:24]};
				 33: {LCD_RS, LCD_DATA} = {1'b1,  data[23:16]};
				 34: {LCD_RS, LCD_DATA} = {1'b1,  data[15:8]};
				 35: {LCD_RS, LCD_DATA} = {1'b1,  data[7:0]};

			default: {LCD_RS, LCD_DATA} = {1'b0, 8'b1000_0000};		// Set DDRAM address: Move cursor to the beginning of first line
		endcase 
	end
	
	always @(posedge clock or posedge rst) begin
	if (rst == 1'b1)
		begin
			counter = 26'd0;
			dispClock = 1'b0;
		end
	else
		begin
		    counter = counter + 1'b1;
		
		if (counter == 26'd100_000)
			begin
				counter = 26'd0;
				dispClock = ~dispClock;
			end
			
	end
end
	
	

endmodule 




/* LCD Instructions
															 Hex  Binary
Clear display screen										01	00000001
Return cursor home										02	00000010
Shift cursor left											10	00010000
Shift cursor right										14	00010100
Shift display left										18	00011000
Shift display right										1C	00011100
Move cursor to beginning of 1st line				80	10000000
Move cursor to beginning to 2nd line				C0	11000000
Function Set: 2 lines, 5x7 matrix, 8-bit mode	38	00111000
Entry Mode: Cursor moves right on new char		06	00000110
*/