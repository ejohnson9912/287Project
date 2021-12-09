module BattleBoard(
    input CLOCK_50,
	 
	 input PS2_CLK, input PS2_DAT,
    
	 input [3:0]KEY, input[17:0]SW,
	 
	 output reg[17:0]LEDR, output [7:0]LEDG,
	 
    output LCD_RS, output LCD_RW, output LCD_EN, output LCD_ON, output LCD_BLON,
    output [7:0]LCD_DATA,
	 
	 output reg [6:0]HEX3, output [6:0]HEX2, output [6:0]HEX1, output [6:0]HEX0,
	 
	 
	 output reg [6:0]HEX7, output [6:0]HEX6, output [6:0]HEX5, output [6:0]HEX4);
	 
	 
	 
	 reg [4:0]S;
    reg [4:0]NS;
	 
	 reg [8:0] num1, num2;
	 
	 assign LEDG = health2[7:0];
	 
	 parameter prog = 5'd0,
          start = 5'd1,
			 p1PInst = 5'd2,
			 p1Pick = 5'd3,
			 p2PInst = 5'd4,
			 p2Pick = 5'd5,
			 p1MInst = 5'd6,
          p1Move = 5'd7,
			 p1AInst = 5'd8,
			 p1Attack = 5'd9,
			 p1AimI = 5'd10,
			 p1Aim = 5'd11,
			 p1DamageD = 5'd12,
			 p2MInst = 5'd13,
          p2Move = 5'd14,
			 p2AInst = 5'd15,
			 p2Attack = 5'd16,
			 p2AimI = 5'd17,
			 p2Aim = 5'd18,
			 p2DamageD = 5'd19,
			 endGame = 5'd20;
			 
	 reg[4:0] ones1;
	 reg[4:0] tens1;
	 reg[4:0] huns1;
	 
	 reg[4:0] ones2;
	 reg[4:0] tens2;
	 reg[4:0] huns2;
	 
	 wire[2:0]diffX;
	 wire[2:0]diffY;
	 wire[2:0]distance;
	 
	 assign diffX = x2 - x1;
	 assign diffY = y2 - y1;
	 
	 reg [4:0]xMove, yMove;

	 wire [4:0]xReal, yReal;
	 reg [1:0]choiceA;
	 reg [4:0]randNum;
	 reg [4:0]aim;
	 reg updateA;
	 reg update;
	 
	 wire xNeg;
	 wire yNeg;
	 
	 wire [6:0]moveTotal = xReal + yReal;
	 
	 twoComp yMoveA(yMove, yReal, yNeg);
	 twoComp xMoveA(xMove, xReal, xNeg);
	 
	// dist distance(diffX, diffY, distance);
	 
	 
	 //----------------------------------------------------------------------- I/O for player 1
	 
	 reg [1:0]chChoice1;
	 reg pointEn1, pointRst1;
	 wire [2:0]x1, y1;
	 
	 
	 point pos1(update, pointEn1, pointRst1, 1'b0, xMove, yMove,x1, y1);
	 
	 reg chEn1, chRst1;
	 reg [5:0]hit1;
	 reg [2:0]cost1;
	 wire [2:0]speed1;
	 wire [2:0]dodge1;
	 wire [8:0]health1;
	 wire [4:0]special1;
	
	 character player1(update, chEn1, chRst1, chChoice1, hit1, cost1, speed1, dodge1, health1, special1);
	 
	 //----------------------------------------------------------------Attacks for Player1
	 
	 reg [3:0]p1AEn, p1ARst;
	 
	 wire[4:0]spread11, spread12,  spread13, spread14;
	 wire[4:0]range11,  range12,   range13,  range14;
	 wire[3:0]load11,   load12,    load13, load14;
	 wire[5:0]damage11, damage12,  damage13, damage14;
	
	 attack p1Attack1(updateA, p1AEn[0], p1ARst[0], chChoice1, 2'd0, dodge2, aim, spread11, range11, load11, damage11);
	 attack p1Attack2(updateA, p1AEn[1], p1ARst[1], chChoice1, 2'd1, dodge2, aim, spread12, range12, load12, damage12);
	 attack p1Attack3(updateA, p1AEn[2], p1ARst[2], chChoice1, 2'd2, dodge2, aim, spread13, range13, load13, damage13);
	 attack p1Attack4(updateA, p1AEn[3], p1ARst[3], chChoice1, 2'd3, dodge2, aim, spread14, range14, load14, damage14);
	 
	 reg rstNum1;
	 wire randNum1;
	 rand random1(en, rstNum1, dodge2, randNum1);
	 
    // -------------------------------------------------------------------- end I/O for player 1
	 
	 // ---------------------------------------------------------------------- I/O for player 2
	 
	 reg [1:0]chChoice2;
	 reg pointEn2, pointRst2;
	 wire [2:0]x2, y2;
	 
	 
	 point pos2(update, pointEn2, pointRst2, 1'b1, xMove, yMove, x2, y2);
	 
	 reg chEn2, chRst2;
	 reg [5:0]hit2;
	 reg [2:0]cost2;
	 wire [2:0]speed2;
	 wire [2:0]dodge2;
	 wire [8:0]health2;
	 wire [4:0]special2;
	
	 character player2(update, chEn2, chRst2, chChoice2, hit2, cost2, speed2, dodge2, health2, special2);
	 
	 reg [3:0]p2AEn, p2ARst;
	 
	 wire[4:0]spread21, spread22,  spread23, spread24;
	 wire[4:0]range21,  range22,   range23,  range24;
	 wire[3:0]load21,   load22,    load23, load24;
	 wire[5:0]damage21, damage22,  damage23, damage24;
	 
	 attack p2Attack1(updateA, p2AEn[0], p2ARst[0], chChoice2, 2'd0, dodge1, aim, spread21, range21, load21, damage21);
	 attack p2Attack2(updateA, p2AEn[1], p2ARst[1], chChoice2, 2'd1, dodge1, aim, spread22, range22, load22, damage22);
	 attack p2Attack3(updateA, p2AEn[2], p2ARst[2], chChoice2, 2'd2, dodge1, aim, spread23, range23, load23, damage23);
	 attack p2Attack4(updateA, p2AEn[3], p2ARst[3], chChoice2, 2'd3, dodge1, aim, spread24, range24, load24, damage24);
	 
    reg rstNum2;
	 wire randNum2;
	 rand random2(en, rstNum2, dodge1, randNum2);
	 
	 
	 
	 
	 
	 // -------------------------------------------------------------------- end I/O for player 2
	 
   
	 wire en;
	 wire [7:0]char;
	 
	 
	 keyboard key_control(CLOCK_50, PS2_CLK, PS2_DAT, en, char);
	 
	 assign LCD_ON = 1'b1;
	 reg[255:0]string;
	 
	
	 lcd lcd_control(CLOCK_50, en, string, LCD_RS, LCD_RW, LCD_EN, LCD_DATA, check);
	 
	 
	 // always block to control #user input
	 
	 always @(posedge CLOCK_50) begin
    
        case(S)
		      prog: begin
				 
				  
				  
				end
		      start: begin
				  pointRst1 <= 1'b1;
				  pointRst2 <= 1'b1;
				  
				  num1 <= 0;
				  num2 <= 0;
				  
				  choiceA <= 0;
				  aim <= 0;
				  
				end
				p1PInst: begin
				  pointRst1 <= 1'b0;
				  
				  chChoice1 <= 0;
				  num1 <= 0;
				  num2 <= 0;
				end
				p1Pick: begin
				    
					 if (en == 1'b1) begin
				      case(char) 
							 8'h1D:
							     chChoice1 <= chChoice1 + 1'b1;
							 8'h1B:
							     chChoice1 <= chChoice1 - 1'b1;
								  
						endcase
						p1ARst <= 4'b1111;
						chRst1 <= 1'b1;
					end else begin
		            p1ARst <= 4'b0;
						chRst1 <= 1'b0;
					end	  
					num1 <= health1;
				   num2 <= speed1;
					
			   end
				p2PInst: begin
				   pointRst2 <= 1'b0;
					chChoice2 <= 0;
					num1 <= 0;
					num2 <= 0;
				end
				p2Pick: begin
				   if (en == 1'b1) begin

				      case(char) 
							 8'h1D:
							     chChoice2 <= chChoice2 + 1'b1;
							 8'h1B:
							     chChoice2 <= chChoice2 - 1'b1;
						endcase
						
						p2ARst <= 4'b1111;
						chRst2 <= 1'b1;
					end else begin
		            p2ARst <= 4'b0;
						chRst2 <= 1'b0;
					end
					num1 <= health2;
					num2 <= speed2;
			      
				  
				end
				p1MInst: begin
				  hit1 <= 0;
				  chEn1 <= 1'b0;
				  num1 <= 0;
				  num2 <= 0;
				  
				end
				p1Move: begin
				  num1 <= yReal;
				  num2 <= xReal;
				  
				  pointEn1 = 1'b1;
				  LEDR[2:0] <= y1;
				  LEDR[12:10] <= x1;
				  if (en == 1'b1) begin
				      case(char) 
						    8'h23: begin
							     if ((xMove[4] == 1'b0 & (moveTotal >= speed1)) | yReal >= speed1) 
							         xMove <= xMove;
								  else 
								      xMove <= xMove + 1'b1;
							 end
							 8'h1C: begin  
							     if ((xMove[4] == 1'b1 & (moveTotal >= speed1)) | yReal >= speed1)
							         xMove <= xMove; 
								  else 
								      xMove <= xMove - 1'b1;
							 end	      
							 8'h1D: begin
							     if ((yMove[4] == 1'b0 & (moveTotal >= speed1)) | xReal >= speed1)
							         yMove <= yMove;
								  else 
								      yMove <= yMove + 1'b1;
							 end
							 8'h1B: begin
							     if ((yMove[4] == 1'b1 & (moveTotal >= speed1)) | xReal >= speed1)
							         yMove <= yMove;
								  else 
								      yMove <= yMove - 1'b1;
							end
						endcase
					end
				end 
				p1AInst: begin
				  LEDR[2:0] <= x1;
				  LEDR[12:10] <= y1;
			     pointEn1 <= 1'b0;
				  num1 <= 0;
				  num2 <= 0;
				  xMove <= 0;
				  yMove <= 0; 
				end 
				p1Attack: begin
				   p1ARst <= 4'b0;
				   if (en == 1'b1) begin
				      case(char) 
							 8'h1D:
							     choiceA <= choiceA + 1'b1;
							 8'h1B:
							     choiceA <= choiceA - 1'b1;
						endcase
					end 
			      case(choiceA)
					     2'd0: begin
						     num1 <= damage11; 
							  num2 <= range11;
							  p1AEn <= 4'b0001;
							  LEDR[14:0] <= load11;
							  
						  end
						  2'd1: begin
						     num1 <= damage12;
							  num2 <= range12;
							  p1AEn <= 4'b0010;
							  LEDR[14:0] <= load12;
							 
						  end
						  2'd2: begin
						     num1 <= damage13;
							  num2 <= range13;
							  p1AEn <= 4'b0100;
							  LEDR[14:0] <= load13;
							  
                    end
						  2'd3: begin
						     num1 <= damage14;
							  num2 <= range14;
							  p1AEn <= 4'b1000;
							  LEDR[14:0] <= load14;
						  end
					endcase	
				   	
				 
				end
				
				p1AInst: begin
               LEDR[14:0] <= load11;
				   
				end
				
				p1Aim: begin
				  num1 <= aim;
				  chEn2 <= 1'b1;
				  num2 <= health2;
   
				  if (en == 1'b1) begin
				      case(char) 
							 8'h1D: begin
							   if (aim == dodge2)
								    aim <= aim;
								else 
    							    aim <= aim + 1'b1;
							 end
 							 8'h1B: begin
							     if (aim == 0)
								    aim <= aim;
								else 
    							    aim <= aim - 1'b1;
							end
						endcase
					end
					
					
					
				end
				p1DamageD:begin
				   updateA <= 1'b1;
				   case(choiceA)
					   2'd0:
						   hit2 <= damage11;
						2'd1:
						   hit2 <= damage12;
						2'd2:
						   hit2 <= damage13;
						2'd3:
						   hit2 <= damage14;
					endcase
					num1 <= hit2;
	         end
		      
//----------------------------------------------------------------------------------------		
		      p2MInst: begin
				   num2 <= health2;
				   updateA <= 1'b0;
		        	hit2 <= 0;
					aim <= 0;
					
				end 
				
				p2Move: begin
				  num2 <= health2;
				  num1 <= yReal;
				  pointEn2 = 1'b1;
				  if (en == 1'b1) begin
				      case(char)
				           8'h1D: begin
							     if (xMove[4] == 0 && moveTotal >= speed2)
							         xMove <= xMove;
								  else 
								      xMove <= xMove + 1'b1;
							 end
							 8'h1B: begin
							     if (xMove[4] == 1 && moveTotal >= speed2)
							         xMove <= xMove;
								  else 
								      xMove <= xMove - 1'b1;
							 end	      
							 8'h23: begin
							     if (yMove[4] == 0 && moveTotal > speed2 + 1)
							         yMove <= yMove;
								  else 
								      yMove <= yMove + 1'b1;
							 end
							 8'h1C: begin
							     if (yMove[4] == 1 && moveTotal > speed2 + 1)
							         yMove <= yMove;
								  else 
								      yMove <= yMove - 1'b1;
							end
						endcase
				  end
				end 
				
			   p2AInst: begin
				  xMove <= 0;
				  yMove <= 0;
			     pointEn2 = 1'b0;
				  num1 <= health1;
				  num2 <= health2;
				end 
				p2Attack: begin
				  
				  
				  
				  if (en == 1'b1) begin
				      case(char) 
							 8'h1D:
							     choiceA <= choiceA + 1'b1;
							 8'h1B:
							     choiceA <= choiceA - 1'b1;
						endcase
					end 
			      case(choiceA)
					     2'd0: begin
						     num1 = damage21; 
							  num2 = load21;
							  p2AEn <= 4'b0001;
						  end
						  2'd1: begin
						     num1 = damage22;
							  num2 = load22;
							  p2AEn <= 4'b0010;
						  end
						  2'd2: begin
						     num1 = damage23;
							  num2 = load23;
							  p2AEn <= 4'b0100;
                    end
						  2'd3: begin
						     num1 = damage24;
							  num2 = load24;
							  p2AEn <= 4'b1000;
						  end
					endcase
					
				end  
				p2Aim: begin
				 ;
				 end
				p2DamageD: begin
				end
				endGame: begin
				end
		  endcase
	
    end
	 
	 // always block to control  ~ lcd 
	 
	 always @(posedge CLOCK_50) begin
    
        case(S)
		      prog: begin
				  string <= "Loading                         ";
				  
				end
		      start: begin
				  string <= "Laser Lift      BattleBoard     ";
				  
				end
				p1PInst: begin
				   string <="Player 1: choose your character ";
				end
				p1Pick: begin
				    case(chChoice1)
					     2'd0:
						     string <= "Flame Knight                    ";
						  2'd1:
						     string <= "Plasmo                          ";
						  2'd2:
						     string <= "Pinky                           ";
						  2'd3:
						     string <= "Electrix                        ";
					 endcase
				end
				p2PInst: begin
				    string <= "Player 2: choose your character ";
				end
				p2Pick: begin
				    case(chChoice2)
					     2'd0:
						     string <= "Flame Knight                    ";
						  2'd1:
						     string <= "Plasmo                          ";
						  2'd2:
						     string <= "Pinky                           ";
						  2'd3:
					        string <= "Electrix                        ";  
					  endcase  
				end
	         p1MInst: begin
				           string <= "Player 1 Move                   ";
					 
				end
	              			
				p1Move: begin
				    case (chChoice1) 
					     2'd0:
						     string <= "Max Move 4      X move: Y move: ";
						  2'd1:
						     string <= "Max Move 6      X move: Y move: ";
						  2'd2:
						     string <= "Max Move 2      X move: Y move: ";
						  2'd3:
					        string <= "Max Move 8      X move: Y move: ";
				    endcase
				end 
				
				p1AInst: begin
				  string <=   "Player 1 Attack Select Attack   ";
				end
				p1Attack: begin
				   
						
					case ({chChoice1, choiceA}) 
						 4'd0:
							 string <=  "FireBall        D:42 S:7        ";
					    4'd1:
							  string <= "Flaming Blade   D:50 S:5        ";
						 4'd2:
							  string <= "Ender Flame     D:18 S:3        ";
						 4'd3:
							  string <= "Nova Slice      D:30 S:9        ";
						 4'd4:
		                 string <= "Plasmic Punch   D:35 S:5        ";
				       4'd5:
		                 string <= "Zap Shot        D:28 S:7        ";
			          4'd6:
		                 string <= "Palm Laser      D:27 S:9        ";
						 4'd7:
		                 string <= "Boot Blast      D:25 S:5        ";	
						 4'd8:
		                 string <= "Neon Hit        D:25 S:5        ";
				       4'd9:
		                 string <= "Heart Laser     D:35 S:5        ";
			          4'd10:
		                 string <= "Hack Shock      D:18 S:9        ";
						 4'd11:
		                 string <= "Photon Jab      D:42 S:3        ";
						 4'd12:
		                 string <= "Cord Wrap       D:28 S:5        ";
				       4'd13:
		                 string <= "ShockWave       D:35 S:7        ";
			          4'd14:
		                 string <= "Battery         D:28 S:5        ";
						 4'd15:
		                 string <= "Electric Sting  D:45 S:5        ";	  
					endcase  
					
			   end
				
				p1AimI: begin
				  string <= "Player 1 aim    Select Aim      ";
				end
				p1Aim: begin
				  case (chChoice2) 
					     2'd0:
						     string <= "P2 Max dodge 5                  ";
						  2'd1:
						     string <= "P2 Max dodge 7                  ";
						  2'd2:
						     string <= "P2 Max dodge 5                  ";
						  2'd3:
					        string <= "P2 Max dodge 9                  ";
				   endcase
				end
				p1DamageD: begin
				           string <= "Damage Dealt                    "; 
				
				end
				p2MInst: begin
				           string <= "Player 2 Move                   ";
					 
				end
	              			
				p2Move: begin
				    case (chChoice2)
					     2'd0:
						     string <= "Max Move 4      X move: Y move: ";
						  2'd1:
						     string <= "Max Move 6      X move: Y move: ";
						  2'd2:
						     string <= "Max Move 2      X move: Y move: ";
						  2'd3:
					        string <= "Max Move 8      X move: Y move: ";
				    endcase
				end 
				
				p2AInst: begin
				  string <=   "Player 2 Attack Select Attack   ";
				end
				p2Attack: begin
				   
						
					case ({chChoice2, choiceA}) 
						 4'd0:
							 string <=  "FireBall        D:42 S:7        ";
					    4'd1:
							  string <= "Flaming Blade   D:50 S:5        ";
						 4'd2:
							  string <= "Ender Flame     D:18 S:3        ";
						 4'd3:
							  string <= "Nova Slice      D:30 S:9        ";
						 4'd4:
		                 string <= "Plasmic Punch   D:35 S:5        ";
				       4'd5:
		                 string <= "Zap Shot        D:28 S:7        ";
			          4'd6:
		                 string <= "Palm Laser      D:27 S:9        ";
						 4'd7:
		                 string <= "Boot Blast      D:25 S:5        ";	
						 4'd8:
		                 string <= "Neon Hit        D:25 S:5        ";
				       4'd9:
		                 string <= "Heart Laser     D:35 S:5        ";
			          4'd10:
		                 string <= "Hack Shock      D:18 S:9        ";
						 4'd11:
		                 string <= "Photon Jab      D:42 S:3        ";
						 4'd12:
		                 string <= "Cord Wrap       D:28 S:5        ";
				       4'd13:
		                 string <= "ShockWave       D:35 S:7        ";
			          4'd14:
		                 string <= "Battery         D:28 S:5        ";
						 4'd15:
		                 string <= "Electric Sting  D:45 S:5        ";	  
					endcase  
					
			   end
				
				p2AimI: begin
				  string <= "Player 2 aim    Select Aim      ";
				end
				p2Aim: begin
				  case (chChoice1) 
					     2'd0:
						     string <= "P1 Max dodge 5                  ";
						  2'd1:
						     string <= "P1 Max dodge 7                  ";
						  2'd2:
						     string <= "P1 Max dodge 5                  ";
						  2'd3:
					        string <= "P1 Max dodge 9                  ";
				   endcase
				end
				p2DamageD: begin
				           string <= "Damage Dealt                    ";
				end
	         endGame: begin
				    if (health1[8] == 1 || health1 == 9'b0) 
					    string <=     "Player 2 wins                   ";
				    else  
					    string <=     "Player 1 wins                   ";
				end
	            			
		  endcase
	
    end
	 
	 
	 
	 // always blocks for $FSM
	 
	 always @(*) begin
	     case (S) 
		      prog:
				   NS = start;
		      start:
				   NS = p1PInst;
				p1PInst:
				   NS = p1Pick;
			   p1Pick:
				   NS = p2PInst;
				p2PInst:
				   NS = p2Pick;
				p2Pick:
				   NS = p1MInst;
				p1MInst:
				   NS = p1Move;
				p1Move:
				   NS = p1AInst;
				p1AInst:
				   NS = p1Attack;
				p1Attack:
				   NS = p1AimI;
				p1AimI:
				   NS = p1Aim;
				p1Aim:
				   NS = p1DamageD;
				p1DamageD:
				   NS = p2MInst;
		
				p2MInst:
				   NS = p2Move;
				p2Move:
				   NS = p2AInst;
				p2AInst:
				   NS = p2Attack;
				p2Attack:
				   NS = p2AimI;
				p2AimI:
				   NS = p2Aim;
				p2Aim:
				   NS = p2DamageD;
				p2DamageD:
				   NS = p1MInst;
				endGame:
				   NS = start;
				 
				
		endcase
    end
	 
	 always@(posedge CLOCK_50) begin
    
	   if (char == 8'h66 & en == 1'b1) begin
		   S <= start;
			
		end	
		else if (char == 8'h5A & en == 1'b1) begin 
		   S <= NS;
			update <= 1'b1;
		end
		else begin
		   S <= S;
			update <= 1'b0;
		end
		
	    
    end 
	 
	 // seven segments always block & math ^
	 
	 always @(*) begin
	     
	 end
	 
	 always @(*) begin
	      
	      ones1 = num1 % 10;
			tens1 = (num1 % 100) / 10;
			huns1 = (num1 / 100);
		
			
			ones2 = num2 % 10;
			tens2 = (num2 % 100) / 10;
			huns2 = (num2 / 100);
			
			if (S == p1Move | S == p2Move) begin
			   HEX7 = xNeg == 1'b1 ? 7'b0111111 : 7'b1111111;
				HEX3 = yNeg == 1'b1 ? 7'b0111111 : 7'b1111111;
			end else begin
		      HEX3 = 7'b1000000;
				HEX7 = 7'b1000000;
			end
			
		
	 end 
	 
	 
	 seven_segment(ones1,HEX0);
    seven_segment(tens1,HEX1);
    seven_segment(huns1,HEX2);
	 
	     
	 seven_segment(ones2,HEX4);
    seven_segment(tens2,HEX5);
	 seven_segment(huns2, HEX6);
	 
	 
   
	 
endmodule 
	 