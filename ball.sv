//-------------------------------------------------------------------------
//    scope.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  scope (	input logic [31:0] keycode,
					input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_scope,             // Whether current pixel belongs to scope or background
					output logic [9:0] scope_X_Pos, scope_Y_Pos, scope_Draw_X, scope_Draw_Y
              );
    
    parameter [9:0] scope_X_Center=320;  // Center position on the X axis
    parameter [9:0] scope_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] scope_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] scope_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] scope_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] scope_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] scope_X_Step=20;      // Step size on the X axis
    parameter [9:0] scope_Y_Step=20;      // Step size on the Y axis
    parameter [9:0] scope_Size=60;        // scope size
    
    logic [9:0] scope_X_Motion, scope_Y_Motion;
    logic [9:0] scope_X_Pos_in, scope_X_Motion_in, scope_Y_Pos_in, scope_Y_Motion_in;
    
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - scope_X_Pos;
    assign DistY = DrawY - scope_Y_Pos;
    assign Size = scope_Size;
	 
	 assign w_on = (keycode[31:24] == 8'h1A |
               keycode[23:16] == 8'h1A |
               keycode[15: 8] == 8'h1A |
               keycode[ 7: 0] == 8'h1A);
					
	assign a_on = (keycode[31:24] == 8'h04 |
						keycode[23:16] == 8'h04 |
						keycode[15: 8] == 8'h04 |
						keycode[ 7: 0] == 8'h04);
						
	assign d_on = (keycode[31:24] == 8'h07 |
						keycode[23:16] == 8'h07 |
						keycode[15: 8] == 8'h07 |
						keycode[ 7: 0] == 8'h07);
						
	assign s_on = (keycode[31:24] == 8'h16 |
						keycode[23:16] == 8'h16 |
						keycode[15: 8] == 8'h16 |
						keycode[ 7: 0] == 8'h16);

	assign spacebar_on = (keycode[31:24] == 8'h2c |
								keycode[23:16] == 8'h2c |
								keycode[15: 8] == 8'h2c |
								keycode[ 7: 0] == 8'h2c);
	 
	 
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
    end
    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    // Update scope position and motion
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            scope_X_Pos <= scope_X_Center;
            scope_Y_Pos <= scope_Y_Center;
            //scope_X_Motion <= 10'd0;//10'd0;
           // scope_Y_Motion <= 10'd0;//scope_Y_Step;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            scope_X_Pos <= scope_X_Pos_in;
            scope_Y_Pos <= scope_Y_Pos_in;
            //scope_X_Motion <= scope_X_Motion_in;
            //scope_Y_Motion <= scope_Y_Motion_in;
        end
        // By defualt, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
    begin

	 

	 if(w_on)
	 begin
		 scope_Y_Pos_in = scope_Y_Pos - 10;		
	 end	 	 
	 else if(s_on)
	 begin
		 scope_Y_Pos_in = scope_Y_Pos + 10;		
	 end
	 else
		 scope_Y_Pos_in = scope_Y_Pos;

	 
	 if(a_on)
	 begin
		 scope_X_Pos_in = scope_X_Pos - 10;		
	 end	 
	 else if(d_on)
	 begin
		 scope_X_Pos_in = scope_X_Pos + 10;		
	 end
	 else
		scope_X_Pos_in = scope_X_Pos;

	 

	 


        if ( DistX <= scope_Size & DistX >= 0  & DistY <= scope_Size & DistY >= 0) 
		  begin
            is_scope = 1'b1;
				scope_Draw_X = DrawX - scope_X_Pos;
				scope_Draw_Y = DrawY - scope_Y_Pos;
		  end	
        else
		  begin
            is_scope = 1'b0;
				scope_Draw_X = 1'b0;
				scope_Draw_Y = 1'b0;
		  end
        

        
    end
    
endmodule

module keycode_reader(
	input logic [31:0] keycode,
	output logic w_on, a_on, s_on, d_on, spacebar_on
);

assign w_on = (keycode[31:24] == 8'h1A |
               keycode[23:16] == 8'h1A |
               keycode[15: 8] == 8'h1A |
               keycode[ 7: 0] == 8'h1A);
					
assign a_on = (keycode[31:24] == 8'h04 |
					keycode[23:16] == 8'h04 |
					keycode[15: 8] == 8'h04 |
					keycode[ 7: 0] == 8'h04);
					
assign d_on = (keycode[31:24] == 8'h07 |
					keycode[23:16] == 8'h07 |
					keycode[15: 8] == 8'h07 |
					keycode[ 7: 0] == 8'h07);
					
assign s_on = (keycode[31:24] == 8'h16 |
					keycode[23:16] == 8'h16 |
					keycode[15: 8] == 8'h16 |
					keycode[ 7: 0] == 8'h16);

assign spacebar_on = (keycode[31:24] == 8'h2c |
							keycode[23:16] == 8'h2c |
							keycode[15: 8] == 8'h2c |
							keycode[ 7: 0] == 8'h2c);

endmodule
