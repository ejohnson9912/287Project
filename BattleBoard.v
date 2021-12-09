module BattleBoard(
    input CLOCK_50,
	 
	 input PS2_CLK, input PS2_DAT,
    
	 input [3:0]KEY, input[17:0]SW,
	 
	 output reg[17:0]LEDR, output reg[7:0]LEDG,
	 
    output LCD_RS, output LCD_RW, output LCD_EN, output LCD_ON, output LCD_BLON,
    output [7:0]LCD_DATA,
	 
	 output reg [6:0]HEX3, output [6:0]HEX2, output [6:0]HEX1, output [6:0]HEX0,
	 
	 
	 output reg [6:0]HEX7, output [6:0]HEX6, output [6:0]HEX5, output [6:0]HEX4,
	 
	 output VGA_CLK, output VGA_HS, output VGA_BLANK_N, output VGA_SYNC_N, output VGA_VS,
	
	 output [9:0]VGA_R, output [9:0]VGA_G, output [9:0]VGA_B
	 
	 );
	 
	 
	 
	 reg [4:0]S;
    reg [4:0]NS;
	 
	 reg [8:0] num1, num2;
	 
	 
	 
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
			 p1RInst = 5'd11,
			 p1Aim = 5'd12,
			 p1Reload = 5'd13,
			 p1UpdateA = 5'd14,
			 p1DamageD = 5'd15,
			 p2MInst = 5'd16,
          p2Move = 5'd17,
			 p2AInst = 5'd18,
			 p2Attack = 5'd19,
			 p2AimI = 5'd20,
			 p2RInst = 5'd21,
			 p2Aim = 5'd22,
			 p2Reload = 5'd23,
			 p2UpdateA = 5'd24,
			 p2DamageD = 5'd25,
			 endGame = 5'd26;
			 
	 reg[4:0] ones1;   
	 
	 reg[4:0] tens1;
	 reg[4:0] huns1;
	 
	 reg[4:0] ones2;
	 reg[4:0] tens2;
	 reg[4:0] huns2;
	 
	 wire[3:0]diffX = x2 - x1;
	 wire[3:0]diffY = y2 - y1;
	 wire[2:0]distance;
	 
	 reg [4:0]rangeA;
	 reg [4:0]spreadA;
	 reg [3:0]loadA;
	 
	 
	 
	 reg [4:0]xMove, yMove;

	 wire [4:0]xReal, yReal;
	 reg [1:0]choiceA;
	 reg [4:0]aim;
	 reg updateA;
	 reg update;
	 reg reloaded;
	 
	 wire xNeg;
	 wire yNeg;
	 
	 wire [6:0]moveTotal = xReal + yReal;
	 
	 twoComp yMoveA(yMove, yReal, yNeg);
	 twoComp xMoveA(xMove, xReal, xNeg);
	 
	 distance dist(diffX, diffY, distance);
	 
	 wire[17:0]winR;
	 wire[7:0]winG;
	 
	 
	 //----------------------------------------------------------------------- I/O for player 1
	 
	 reg [1:0]chChoice1;
	 
	 
	 reg pointEn1, pointRst1;
	 wire [2:0]x1, y1;
	 
	 
	 point pos1(update, pointEn1, pointRst1, 1'b0, xMove, -yMove,x1, y1);
	 
	 reg chEn1, chRst1;
	 reg [5:0]hit1;
	 reg [2:0]cost1;
	 wire [2:0]speed1;
	 wire [2:0]dodge1;
	 wire [8:0]health1;
	 wire [4:0]special1;
	 wire [2:0]colorP1;
	
	 character player1(update, chEn1, chRst1, chChoice1, hit1, cost1, speed1, dodge1, health1, special1, colorP1);
	 
	 //----------------------------------------------------------------Attacks for Player1
	 
	 reg [3:0]p1AEn, p1ARst;
	 
	 wire[4:0]spread11, spread12,  spread13, spread14;
	 wire[4:0]range11,  range12,   range13,  range14;
	 wire[3:0]load11,   load12,    load13, load14;
	 wire[5:0]damage11, damage12,  damage13, damage14;
	
	 attack p1Attack1(updateA, p1AEn[0], p1ARst[0], chChoice1, 2'd0, randNum1,   aim, spread11, range11, load11, damage11);
	 attack p1Attack2(updateA, p1AEn[1], p1ARst[1], chChoice1, 2'd1, randNum1, aim, spread12, range12, load12, damage12);
	 attack p1Attack3(updateA, p1AEn[2], p1ARst[2], chChoice1, 2'd2, randNum1, aim, spread13, range13, load13, damage13);
	 attack p1Attack4(updateA, p1AEn[3], p1ARst[3], chChoice1, 2'd3, randNum1, aim, spread14, range14, load14, damage14);
	 
	 reg rstNum1;
	 wire randNum1;
	 rand random1(en, rstNum1, dodge2, randNum1);
	 
    // -------------------------------------------------------------------- end I/O for player 1
	 
	 // ---------------------------------------------------------------------- I/O for player 2
	 
	 reg [1:0]chChoice2;
	 
	 
	 reg pointEn2, pointRst2;
	 wire [2:0]x2, y2;
	 
	 
	 point pos2(update, pointEn2, pointRst2, 1'b1, xMove, -yMove, x2, y2);
	 
	 reg chEn2, chRst2;
	 reg [5:0]hit2;
	 reg [2:0]cost2;
	 wire [2:0]speed2;
	 wire [2:0]dodge2;
	 wire [8:0]health2;
	 wire [4:0]special2;
	 wire [2:0]colorP2;
	
	 character player2(update, chEn2, chRst2, chChoice2, hit2, cost2, speed2, dodge2, health2, special2, colorP2);
	 
	 //---------------------------------------------------------------------------------------------------- Attacks for player 2
	 
	 reg [3:0]p2AEn, p2ARst;
	 
	 wire[4:0]spread21, spread22,  spread23, spread24;
	 wire[4:0]range21,  range22,   range23,  range24;
	 wire[3:0]load21,   load22,    load23, load24;
	 wire[5:0]damage21, damage22,  damage23, damage24;
	 
	 attack p2Attack1(updateA, p2AEn[0], p2ARst[0], chChoice2, 2'd0, randNum2, aim, spread21, range21, load21, damage21);
	 attack p2Attack2(updateA, p2AEn[1], p2ARst[1], chChoice2, 2'd1, randNum2, aim, spread22, range22, load22, damage22);
	 attack p2Attack3(updateA, p2AEn[2], p2ARst[2], chChoice2, 2'd2, randNum2, aim, spread23, range23, load23, damage23);
	 attack p2Attack4(updateA, p2AEn[3], p2ARst[3], chChoice2, 2'd3, randNum2, aim, spread24, range24, load24, damage24);
	 
    reg rstNum2;
	 wire randNum2;
	 
	 rand random2(en, rstNum2, dodge1, randNum2);
	 
	 
	 
	 
	 
	 // -------------------------------------------------------------------- end I/O for player 2
	 
   
	 wire en;
	 wire [7:0]char;
	 

	 
	 
	 keyboard key_control(CLOCK_50, PS2_CLK, PS2_DAT, en, char);
	 
	 assign LCD_ON = 1'b1;
	 assign LCD_BLON = 1'b1;
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
				  
				  hit1 = 0;
				  hit2 = 0;
				  
				  xMove <= 0;
				  yMove <= 0;
				  
				  LEDR <= 0;
				  
				  rangeA <= 0;
	           spreadA <= 0;
	           loadA <= 0;
				  
				  choiceA <= 0;
				  aim <= 0;
				end
				p1PInst: begin
				  pointRst1 <= 1'b0;
				  chChoice1 <= 0;
				  
				   
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
					
					
			   end
				p2PInst: begin
				   pointRst2 <= 1'b0;
					chChoice2 <= 0;
					
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
					
			      
				  
				end
				p1MInst: begin
				  
				
				    p2AEn <= 0;
				 
				   chRst2 <= 0;
				   p2ARst <= 4'b0;
					chEn1 <= 1'b0;
				   updateA <= 1'b0;
		        	hit1 <= 0;
					aim <= 0;
				  
				end
				p1Move: begin
				  
				  pointEn1 = 1'b1;
				  
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
				  choiceA <= 1'b1;
				  
			     pointEn1 <= 1'b0;
				  
				  xMove <= 0;
				  yMove <= 0; 
				end 
				p1Attack: begin
				   chRst2 <= 1'b0;
				   p1ARst <= 4'b0;
					reloaded <= 1'b0;
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
							  rangeA <= range11;
							  loadA <= load11;
							  spreadA <= spread11;
							  p1AEn <= 4'b0001;
							  LEDR[16] <= range11 >= distance;
							  LEDR[17] <= load11 > 0;
							  
						  end
						  2'd1: begin
						     
							  p1AEn <= 4'b0010;
							  rangeA <= range12;
							  loadA <= load12;
							  spreadA <= spread12;
							  LEDR[16] <= range12 >= distance;
							  LEDR[17] <= load12 > 0;
							 
						  end
						  2'd2: begin
						     
							  rangeA <= range13;
							  loadA <= load13;
							  spreadA <= spread13;
							  p1AEn <= 4'b0100;
							  LEDR[16] <= range13 >= distance;
							  LEDR[17] <= load13 > 0;
							  
                    end
						  2'd3: begin
						     
							  rangeA <= range14;
							  loadA <= load14;
							  spreadA <= spread14;
							  p1AEn <= 4'b1000;
							  LEDR[16] <= range14 >= distance;
							  LEDR[17] <= load14 > 0;
						  end
					endcase	
				   	
				 
				end
				
				p1AInst: begin
				end
				
				p1RInst: begin
				   choiceA <= 0;
				end
				
				p1Aim: begin
				   
				  reloaded <= 1'b0;
   
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
				
				p1Reload: begin
				      
				     reloaded <= 1'b1;
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
							  rangeA <= range11;
							  spreadA <= spread11;
							  loadA <= load11;
							  
						  end
						  2'd1: begin
							  rangeA <= range12;
							  spreadA <= spread12;
							  loadA <= load12;
							 
						  end
						  2'd2: begin
							  rangeA <= range13;
							  spreadA <= spread13;
							  loadA <= load13;
							  
                    end
						  2'd3: begin
							  rangeA <= range14;
							  spreadA <= spread14;
							  loadA <= load14;
						  end
					endcase
					  
			   end
				
				p1UpdateA: begin
				    updateA <= 1'b1;
				end
				   
				p1DamageD:begin
				    
				   chEn2 <= 1'b1;
               if (reloaded == 1'b1) begin
					    p1ARst[choiceA] <= 1'b1;
						 hit2 <= 0;
					end else if (rangeA < distance) begin
					    hit2 <= 0;
					end else begin
				       updateA <= 1'b0;
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
				   end
					
					
	         end
		      
//----------------------------------------------------------------------------------------		
		      p2MInst: begin
				   
					chRst1 <= 0;
				   p1ARst <= 4'b0;
					p1AEn <= 0;
					chEn2 <= 1'b0;
				   updateA <= 1'b0;
		        	hit2 <= 0;
					aim <= 0;
					
				end 
				
				p2Move: begin
				  
				  pointEn2 = 1'b1;
				  
				  if (en == 1'b1) begin
				      case(char) 
						    8'h23: begin
							     if ((xMove[4] == 1'b0 & (moveTotal >= speed2)) | yReal >= speed2) 
							         xMove <= xMove;
								  else 
								      xMove <= xMove + 1'b1;
							 end
							 8'h1C: begin  
							     if ((xMove[4] == 1'b1 & (moveTotal >= speed2)) | yReal >= speed2)
							         xMove <= xMove; 
								  else 
								      xMove <= xMove - 1'b1;
							 end	      
							 8'h1D: begin
							     if ((yMove[4] == 1'b0 & (moveTotal >= speed2)) | xReal >= speed2)
							         yMove <= yMove;
								  else 
								      yMove <= yMove + 1'b1;
							 end
							 8'h1B: begin
							     if ((yMove[4] == 1'b1 & (moveTotal >= speed2)) | xReal >= speed2)
							         yMove <= yMove;
								  else 
								      yMove <= yMove - 1'b1;
							end
						endcase
					end
				end 
				p2AInst: begin
				  choiceA <= 0;
				  
			     pointEn2 <= 1'b0;
				  
				  xMove <= 0;
				  yMove <= 0; 
				end 
				p2Attack: begin
				   p2ARst <= 4'b0;
					reloaded <= 1'b0;
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
							  rangeA <= range21;
							  loadA <= load21;
							  spreadA <= spread21;
							  p2AEn <= 4'b0001;
							  LEDR[16] <= range21 >= distance;
							  LEDR[17] <= load21 > 0;
							  
						  end
						  2'd1: begin
						     
							  p2AEn <= 4'b0010;
							  rangeA <= range22;
							  loadA <= load22;
							  spreadA <= spread22;
							  LEDR[16] <= range22 >= distance;
							  LEDR[17] <= load22 > 0;
							 
						  end
						  2'd2: begin
						     
							  rangeA <= range23;
							  loadA <= load23;
							  spreadA <= spread23;
							  p2AEn <= 4'b0100;
							  LEDR[16] <= range23 >= distance;
							  LEDR[17] <= load23 > 0;
							  
                    end
						  2'd3: begin
						     
							  rangeA <= range24;
							  loadA <= load24;
							  spreadA <= spread24;
							  p2AEn <= 4'b1000;
							  LEDR[16] <= range24 >= distance;
							  LEDR[17] <= load24 > 0;
						  end
					endcase	
				   	
						
						
				 
				end
				
				p2AInst: begin
				end
				
				p2RInst: begin
				   choiceA <= 0;
				end
				
				p2Aim: begin
				  reloaded <= 1'b0;
   
				  if (en == 1'b1) begin
				      case(char) 
							 8'h1D: begin
							   if (aim == dodge1)
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
				
				p2Reload: begin
				     reloaded <= 1'b1;
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
							  rangeA <= range21;
							  spreadA <= spread21;
							  loadA <= load21;
							  
						  end
						  2'd1: begin
							  rangeA <= range22;
							  spreadA <= spread22;
							  loadA <= load22;
							 
						  end
						  2'd2: begin
							  rangeA <= range23;
							  spreadA <= spread23;
							  loadA <= load23;
							  
                    end
						  2'd3: begin
							  rangeA <= range24;
							  spreadA <= spread24;
							  loadA <= load24;
						  end
					endcase
					  
			   end
				
				p2UpdateA: begin
				    updateA <= 1'b1;
				end
				   
				p2DamageD:begin
				   chEn1 <= 1'b1;
               if (reloaded == 1'b1) begin
					    p2ARst[choiceA] = 1'b1;
						 hit1 <= 0;
					end else if (rangeA < distance) begin
					    hit1 <= 0;
					end else begin
				       updateA <= 1'b0;
				       case(choiceA)
					       2'd0:
						       hit1 <= damage21;
						    2'd1:
						       hit1 <= damage22;
						    2'd2:
						       hit1 <= damage23;
						    2'd3:
						       hit1 <= damage24;
					    endcase
				   end
					
					
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
					        string <= "Max Move 6      X move: Y move: ";
				    endcase
				end 
				
				p1AInst: begin
				  string <=   "Player 1 Attack Select Attack   ";
				end
				p1Attack: begin
				   
						
					case ({chChoice1, choiceA}) 
						 4'd0:
							 string <=  "FireBall        D:42 S:5        ";
					    4'd1:
							  string <= "Flaming Blade   D:50 S:5        ";
						 4'd2:
							  string <= "Nova Slice      D:21 S:7        ";
						 4'd3:
							  string <= "Reload                          ";
						 4'd4:
		                 string <= "Plasmic Punch   D:35 S:5        ";
				       4'd5:
		                 string <= "Zap Shot        D:28 S:7        ";
			          4'd6:
		                 string <= "Palm Laser      D:27 S:7        ";
						 4'd7:
		                 string <= "Reload                          ";	
						 4'd8:
		                 string <= "Neon Hit        D:25 S:5        ";
				       4'd9:
		                 string <= "Heart Laser     D:35 S:5        ";
			          4'd10:
		                 string <= "Hack Shock      D:18 S:7        ";
						 4'd11:
		                 string <= "Reload                          ";
						 4'd12:
		                 string <= "Cord Wrap       D:28 S:5        ";
				       4'd13:
		                 string <= "ShockWave       D:35 S:7        ";
			          4'd14:
		                 string <= "Battery         D:28 S:5        ";
						 4'd15:
		                 string <= "Reload                          ";	  
					endcase  
					
			   end
				
				p1AimI: begin
				  string <= "Player 1 aim    Select Aim      ";
				end
				p1RInst: begin
				  string <= "Pick Attack     to reload       ";
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
					        string <= "P2 Max dodge 7                  ";
				   endcase
				end
				
				p1Reload: begin
				   
						
					case ({chChoice1, choiceA}) 
						 4'd0:
							 string <=  "FireBall        D:42 S:7        ";
					    4'd1:
							  string <= "Flaming Blade   D:50 S:5        ";
						 4'd2:
							  string <= "Nova Slice      D:30 S:7        ";
						 4'd3:
							  string <= "Reload                          ";
						 4'd4:
		                 string <= "Plasmic Punch   D:35 S:5        ";
				       4'd5:
		                 string <= "Zap Shot        D:28 S:7        ";
			          4'd6:
		                 string <= "Palm Laser      D:27 S:7        ";
						 4'd7:
		                 string <= "Reload                          ";	
						 4'd8:
		                 string <= "Neon Hit        D:25 S:5        ";
				       4'd9:
		                 string <= "Heart Laser     D:35 S:5        ";
			          4'd10:
		                 string <= "Hack Shock      D:18 S:7        ";
						 4'd11:
		                 string <= "Reload                          ";
						 4'd12:
		                 string <= "Cord Wrap       D:28 S:5        ";
				       4'd13:
		                 string <= "ShockWave       D:35 S:7        ";
			          4'd14:
		                 string <= "Battery         D:28 S:5        ";
						 4'd15:
		                 string <= "Reload                          ";	  
					endcase 
			   end
				p1UpdateA : begin
				           string <= "Loading Attack                  ";
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
					        string <= "Max Move 7      X move: Y move: ";
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
							  string <= "Nova Slice      D:30 S:7        ";
						 4'd3:
							  string <= "Reload                          ";
						 4'd4:
		                 string <= "Plasmic Punch   D:35 S:5        ";
				       4'd5:
		                 string <= "Zap Shot        D:28 S:7        ";
			          4'd6:
		                 string <= "Palm Laser      D:27 S:7        ";
						 4'd7:
		                 string <= "Reload                          ";	
						 4'd8:
		                 string <= "Neon Hit        D:25 S:5        ";
				       4'd9:
		                 string <= "Heart Laser     D:35 S:5        ";
			          4'd10:
		                 string <= "Hack Shock      D:18 S:7        ";
						 4'd11:
		                 string <= "Reload                          ";
						 4'd12:
		                 string <= "Cord Wrap       D:28 S:5        ";
				       4'd13:
		                 string <= "ShockWave       D:35 S:7        ";
			          4'd14:
		                 string <= "Battery         D:28 S:5        ";
						 4'd15:
		                 string <= "Reload                          ";	  
					endcase  
					
			   end
				
				
				
				p2AimI: begin
				  string <= "Player 2 aim    Select Aim      ";
				end
				
				p2RInst: begin
				  string <= "Pick Attack     to reload       ";
            end
				
				p2Aim: begin
				  string <= "Player 2 aim    Select Aim      ";
				end
				
				p2Reload: begin
				   
						
					case ({chChoice2, choiceA}) 
						 4'd0:
							 string <=  "FireBall        D:42 S:7        ";
					    4'd1:
							  string <= "Flaming Blade   D:50 S:5        ";
						 4'd2:
							  string <= "Nova Slice      D:30 S:7        ";
						 4'd3:
							  string <= "Reload                          ";
						 4'd4:
		                 string <= "Plasmic Punch   D:35 S:5        ";
				       4'd5:
		                 string <= "Zap Shot        D:28 S:7        ";
			          4'd6:
		                 string <= "Palm Laser      D:27 S:7        ";
						 4'd7:
		                 string <= "Reload                          ";	
						 4'd8:
		                 string <= "Neon Hit        D:25 S:5        ";
				       4'd9:
		                 string <= "Heart Laser     D:35 S:5        ";
			          4'd10:
		                 string <= "Hack Shock      D:18 S:7        ";
						 4'd11:
		                 string <= "Reload                          ";
						 4'd12:
		                 string <= "Cord Wrap       D:28 S:5        ";
				       4'd13:
		                 string <= "ShockWave       D:35 S:7        ";
			          4'd14:
		                 string <= "Battery         D:28 S:5        ";
						 4'd15:
		                 string <= "Reload                          ";	  
					endcase  
					
			   end
				p2UpdateA : begin
				           string <= "Loading Attack                  ";
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
	 
	 
	 
	 // always blocks for $ FSM
	 
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
				p1Attack:begin
				   if (choiceA == 2'd3) 
					   NS = p1RInst;
					else 
				      NS = p1AimI;
				end
				p1AimI:
				   NS = p1Aim;
				p1RInst:
				   NS = p1Reload;
				p1Aim:
				   NS = p1UpdateA;
			   p1Reload:
				   NS = p1DamageD;
				
			   p1UpdateA:
				   NS = p1DamageD;
				p1DamageD: begin
				   if (health1 == 0 | health2 == 0) 
					    NS = endGame;
					else 
				       NS = p2MInst;
	         end	
				p2MInst:
				   NS = p2Move;
				p2Move:
				   NS = p2AInst;
				p2AInst:
				   NS = p2Attack;
				p2Attack:begin
				   if (choiceA == 2'd3) 
					   NS = p2RInst;
					else 
				      NS = p2AimI;
				end
				p2AimI:
				   NS = p2Aim;
				p2RInst:
				   NS = p2Reload;
				p2Aim:
				   NS = p2UpdateA;
			   p2Reload:
				   NS = p2DamageD;
			   p2UpdateA:
				   NS = p2DamageD;
				p2DamageD: begin
				   if (health1 == 0 | health2 == 0) 
					    NS = endGame;
					else 
				       NS = p1MInst;
	         end
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
	 
	 reg moving;
	 
	 always @(posedge CLOCK_50) begin
	     case (S) 
		      prog: ;
				start:begin
				   num1 <= 0;
					num2 <= 0;
			   end
				p1PInst: begin
				   num1 <= 0;
					num2 <= 0;
				end
				p1Pick:begin
				    if (en == 1'b1) begin
					     case(char) 
						     8'h33:
					           num1 <= health1;
						     8'h4D:
					           num2 <= speed1;
						     8'h44:
					           num2 <= dodge1;
							  default:begin
							     num1 <= num1;
								  num2 <= num2;
							  end
							     
						  endcase;		  
					  end
				end
				p2PInst:  begin
				     num1 <= 0;
					  num2 <= 0;
			   end
				p2Pick: begin
				    if (en == 1'b1) begin
					     case(char) 
						     8'h33:
					           num1 <= health2;
						     8'h4D:
					           num2 <= speed2;
						     8'h44:
					           num2 <= dodge2;
							  default: begin
							     num1 <= num1;
								  num2 <= num2;
							  end  
						  endcase;		  
					  end
				end
				p1MInst: begin
				     num1 <= 0;
					  num2 <= 0;
					  moving <= 1'b1;
			   end
				p1Move: begin
				
					     case(char) 
						     8'h16: begin
					           num1 <= 6 - y1;
								  num2 <= x1;
								  moving <= 1'b0;
						     end 8'h1E: begin
					           num1 <= 6 - y2;
								  num2 <= x2;
								  moving <= 1'b0;
							  end
							  8'h1B: begin
							     num1 <= yReal;
								  num2 <= xReal;
								  moving <= 1'b1;
							  end
							  8'h23: begin
							     num1 <= yReal;
								  num2 <= xReal;
								  moving <= 1'b1;
							  end
							  8'h1C: begin
							     num1 <= yReal;
								  num2 <= xReal;
								  moving <= 1'b1;
							  end
						     8'h1D: begin
					           num1 <= yReal;
								  num2 <= xReal;
								  moving <= 1'b1;
							  end 
							  8'h33: begin
							     num1 <= health1;
								  num2 <= health2;
								  moving <= 1'b0;
							  end
						     8'h43: begin
						        num1 <= distance;
							     num2 <= 0;
								  moving <= 1'b0;
						     end
						     default: begin
							     num1 <= num1;
								  num2 <= num2;
								  moving <= moving;
							  end	  
						  endcase;		  
					  
				end
			       	
				p1AInst: begin
				     num1 <= 0;
					  num2 <= 0;
			   end
				p1Attack: begin
				    if (en == 1'b1) begin
					     case(char) 
						     8'h16: begin
					           num1 <= 6 - y1;
								  num2 <= x1;
						     end 8'h1E: begin
					           num1 <= 6 - y2;
								  num2 <= x2;
							  end
						     8'h4B:
					           num1 <= loadA;
						     8'h4D:
					           num2 <= spreadA;
						     8'h2D:
					           num2 <= rangeA;
							  8'h43:
							     num1 <= distance;
							  8'h33: begin
							     num1 <= health1;
								  num2 <= health2;
								end
							  default: begin
							     num1 <= num1;
								  num2 <= num2;
							  end
						  endcase;		  
					  end
				end
				p1AimI: begin
				    num1 <= 0;
					 num2 <= 0;
            end				
				p1RInst: begin
				     num1 <= 0;
					  num2 <= 0;
			   end
				p1Aim: begin
				    num1 <= aim;
					 num2 <= dodge2;
				end 
				
				     
				p1Reload: begin
				    if (en == 1'b1) begin
					     case(char) 
						     8'h4B:
					           num1 <= loadA;
						     8'h4D:
					           num2 <= spreadA;
						     8'h2D:
					           num2 <= rangeA;
							  8'h43:
							     num1 <= distance;
							  default: begin
							     num1 <= num1;
								  num2 <= num2;
							  end
						  endcase;		  
					  end
				end 
				p1DamageD: begin
				   num1 <= hit2;
					num2 <= health2 - hit2;
				end
				p2MInst: begin
				     num1 <= 0;
					  num2 <= 0;
					  moving <= 1'b1;
			   end
				p2Move: begin
					     case(char) 
						     8'h16: begin
					           num1 <= 6 - y1;
								  num2 <= x1;
								  moving <= 1'b0;
						     end 8'h1E: begin
					           num1 <= 6 - y2;
								  num2 <= x2;
								  moving <= 1'b0;
							  end
							  8'h1B: begin
							     num1 <= yReal;
								  num2 <= xReal;
								  moving <= 1'b1;
							  end
							  8'h23: begin
							     num1 <= yReal;
								  num2 <= xReal;
								  moving <= 1'b1;
							  end
							  8'h1C: begin
							     num1 <= yReal;
								  num2 <= xReal;
								  moving <= 1'b1;
							  end
						     8'h1D: begin
					           num1 <= yReal;
								  num2 <= xReal;
								  moving <= 1'b1;
							  end 
							  8'h33: begin
							     num1 <= health1;
								  num2 <= health2;
								  moving <= 1'b0;
							  end
						     8'h43: begin
						        num1 <= distance;
							     num2 <= 0;
								  moving <= 1'b0;
						     end
						     default: begin
							     num1 <= num1;
								  num2 <= num2;
								  moving <= moving;
							  end	  
						  endcase;		  
					  
				end
				p2AInst: begin
				     num1 <= 0;
					  num2 <= 0;
			   end
				p2Attack: begin
				    if (en == 1'b1) begin
					     case(char)
						     8'h16: begin
					           num1 <= 6 - y1;
								  num2 <= x1;
						     end 8'h1E: begin
					           num1 <= 6 - y2;
								  num2 <= x2;
							  end 
						     8'h4B:
					           num1 <= loadA;
						     8'h4D:
					           num2 <= spreadA;
						     8'h2D:
					           num2 <= rangeA;
							  8'h43:
							     num1 <= distance;
							  8'h33: begin
							     num1 <= health1;
								  num2 <= health2;
							  end
							  default: begin
							     num1 <= num1;
								  num2 <= num2;
							  end
						  endcase;		  
					  end
				end
				p2AimI: begin
				     num1 <= 0;
					  num2 <= 0;
			   end
				p2RInst: begin
				     num1 <= 0;
					  num2 <= 0;
			   end
				
				p2Aim: begin
				    num1 <= aim;
					 num2 <= dodge1;
				end
				p2Reload: begin
			        if (en == 1'b1) begin
					     case(char) 
						     8'h4B:
					           num1 <= loadA;
						     8'h4D:
					           num2 <= spreadA;
						     8'h2D:
					           num2 <= rangeA;
							  8'h43:
							     num1 <= distance;
							  default: begin
							     num1 <= num1;
								  num2 <= num2;
							  end  
						  endcase;		  
					  end
			   end
				
				p2DamageD: begin
				   num1 <= hit1;
					num2 <= health1 - hit1;
				end     
				endGame: begin
				    num1 <= 0;
					 num2 <= 0;
				end 
			endcase
	 end
	 
	 
	 
	 
	 
	 always @(*) begin
	      
	      ones1 = num1 % 10;
			tens1 = (num1 % 100) / 10;
			huns1 = (num1 / 100);
		
			
			ones2 = num2 % 10;
			tens2 = (num2 % 100) / 10;
			huns2 = (num2 / 100);
			
			if ((S == p1Move | S == p2Move) & moving == 1'b1) begin
			   
				
				if (yNeg == 1'b1)
				    HEX3 = 7'b0111111;
				else 
				    HEX3 = 7'b1111111;
					 
			   if (xNeg == 1'b1)
				    HEX7 = 7'b0111111;
				else 
				    HEX7 = 7'b1111111;
				
			end else begin
		      HEX3 = 7'b1111111;
				HEX7 = 7'b1111111;
			end
			
		
	 end 
	 
	 
	 seven_segment(ones1, HEX0);
    seven_segment(tens1, HEX1);
    seven_segment(huns1, HEX2);
	 
	     
	 seven_segment(ones2, HEX4);
    seven_segment(tens2, HEX5);
	 seven_segment(huns2, HEX6);
	 

	 	 /* Start VGA Fuckery */

	vga_adapter VGA(
  .resetn(1'b1),
  .clock(CLOCK_50),
  .colour(colour),
  .x(x),
  .y(y),
  .plot(1'b1),
  /* Signals for the DAC to drive the monitor. */
  .VGA_R(VGA_R),
  .VGA_G(VGA_G),
  .VGA_B(VGA_B),
  .VGA_HS(VGA_HS),
  .VGA_VS(VGA_VS),
  .VGA_BLANK(VGA_BLANK_N),
  .VGA_SYNC(VGA_SYNC_N),
  .VGA_CLK(VGA_CLK));
defparam VGA.RESOLUTION = "160x120";
defparam VGA.MONOCHROME = "FALSE";
defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
defparam VGA.BACKGROUND_IMAGE = "black.mif";
reg [6:0] vgastate;
reg grid_initing, p1_initing, p2_initing;
reg [7:0] x, y;
reg [7:0] vl1_x, vl1_y, vl2_x, vl2_y, vl3_x, vl3_y, vl4_x, vl4_y, vl5_x, vl5_y, vl6_x, vl6_y;
reg [2:0] line_colour, bg_colour, p1_colour, p2_colour;
reg [7:0] hl1_x, hl1_y, hl2_x, hl2_y, hl3_x, hl3_y, hl4_x, hl4_y, hl5_x, hl5_y, hl6_x, hl6_y;
reg [7:0] p1_x, p1_y, p2_x, p2_y;
reg [2:0] colour;
reg [17:0] draw_counter;
wire frame;
reg [6:0] state;

localparam
  RESET_BLACK = 7'b0000000,
  INIT_GRID = 7'b0000001,
  INIT_P1 = 7'b0000010,
  INIT_P2 = 7'b0000011,
  IDLE = 7'b0000100,
  ERASE_P1 = 7'b0000101,
  UPDATE_P1 = 7'b0000110,
  DRAW_P1 = 7'b0000111,
  ERASE_P2 = 7'b0001000,
  UPDATE_P2 = 7'b0001001,
  DRAW_P2 = 7'b0001010,
  P1_WINS = 7'b0001011,
  P2_WINS = 7'b0001100,
  DRAW_VL1 = 7'b0001101,
  DRAW_VL2 = 7'b0001110,
  DRAW_VL3 = 7'b0001111,
  DRAW_VL4 = 7'b0010000,
  DRAW_VL5 = 7'b0010001,
  DRAW_VL6 = 7'b0010010,
  DRAW_HL1 = 7'b0010011,
  DRAW_HL2 = 7'b0010100,
  DRAW_HL3 = 7'b0010101,
  DRAW_HL4 = 7'b0010110,
  DRAW_HL5 = 7'b0010111,
  DRAW_HL6 = 7'b0011000;

    reg [3:0]i;
clock(.clock(CLOCK_50), .clk(frame));

always @(posedge CLOCK_50) begin
  grid_initing = 1'b0;
  p1_initing = 1'b0;
  p2_initing = 1'b0;
  bg_colour = 3'b000;
  line_colour = 3'b101;
  p1_colour = 3'b001;
  p2_colour = 3'b100;
  colour = bg_colour;
  x = 8'b00000000;
  y = 8'b00000000;
  i = 0;

  if (~KEY[0]) begin
    state <= RESET_BLACK;
  end /* else if (~KEY[1]) begin
		p1_x = p1_x + 1;
	end else if (~KEY[2]) begin
		p2_x = p2_x + 1;
	end */

  case (state)
    RESET_BLACK: begin
      if (draw_counter < 17'b10000000000000000) begin
        x = draw_counter[7:0];
        y = draw_counter[16:8];
        draw_counter = draw_counter + 1'b1;
      end else begin
        draw_counter = 8'b00000000;
        state <= INIT_GRID;
      end
    end
    INIT_GRID: begin
      vl1_x = 0;
      vl1_y = 0;
      hl1_x = 0; // Top horizontal line x
      hl1_y = 0; // Top horizontal line y
      vl2_x = 22; 
      vl2_y = 0;
      hl2_x = 0;;
      hl2_y = 22;
      vl3_x = 46;
      vl3_y = 0;
      hl3_x = 0;
      hl3_y = 46;
      vl4_x = 70;
      vl4_y = 0;
      hl4_x = 0;
      hl4_y = 70;
      vl5_x = 94;
      vl5_y = 0;
      hl5_x = 0;
      hl5_y = 94;
      vl6_x = 118;
      vl6_y = 0;
      hl6_x = 0;
      hl6_y = 118;
      colour = line_colour;
//      state <= DRAW_VL1;
		state <= INIT_P1;
    end
    DRAW_VL1: begin
      if (draw_counter < 18'd1000000000) begin
        x = vl1_x + draw_counter[9:8];
        y = vl1_y + draw_counter[7:0];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_HL1;
      end
    end
    DRAW_HL1: begin
      if (draw_counter < 18'd1000000000) begin
        x = hl1_x + draw_counter[7:1];
        y = hl1_y + draw_counter[9:8];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_VL2;
      end
    end
    DRAW_VL2: begin
      if (draw_counter < 18'd1000000000) begin
        x = vl2_x + draw_counter[9:8];
        y = vl2_y + draw_counter[7:0];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_HL2;
      end
    end
    DRAW_HL2: begin
      if (draw_counter < 18'd1000000000) begin
        x = hl2_x + draw_counter[7:1];
        y = hl2_y + draw_counter[9:8];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_VL3;
      end
    end
    DRAW_VL3: begin
      if (draw_counter < 18'd1000000000) begin
        x = vl3_x + draw_counter[9:8];
        y = vl3_y + draw_counter[7:0];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_HL3;
      end
    end
    DRAW_HL3: begin
      if (draw_counter < 18'd1000000000) begin
        x = hl3_x + draw_counter[7:1];
        y = hl3_y + draw_counter[9:8];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_VL4;
      end
    end
    DRAW_VL4: begin
      if (draw_counter < 18'd1000000000) begin
        x = vl4_x + draw_counter[9:8];
        y = vl4_y + draw_counter[7:0];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_HL4;
      end
    end
    DRAW_HL4: begin
      if (draw_counter < 18'd1000000000) begin
        x = hl4_x + draw_counter[7:1];
        y = hl4_y + draw_counter[9:8];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_VL5;
      end
    end
    DRAW_VL5: begin
      if (draw_counter < 18'd1000000000) begin
        x = vl5_x + draw_counter[9:8];
        y = vl5_y + draw_counter[7:0];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_HL5;
      end
    end
    DRAW_HL5: begin
      if (draw_counter < 18'd1000000000) begin
        x = hl5_x + draw_counter[7:1];
        y = hl5_y + draw_counter[9:8];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_VL6;
      end
    end
    DRAW_VL6: begin
      if (draw_counter < 18'd1000000000) begin
        x = vl6_x + draw_counter[9:8];
        y = vl6_y + draw_counter[7:0];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_HL6;
      end
    end
    DRAW_HL6: begin
      if (draw_counter < 18'd1000000000) begin
        x = hl6_x + draw_counter[7:1];
        y = hl6_y + draw_counter[9:8];
        draw_counter = draw_counter + 1'b1;
        colour = line_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= ERASE_P1;
      end
    end
    INIT_P1: begin
      if (draw_counter < 6'b100000) begin
        p1_x = 8'd82;
        p1_y = 8'd82;
        x = p1_x + draw_counter[1:0];
        y = p1_y + draw_counter[3:2];
        draw_counter = draw_counter + 1'b1;
        colour = p1_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= INIT_P2;
      end
    end
    INIT_P2: begin
      if (draw_counter < 6'b100000) begin
        p2_x = 8'd106;
        p2_y = 8'd106;
        x = p2_x + draw_counter[1:0];
        y = p2_y + draw_counter[3:2];
        draw_counter = draw_counter + 1'b1;
        colour = p2_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= DRAW_VL1;
      end
    end
    IDLE: begin
      if (frame) begin
        state <= ERASE_P1;
      end
    end
    ERASE_P1: begin
      if (draw_counter < 6'b100000) begin
        x = p1_x + draw_counter[1:0];
        y = p1_y + draw_counter[3:2];
        draw_counter = draw_counter + 1'b1;
        colour = 3'b000;
      end else begin
        draw_counter = 8'b00000000;
        state <= UPDATE_P1;
      end
    end
    UPDATE_P1: begin
      if (x1 == 1) begin
			p1_x = {5'd0, x1};
			p1_x = 11;
		end else begin
			p1_x = {5'd0, x1};
			p1_x = ((p1_x - 1) * 24) + 11;
		end
		if (y1 == 1) begin
			p1_y = {5'd0, y1};
			p1_y = 11;
		end else begin
			p1_y = {5'd0, y1};
			p1_y = ((p1_y - 1) * 24) + 11;
		end
      state <= DRAW_P1;
    end
    DRAW_P1: begin
      if (draw_counter < 6'b100000) begin
        x = p1_x + draw_counter[1:0];
        y = p1_y + draw_counter[3:2];
        draw_counter = draw_counter + 1'b1;
        colour = p1_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= ERASE_P2;
      end
    end
    ERASE_P2: begin
      if (draw_counter < 6'b100000) begin
        x = p2_x + draw_counter[1:0];
        y = p2_y + draw_counter[3:2];
        draw_counter = draw_counter + 1'b1;
        colour = 3'b000;
      end else begin
        draw_counter = 8'b00000000;
        state <= UPDATE_P2;
        //state <= DRAW_VL1;
      end
    end
    UPDATE_P2: begin
		if (x2 == 1) begin
			p2_x = {5'd0, x2};
			p2_x = 11;
		end else begin
			p2_x = {5'd0, x2};
			p2_x = ((p2_x - 1) * 24) + 11;
		end
		if (y2 == 1) begin
			p2_y = {5'd0, y2};
			p2_y = 11;
		end else begin
			p2_y = {5'd0, y2};
			p2_y = ((p2_y - 1) * 24) + 11;
		end
//		p2_x = {5'd0, x2};
//		p2_y = {5'd0, y2};
		if (~KEY[1]) begin
			if (p1_x >= 5) begin
				p1_x = 1;
			end else begin
				p1_x = p1_x + 1;
			end
		end else if (~KEY[2]) begin
			if (p2_x >= 5) begin
				p2_x = 1;
			end else begin
				p2_x = p2_x + 1;
			end
		end
      // TODO: Update p2
      state <= DRAW_P2;
    end
    DRAW_P2: begin
      if (draw_counter < 6'b100000) begin
        x = p2_x + draw_counter[1:0];
        y = p2_y + draw_counter[3:2];
        draw_counter = draw_counter + 1'b1;
        colour = p2_colour;
      end else begin
        draw_counter = 8'b00000000;
        state <= IDLE;
      end
    end
  endcase
end
endmodule
module clock ( //Coconut.jpg
  input clock,
  output clk
);

reg [19:0] frame_counter;
reg frame;
always@(posedge clock)
  begin
    if (frame_counter == 20'b0) begin
      frame_counter = 20'd833332;  // This divisor gives us ~60 frames per second
      frame = 1'b1;
    end else begin
      frame_counter = frame_counter - 1'b1;
      frame = 1'b0;
    end
  end

assign clk = frame;
endmodule
	 
   
	 
//endmodule 
	 