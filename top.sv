`timescale 1ns / 1ps

module top(
    input clk,                  // 100 MHz clock
    output Hsync,               // horizontal sync
    output Vsync,               // vertical sync
    output logic [3:0] Red,     // 4-bit VGA red
    output logic [3:0] Green,   // 4-bit VGA green
    output logic [3:0] Blue     // 4-bit VGA blue
);

    logic clk_25M;
    logic enable_V_Counter;
    logic [15:0] H_Count_Value;
    logic [15:0] V_Count_Value;

    // constant declarations for VGA sync parameters
	localparam H_DISPLAY       = 640; // horizontal display area
	localparam H_L_BORDER      =  48; // horizontal Back Porch
	localparam H_R_BORDER      =  16; // horizontal Front Porch 
	localparam H_RETRACE       =  96; // horizontal Sync Width
	localparam H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE - 1; //799
	localparam START_H_VIDEO   = H_L_BORDER + H_RETRACE;                              //144
	localparam END_H_VIDEO     = H_DISPLAY + H_L_BORDER + H_RETRACE;                  //784
    
	localparam V_DISPLAY       = 480; // vertical display area
    localparam V_T_BORDER      =  33; // vertical Back Porch
	localparam V_B_BORDER      =  10; // vertical Front Porch 
	localparam V_RETRACE       =   2; // vertical Sync Width
	localparam V_MAX           = V_DISPLAY + V_B_BORDER + V_T_BORDER + V_RETRACE - 1; //525
	localparam START_V_VIDEO   = V_T_BORDER + V_RETRACE;                              //35
	localparam END_V_VIDEO     = V_DISPLAY + V_T_BORDER + V_RETRACE;                  //515


    // generate pixel clock
    clock_divider VGA_Clock_gen (clk, clk_25M); 
    
    // keep track of pixel cordinate
    horizontal_counter  #(.H_MAX(H_MAX)) VGA_Horiz (clk_25M, enable_V_Counter, H_Count_Value);
    vertical_counter #(.V_MAX(V_MAX)) VGA_Verti (clk_25M, enable_V_Counter, V_Count_Value);
    
    // keep track of vsync and hsync signal states
    assign Hsync = (H_Count_Value < H_RETRACE) ? 1'b1:1'b0;
    assign Vsync = (V_Count_Value < V_RETRACE) ? 1'b1:1'b0;
    
    ////END OF VGA////

    ////START OF CUBE AND ROTATION////
    
    //parameters for type of cube
    localparam SIZE = 120;     // Has to be even and no bigger than 480
    localparam VERTEX_POINT = 40;
    localparam THETA = 30;

    //WHAT TYPE OF ROTATION
    localparam ROTATE_Z = 0;
    localparam ROTATE_Y = 1;
    localparam ROTATE_X = 2;
    localparam ROTATE_ALL = 3;

    logic [15:0] PointsDrawLine[11:0][1:0];
    logic signed [15:0] VertexBuffer[8][3];
    logic signed [15:0] RotatedVertexBuffer[8][3];
    logic FrameBuffer[SIZE:0][SIZE:0];


    logic [9:0] counter;
    logic [9:0] counter_next;

// ---Counter to change theta every frame---
//    always @(*) begin
//        if(H_Count_Value == 798 && V_Count_Value == 523)
//       counter_next = counter + 1;
//    end

     // Draws pixels and lines of cube
     RotationOfCube #(.ROTATE_AXIS(ROTATE_ALL), .THETA(THETA), .SIZE(SIZE),
     .VERTEX_POINT(VERTEX_POINT)) 
     test(PointsDrawLine, VertexBuffer, RotatedVertexBuffer, FrameBuffer);
        
      
// ---Counter to change theta every frame---
//    always @(posedge clk_25M) begin
//       if (counter > 3)
//          counter <= 4'b0;
//       else
//          counter <= counter_next;
//    end
   
   
    // video only on when pixels are in both horizontal and vertical display region
    assign Red = (H_Count_Value < END_H_VIDEO && H_Count_Value >= START_H_VIDEO && V_Count_Value < END_V_VIDEO && V_Count_Value >= START_V_VIDEO)  
                  && (FrameBuffer[H_Count_Value % (SIZE+1)][V_Count_Value % (SIZE+1)])
                  //&&(counter == 2)
                  ? 4'hF:4'h0;  //Black = hx0, White = hxF 
    
    assign Green = (H_Count_Value < END_H_VIDEO && H_Count_Value >= START_H_VIDEO && V_Count_Value < END_V_VIDEO && V_Count_Value >= START_V_VIDEO)
                    && (FrameBuffer[H_Count_Value % (SIZE+1)][V_Count_Value % (SIZE+1)])
                    //&&(counter == 2)
                    ? 4'hF:4'h0;
    
    assign Blue = (H_Count_Value < END_H_VIDEO && H_Count_Value >= START_H_VIDEO && V_Count_Value < END_V_VIDEO && V_Count_Value >= START_V_VIDEO)
                   && (FrameBuffer[H_Count_Value % (SIZE+1)][V_Count_Value % (SIZE+1)])
                   //&&(counter == 2)
                   ? 4'hF:4'h0;


endmodule


