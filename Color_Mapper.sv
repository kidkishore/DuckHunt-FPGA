//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_scope, is_duck,           // Whether current pixel belongs to scope 
                                                              //   or background (computed in scope.sv)
                       input        [9:0] DrawX, DrawY, Duck_Draw_X, Duck_Draw_Y, scope_Draw_X, scope_Draw_Y,      // Current pixel coordinates
							  input logic [3:0] lives,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 logic[3:0] back_Out;
	 logic[3:0] duck_Out;
	 logic[3:0] scope_Out;
	 logic[3:0] grass_Out;
	 logic[3:0] lives_Out;
	 logic [9:0] Lives_Draw_X, Lives_Draw_Y;
	 
	 int DistLivesX, DistLivesY;
    assign DistLivesX = DrawX - 20;
    assign DistLivesY = DrawY - 430;

	 
	 frameROM frame(
		//.read_address(DrawX+{DrawY[9:0],9'b0}*5/4),
		.read_address(int'(DrawX/2)+int'(DrawY/2)*320),
		.data_Out(back_Out)
);

grassROM grass(
		.read_address(int'(DrawX/2)+int'(DrawY/2)*320),
		.data_Out(grass_Out)
);

	 duckROM theDuck(
		.read_address(Duck_Draw_X + Duck_Draw_Y*80),
		.data_Out(duck_Out)
);

scopeROM thescope(
		.read_address(scope_Draw_X + scope_Draw_Y*60),
		.data_Out(scope_Out)
);

livesROM thelives(
		.read_address((DrawX - 20) + (DrawY - 430)*210),
		.data_Out(lives_Out)
);
    
    // Assign color based on is_scope signal
    always_comb
    begin
		  if (DistLivesX <= (55 + 31*lives) & DistLivesX >= 0  & DistLivesY <= 27 & DistLivesY >= 0 & lives_Out!=0) 
        begin
            unique case(lives_Out)
						 4'd1:begin//black
								  Red = 8'h0;
								  Green = 8'h0;
								  Blue = 8'h0;
								 end
						 4'd2:begin//yellow
								  Red = 8'hFF;
								  Green = 8'hFF;
								  Blue = 8'h00;
								 end
					endcase
        end
        else if (is_scope == 1'b1 & scope_Out!=0) 
        begin
            // red scope
            Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
        end
		  else if(grass_Out!=0)
		  begin
			  unique case(grass_Out)
						 4'd1:begin//white
								  Red = 8'h0;
								  Green = 8'h0;
								  Blue = 8'h0;
								 end
						 4'd2:begin//black
								  Red = 8'hFF;
								  Green = 8'hFF;
								  Blue = 8'hFF;
								 end
						4'd3:begin//blue
								  Red = 8'h0a;
								  Green = 8'hcf;
								  Blue = 8'h2fc;
								 end
						 4'd4:begin//light green
								  Red = 8'h8c;
								  Green = 8'hde;
								  Blue = 8'd03;
								 end
						4'd5:begin//dark green
								  Red = 8'h05;
								  Green = 8'h34;
								  Blue = 8'h04;
								 end
						4'd6:begin//brown
								  Red = 8'hbe;
								  Green = 8'h56;
								  Blue = 8'h01;		  
								 end
						4'd7:begin//dark brown
								  Red = 8'h7e;
								  Green = 8'h0f;
								  Blue = 8'h5;		  
								 end
						endcase
		  
				
		  end
        else if(is_duck == 1'b1 & duck_Out!=0) 
		  begin
		      unique case(duck_Out)
                4'd1:begin//white
							  Red = 8'h0;
                       Green = 8'h0;
                       Blue = 8'h0;
                      end
                4'd2:begin//black
							  Red = 8'hFF;
                       Green = 8'hFF;
                       Blue = 8'hFF;
                      end
					4'd3:begin//yellow
					        Red = 8'd241;
                       Green = 8'd196;
                       Blue = 8'd15;
                      end
                4'd4:begin//orange
                       Red = 8'd230;
                       Green = 8'd126;
                       Blue = 8'd34;
                      end
				   4'd5:begin//green
                       Red = 8'd7;
                       Green = 8'd88;
                       Blue = 8'd11;
                      end
				   4'd6:begin//grey
					        Red = 8'h114;
                       Green = 8'h119;
                       Blue = 8'h115;		  
                      end
					endcase
		  end
		  else
        begin
            // Background with nice color gradient
            //Red = 8'h3f; 
            //Green = 8'h00;
            //Blue = 8'h7f - {1'b0, DrawX[9:3]};
				
				unique case(back_Out)
						 4'd1:begin//white
								  Red = 8'h0;
								  Green = 8'h0;
								  Blue = 8'h0;
								 end
						 4'd2:begin//black
								  Red = 8'hFF;
								  Green = 8'hFF;
								  Blue = 8'hFF;
								 end
						4'd3:begin//blue
								  Red = 8'h0a;
								  Green = 8'hcf;
								  Blue = 8'h2fc;
								 end
						 4'd4:begin//light green
								  Red = 8'h8c;
								  Green = 8'hde;
								  Blue = 8'd03;
								 end
						4'd5:begin//dark green
								  Red = 8'h05;
								  Green = 8'h34;
								  Blue = 8'h04;
								 end
						4'd6:begin//brown
								  Red = 8'hbe;
								  Green = 8'h56;
								  Blue = 8'h01;		  
								 end
						4'd7:begin//dark brown
								  Red = 8'h7e;
								  Green = 8'h0f;
								  Blue = 8'h5;		  
								 end
						endcase
					
					
					
					
	
				
        end
    end 
    
endmodule
