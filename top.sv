module top(
    input clk,
    output Hsynq,
    output Vsynq,
    output logic [3:0] Red,
    output logic [3:0] Green,
    output logic [3:0] Blue
);

wire clk_25M;
wire enable_V_Counter;
wire[15:0] H_Count_Value;
wire[15:0] V_Count_Value;

clock_divider VGA_Clock_gen (clk, clk_25M);
horizontal_counter VGA_Horiz (clk_25M, enable_V_Counter, H_Count_Value);
vertical_counter VGA_Verti (clk_25M, enable_V_Counter, V_Count_Value);

assign Hsynq = (H_Count_Value < 96) ? 1'b1:1'b0;
assign Vsynq = (V_Count_Value < 2) ? 1'b1:1'b0;

    localparam ROTATE_Z = 0;
    localparam ROTATE_Y = 1;
    localparam ROTATE_X = 2;
    localparam ROTATE_ALL = 3;
   

    localparam SIZE = 10;     // Has to be even and no bigger than 480
    localparam VERTEX_POINT = 2;
    localparam THETA = 45;


    logic [15:0] PointsDrawLine[11:0][1:0];
    logic signed [15:0] VertexBuffer[8][3];
    logic signed [15:0] RotatedVertexBuffer[8][3];
    logic FrameBuffer[SIZE:0][SIZE:0];


     RotationOfCube #(.ROTATE_AXIS(ROTATE_ALL), .THETA(THETA), .SIZE(SIZE),
     .VERTEX_POINT(VERTEX_POINT)) 
     test(PointsDrawLine, VertexBuffer, RotatedVertexBuffer, FrameBuffer);
        


    assign Red = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value > 34)  
                  && (FrameBuffer[H_Count_Value % (SIZE+1)][V_Count_Value % (SIZE+1)])
                  ? 4'hF:4'h0;  //Black = hx0, White = hxF 
    
    assign Green = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value > 34) 
                    && (FrameBuffer[H_Count_Value % (SIZE+1)][V_Count_Value % (SIZE+1)])
                    ? 4'hF:4'h0;
    
    assign Blue = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value > 34)  
                   && (FrameBuffer[H_Count_Value % (SIZE+1)][V_Count_Value % (SIZE+1)])
                   ? 4'hF:4'h0;


endmodule
