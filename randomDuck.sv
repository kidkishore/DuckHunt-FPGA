


module  randomDuck (
					input logic [31:0] keycode,
					input logic [4:0] randomNo,
					input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk, is_ball,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY, Ball_X_Pos, Ball_Y_Pos,
               output logic  is_duck,             // Whether current pixel belongs to ball or background
					output logic  [9:0] Duck_Draw_X, Duck_Draw_Y
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
	 logic [8:0] Duck_X_Min = 50;
	 logic [8:0] Duck_X_Max = 350;
	 logic [8:0] Duck_X_Min_in, Duck_X_Max_in;
    
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
            Duck_X_Pos <= 500;
            Duck_Y_Pos <= Duck_Y_Center;
            //Ball_X_Motion <= 10'd0;//10'd0;
           // Ball_Y_Motion <= 10'd0;//Ball_Y_Step;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Duck_X_Pos <= Duck_X_Pos_in;
            Duck_Y_Pos <= Duck_Y_Pos_in;
				Duck_X_Motion <= Duck_X_Motion_in;
            Duck_Y_Motion <= Duck_Y_Motion_in;
            count_min <= count_min_in;
			   count_max <= count_max_in;
				Duck_X_Min <= Duck_X_Min_in;
				Duck_X_Max <= Duck_X_Max_in;
				//data <= data_next;
        end
        // By defualt, keep the register values.
    end
	 

    // You need to modify always_comb block.
    always_comb
    begin
				
	      
			
			count_min_in = count_min;
			count_max_in = count_max;
			Duck_X_Min_in = Duck_X_Min;
			Duck_X_Max_in = Duck_X_Max;
			
			//SET THE DUCKS WALLS TO DETERMINE MOTION
			if(count_min==1)
				Duck_X_Min_in = xmin1;
				
			if(count_min==2)
				Duck_X_Min_in = xmin2;
				
		   if(count_min==3)
				Duck_X_Min_in = xmin3;
	

			if(count_max==1)
				Duck_X_Max_in = xmax1;
				
			if(count_max==2)
				Duck_X_Max_in = xmax2;
				
		   if(count_max==3) 
				Duck_X_Max_in = xmax3;

			

	
			//SET DEFAULT POSITION AND MOTION VALUES
			
			Duck_X_Pos_in = Duck_X_Pos + Duck_X_Motion;
         Duck_Y_Pos_in = Duck_Y_Pos + Duck_Y_Motion;
			
			Duck_X_Motion_in = Duck_X_Motion;
         Duck_Y_Motion_in = Duck_Y_Motion;
			
			
			
				//CALCULATE MOTION DEPENDING ON BOUNCING OF WALLS
        

			//DETERMINE COLLISION WITH TOP AND BOTTOM OF SCREEN
			
			if (Duck_Y_Pos + Duck_SizeY <= Duck_Y_Min  )  // duck as the top, go back to the bottom
            Duck_Y_Pos_in = 469;
				
			if (Duck_Y_Pos >= Duck_Y_Max & Duck_Y_Motion > 0 )  // duck is at the bottom and is moving downward, stop moving and move to different location
			begin
            Duck_Y_Pos_in = 469;
				Duck_Y_Motion_in = -1;
				

					
			   if(count_min==1)
				   count_min_in=2;
					
			   if(count_min==2)		
					count_min_in=3;
					
				if(count_min==3)		
					count_min_in=1;
					
					
				if(count_max==1)
				   count_max_in=2;
					
			   if(count_max==2)		
					count_max_in=3;	
					
				if(count_max==3)		
					count_max_in=1;
					
	
				
		   end
			

			if( Duck_X_Pos >= Duck_X_Max )  // duck right wall bounce
					Duck_X_Motion_in = -1;  // 2's complement.  
			else if ( Duck_X_Pos <= Duck_X_Min )  // duck left wall bounce
					Duck_X_Motion_in = 1;
			
				
				
		//COLLISION DETECTION WITH TARGET	
				
		if(spacebar_on & (Ball_X_Pos > Duck_X_Pos) & (Ball_X_Pos < Duck_X_Pos + Duck_SizeX) & (Ball_Y_Pos > Duck_Y_Pos) & (Ball_Y_Pos < Duck_Y_Pos + Duck_SizeY))
		begin
			Duck_X_Motion_in=1'b0;
			Duck_Y_Motion_in=20;
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


