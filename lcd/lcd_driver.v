module lcd(
    input disp_clk,
    input disp_async_rst,
	 input rst,
    output disp_rs,
    output disp_rw,
    output disp_en,
    output display_on,
    output [7:0]disp_data
);

reg disp_clk_out;
reg [15:0] clk_count;

reg [255:0]name = "Laser Lift      BattleBoard     ";

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
			 
reg pressed;			 

always @(negedge disp_async_rst) begin
	     case (S) 
		      prog:
				   NS = start;
		      start:
				   NS = p1Move;
				p1Move:
				   NS = p1Attack;
				p1Attack:
				   NS = p1Aim;
				p1Aim:
				   NS = p2Move;
				p2Move:
				   NS = p2Attack;
				p2Attack:
				   NS = p2Aim;
				p2Aim:
				   NS = p1Move;
				
				
			endcase
		
end

always@(posedge disp_clk or negedge rst) begin
    if (rst == 1'b0) 
	     S <= start;
	 else 
	     S <= NS;
end 

always @(posedge disp_clk or negedge rst) begin
    if (rst == 1'b0) begin
        name = "";
	 end else begin 
        case(S)
		      prog:
				  name = "Loading                         ";
		      start:
				  name = "Laser Lift      BattleBoard     ";
				p1Move:
				  name = "Player 1 move   Select moves    ";
				p1Attack:
				  name = "Player 1 attack Select Attack   ";
				p1Aim:
				  name = "Player 1 aim    Select Aim      ";
				p2Move:
				  name = "Player 2 move                   ";
				p2Attack:
				  name = "Player 2 Attack                 ";
				p2Aim:
				  name = "Player 2 Aim                    ";
		  endcase
	end
end
		  

	 


assign display_on = 1'b1;

always @(posedge disp_clk or negedge disp_async_rst)
begin
	if (disp_async_rst == 1'b0)
		begin
			clk_count = 16'd0;
			disp_clk_out = 1'b0;
		end
	else
		begin
		    clk_count = clk_count + 1'b1;
		
		if (clk_count == 16'd32_768)
			begin
				clk_count = 16'd0;
				disp_clk_out = ~disp_clk_out;
			end
			
		end
end

lcd_control lcd(disp_clk_out, disp_async_rst, name, disp_rs, disp_rw, disp_en, disp_data);
 
endmodule 