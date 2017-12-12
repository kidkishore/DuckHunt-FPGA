


module  randomDuck (
					input logic [31:0] keycode,
					input logic [4:0] randomNo,
					input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk, is_ball,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY, Ball_X_Pos, Ball_Y_Pos,
               output logic  is_duck,             // Whether current pixel belongs to ball or background
					output logic  [9:0] Duck_Draw_X, Duck_Draw_Y,
					output logic [7:0] score,
					output logic [3:0] lives

              );
    

	 

	  parameter [9:0]Duck_X_Center = 400;
	  parameter [9:0] Duck_Y_Center=450;  


    parameter [9:0] Duck_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Duck_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Duck_X_Step=1;      // Step size on the X axis
    parameter [9:0] Duck_Y_Step=-1;      // Step size on the Y axis
    parameter [9:0] Duck_SizeX=80;        // Duck sizeX
	 parameter [9:0] Duck_SizeY=64;        // Duck sizeY
    
    logic [9:0] Duck_X_Pos, Duck_X_Motion, Duck_Y_Pos;
	 logic [9:0] Duck_Y_Motion = -1;
    logic [9:0] Duck_X_Pos_in, Duck_X_Motion_in, Duck_Y_Pos_in, Duck_Y_Motion_in;
	 
	 
    
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, SizeX, SizeY;
    assign DistX = DrawX - Duck_X_Pos;
    assign DistY = DrawY - Duck_Y_Pos;
    assign SizeX = Duck_SizeX;
	 assign SizeY = Duck_SizeY;
	 assign spacebar_on = (keycode[31:24] == 8'h2c |
								keycode[23:16] == 8'h2c |
								keycode[15: 8] == 8'h2c |
								keycode[ 7: 0] == 8'h2c);
	
	 assign escape_on = (keycode[31:24] == 8'h29 |
								keycode[23:16] == 8'h29 |
								keycode[15: 8] == 8'h29 |
								keycode[ 7: 0] == 8'h29);
	 
	 
	 
	 
	 
	 logic [8:0] xmin1 = 50;
	 logic [8:0] xmin2 = 150;
	 logic [8:0] xmin3 = 250;
	 
    logic [8:0] xmax1 = 350;
	 logic [8:0] xmax2 = 450;
	 logic [8:0] xmax3 = 550;

	 logic [8:0] count_min = 1;
	 logic [8:0] count_max = 1;
    logic [8:0] count_min_in;
	 logic [8:0] count_max_in;
	 logic [8:0] Duck_X_Min = 100;
	 logic [8:0] Duck_X_Max = 350;

	 //logic [8:0] Duck_X_Min_in, Duck_X_Max_in;
    
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
        if (escape_on | lives == 0)
        begin
            Duck_X_Pos <= 320;
            Duck_Y_Pos <= 429;
				Duck_X_Motion <= 1;
            Duck_Y_Motion <= -1;
				count_min <= 1;
				count_max <= 1;
				score <= 0;
				lives <= 5;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Duck_X_Pos <= Duck_X_Pos_in;
            Duck_Y_Pos <= Duck_Y_Pos_in;
				Duck_X_Motion <= Duck_X_Motion_in;
            Duck_Y_Motion <= Duck_Y_Motion_in;
				count_min <= count_min_in;
				count_max <= count_max_in;
				
			if(Duck_Y_Pos > 468 & Duck_Y_Motion > 0)
				score <= score+1'b1;
				
				
			if(Duck_Y_Pos == 0)	
			begin
				lives <= lives-1;
				score <= score-1'b1;
			end
				//Duck_X_Min <= Duck_X_Min_in;
				//Duck_X_Max <= Duck_X_Max_in;
				//data <= data_next;
        end
        // By defualt, keep the register values.
    end
	 

    // You need to modify always_comb block.
    always_comb
    begin
				
			count_min_in = count_min;
			count_max_in = count_max;
			//Duck_X_Min_in = Duck_X_Min;
			//Duck_X_Max_in = Duck_X_Max;


			
			//SET THE DUCKS WALLS TO DETERMINE MOTION
			if(count_min==1)
				Duck_X_Min = 100;		
			else if(count_min==2)
				Duck_X_Min = 200;		
		   else
				Duck_X_Min = 300;
	

			if(count_max==1)
				Duck_X_Max = 200;	
			else if(count_max==2)
				Duck_X_Max = 360;	
			else if(count_max==3)
				Duck_X_Max = 600;	
		   else
				Duck_X_Max = 420;

			

	
			//SET DEFAULT POSITION AND MOTION VALUES
			
			Duck_X_Pos_in = Duck_X_Pos + Duck_X_Motion;
         Duck_Y_Pos_in = Duck_Y_Pos + Duck_Y_Motion;
			
			Duck_X_Motion_in = Duck_X_Motion;
         Duck_Y_Motion_in = Duck_Y_Motion;
			
			
			
        

			//DETERMINE COLLISION WITH TOP AND BOTTOM OF SCREEN
			
			if (Duck_Y_Pos + Duck_SizeY <= Duck_Y_Min  )  // duck as the top, go back to the bottom
			begin
            Duck_Y_Pos_in = 468;		

			end
			else if (Duck_Y_Pos > 468 & Duck_Y_Motion > 0 )  // duck is at the bottom and is moving downward, stop moving and move to different location
			begin
            Duck_Y_Pos_in = 468;
				

				
				
				if(score>=12 & score >=0)
					Duck_Y_Motion_in = -4;
				else if(score>=8 & score >=0)
					Duck_Y_Motion_in = -3;
				else if(score>=4 & score >=0)
					Duck_Y_Motion_in = -2;	
				else 
					Duck_Y_Motion_in = -1;			


	
			   if(count_min<3)
						count_min_in = count_min+1;
				else	
						count_min_in = 1;
						
			   if(count_min<4)
						count_min_in = count_min+1;
				else	
						count_min_in = 1;
					
					
				if(count_max==1)
				begin
				   count_max_in=2;
					Duck_X_Pos_in = 360;
				end
			   else if(count_max==2)	
				begin
					count_max_in=3;
		         Duck_X_Pos_in = 600;			
				end
				else if(count_max==3)	
				begin
					count_max_in=4;
		         Duck_X_Pos_in = 420;			
				end
				else 
				begin
					count_max_in=1;
		         Duck_X_Pos_in = 200;			
				end
				


				
		   end
			
				//CALCULATE MOTION DEPENDING ON BOUNCING OF WALLS

			if( Duck_X_Pos >= Duck_X_Max )  // duck right wall bounce
			begin  	
					if(score>=12)
						Duck_X_Motion_in = -4;
					else if(score>=8)
						Duck_X_Motion_in = -3;
					else if(score>=4)
						Duck_X_Motion_in = -2;	
					else 
						Duck_X_Motion_in = -1;	
			end
			else if ( Duck_X_Pos <= Duck_X_Min )  // duck left wall bounce
			begin
					if(score>=12)
						Duck_X_Motion_in = 4;
					else if(score>=8)
						Duck_X_Motion_in = 3;
					else if(score>=4)
						Duck_X_Motion_in = 2;	
					else 
						Duck_X_Motion_in = 1;
			end
			
				
				
		//COLLISION DETECTION WITH TARGET	
				
		if(spacebar_on & (Ball_X_Pos + 30 > Duck_X_Pos) & (Ball_X_Pos+30 < Duck_X_Pos + Duck_SizeX) & (Ball_Y_Pos+30 > Duck_Y_Pos) & (Ball_Y_Pos+30 < Duck_Y_Pos + Duck_SizeY))
		begin
			Duck_X_Motion_in=1'b0;
			Duck_Y_Motion_in=12;

		end
		
		
	
		  //ACCESSING THE DUCK ARRAY FOR DRAWING
		
		  if ( DistX <= SizeX & DistX >= 0  & DistY <= SizeY & DistY >= 0) 
		  begin
            is_duck = 1'b1;
				Duck_Draw_X = DrawX - Duck_X_Pos;
				Duck_Draw_Y = DrawY - Duck_Y_Pos;
		  end	
        else
		  begin
            is_duck = 1'b0;
				Duck_Draw_X = 1'b0;
				Duck_Draw_Y = 1'b0;
		  end
        
			
//		   data_next = data;
//			repeat(9) 
//			begin
//				data_next = {(data_next[9]^data_next[1]), data_next[9:1]};
//			end
//	 
//	
//        if(counter > 500 )  // Ball is at the bottom edge, BOUNCE!
//		  begin
//            Duck_X_Pos_in = data;
//				counter=0;
//				data_next = 9'b011101110;
//		  end
//		  
//		  if(counter>200)
//			Duck_X_Pos_in = 400;
//		  
//		  
//		  if(counter<200)
//			Duck_X_Pos_in = 200;
		  
			
        
        

	 
	         // Be careful when using comparators with "logic" datatype because compiler treats 
        //   both sides of the operator UNSIGNED numbers. (unless with further type casting)
        // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
        // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.

        
//	 
//    if(w_on & a_on)
//	 begin
//	 	 Ball_X_Pos_in = Ball_X_Pos - 1'b1;
//		 Ball_Y_Pos_in = Ball_Y_Pos - 1'b1;		
//	 end
//	 else if(w_on & d_on)
//	 begin
//	 	 Ball_X_Pos_in = Ball_X_Pos + 1'b1;
//		 Ball_Y_Pos_in = Ball_Y_Pos - 1'b1;		
//	 end
//	 else if(s_on & d_on)
//	 begin
//	 	 Ball_X_Pos_in = Ball_X_Pos + 1'b1;
//		 Ball_Y_Pos_in = Ball_Y_Pos + 1'b1;		
//	 end
//	 else if(s_on & a_on)
//	 begin
//	 	 Ball_X_Pos_in = Ball_X_Pos - 1'b1;
//		 Ball_Y_Pos_in = Ball_Y_Pos + 1'b1;		
//	 end
//	 else if(w_on)
//	 begin
//		 Ball_Y_Pos_in = Ball_Y_Pos - 1'b1;		
//	 end	 
//	 else if(s_on)
//	 begin
//		 Ball_Y_Pos_in = Ball_Y_Pos + 1'b1;		
//	 end
//	 else if(a_on)
//	 begin
//		 Ball_X_Pos_in = Ball_X_Pos - 1'b1;		
//	 end	 
//	 else if(d_on)
//	 begin
//		 Ball_X_Pos_in = Ball_X_Pos + 1'b1;		
//	 end
//	 


		
	


	//		unique case(keycode[15:0])
//				16'h001A :  // w (up)
//					begin
//					  //Ball_X_Motion_in = 10'd0; //clear
//					  //Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // go UP			
//                 Ball_X_Pos_in = Ball_X_Pos;
//                 Ball_Y_Pos_in = Ball_Y_Pos - 1'b1; 
//					end
//				16'h0016:  // s (down)
//				begin
//	
//				  Ball_X_Pos_in = Ball_X_Pos;
//				  Ball_Y_Pos_in = Ball_Y_Pos + 1'b1; 
//				end
//				16'h0004:  // a (left)
//				begin 
//				  
//				  Ball_X_Pos_in = Ball_X_Pos - 1'b1;
//				  Ball_Y_Pos_in = Ball_Y_Pos;
//
//				end
//				16'h0007:  // d (right)
//				begin
//				  
//			     Ball_X_Pos_in = Ball_X_Pos + 1'b1;
//			     Ball_Y_Pos_in = Ball_Y_Pos;	  
//				end
//				16'h041A :  // (up/left)
//					begin		
//                 Ball_X_Pos_in = Ball_X_Pos - 1'b1;
//                 Ball_Y_Pos_in = Ball_Y_Pos - 1'b1; 
//					end
//				16'h1A04:  // (left/up)
//				begin
//	
//				  Ball_X_Pos_in = Ball_X_Pos - 1'b1;
//				  Ball_Y_Pos_in = Ball_Y_Pos - 1'b1; 
//				end
//				16'h0416:  // (down/left)
//				begin 
//				  
//				  Ball_X_Pos_in = Ball_X_Pos - 1'b1;
//				  Ball_Y_Pos_in = Ball_Y_Pos + 1'b1;
//
//				end
//				16'h1604:  // (left/down)
//				begin
//			     Ball_X_Pos_in = Ball_X_Pos - 1'b1;
//			     Ball_Y_Pos_in = Ball_Y_Pos + 1'b1;	  
//				end
//				16'h071A :  //  (up/right)
//					begin			
//                 Ball_X_Pos_in = Ball_X_Pos + 1'b1;
//                 Ball_Y_Pos_in = Ball_Y_Pos - 1'b1; 
//					end
//				16'h1A07:  //  (right/up)
//				begin
//				  Ball_X_Pos_in = Ball_X_Pos + 1'b1;
//				  Ball_Y_Pos_in = Ball_Y_Pos - 1'b1; 
//				end
//				16'h0716:  //  (down/right)
//				begin 		  
//				  Ball_X_Pos_in = Ball_X_Pos + 1'b1;
//				  Ball_Y_Pos_in = Ball_Y_Pos + 1'b1;
//				end
//				16'h1607:  //  (down/right)
//				begin
//			     Ball_X_Pos_in = Ball_X_Pos + 1'b1;
//			     Ball_Y_Pos_in = Ball_Y_Pos + 1'b1;	  
//				end
//				default:
//				begin
//	           Ball_X_Pos_in = Ball_X_Pos;
//			     Ball_Y_Pos_in = Ball_Y_Pos;				 
//				end
					
	//	  endcase
		  
		  
		  
			
        
        // Be careful when using comparators with "logic" datatype because compiler treats 
        //   both sides of the operator UNSIGNED numbers. (unless with further type casting)
        // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
        // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
//        if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Size;  // 2's complement.  
//        else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
//            Ball_Y_Pos_in = Ball_Y_Min + Ball_Size;
//        
//        // TODO: Add other boundary conditions and handle keypress here.
//		  if( Ball_X_Pos + Ball_Size >= Ball_X_Max )  // Ball is at the bottom edge, BOUNCE!
//            Ball_X_Pos_in = Ball_X_Pos + Ball_Size;  // 2's complement.  
//        else if ( Ball_X_Pos <= Ball_X_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
//            Ball_X_Pos_in = Ball_X_Min + Ball_Size;
        
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #2/2:
          Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
          Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
          What is the difference between writing
            "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
            "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
          How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
          Give an answer in your Post-Lab.
    **************************************************************************************/
        
        // Compute whether the pixel corresponds to ball or background

        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
        
    end
    
endmodule


