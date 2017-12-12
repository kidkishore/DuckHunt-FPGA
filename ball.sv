//-------------------------------------------------------------------------
//    Ball.sv                                                            --
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


module  ball (	input logic [31:0] keycode,
					input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_ball,             // Whether current pixel belongs to ball or background
					output logic [9:0] Ball_X_Pos, Ball_Y_Pos, Ball_Draw_X, Ball_Draw_Y
              );
    
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=20;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=20;      // Step size on the Y axis
    parameter [9:0] Ball_Size=60;        // Ball size
    
    logic [9:0] Ball_X_Motion, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
    
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
	 
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
    // Update ball position and motion
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            //Ball_X_Motion <= 10'd0;//10'd0;
           // Ball_Y_Motion <= 10'd0;//Ball_Y_Step;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            //Ball_X_Motion <= Ball_X_Motion_in;
            //Ball_Y_Motion <= Ball_Y_Motion_in;
        end
        // By defualt, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
    begin

	 

	 if(w_on)
	 begin
		 Ball_Y_Pos_in = Ball_Y_Pos - 10;		
	 end	 	 
	 else if(s_on)
	 begin
		 Ball_Y_Pos_in = Ball_Y_Pos + 10;		
	 end
	 else
		 Ball_Y_Pos_in = Ball_Y_Pos;

	 
	 if(a_on)
	 begin
		 Ball_X_Pos_in = Ball_X_Pos - 10;		
	 end	 
	 else if(d_on)
	 begin
		 Ball_X_Pos_in = Ball_X_Pos + 10;		
	 end
	 else
		Ball_X_Pos_in = Ball_X_Pos;

	 

	 


        if ( DistX <= Ball_Size & DistX >= 0  & DistY <= Ball_Size & DistY >= 0) 
		  begin
            is_ball = 1'b1;
				Ball_Draw_X = DrawX - Ball_X_Pos;
				Ball_Draw_Y = DrawY - Ball_Y_Pos;
		  end	
        else
		  begin
            is_ball = 1'b0;
				Ball_Draw_X = 1'b0;
				Ball_Draw_Y = 1'b0;
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
