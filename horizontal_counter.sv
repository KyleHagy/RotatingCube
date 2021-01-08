module horizontal_counter #(parameter H_MAX = 0)(

    input clk_25MHz,
    output logic enable_V_Counter = 0, 
    output logic [15:0] H_Count_Value =0
);
    
    always@ (posedge clk_25MHz)begin 
        if(H_Count_Value < H_MAX) begin  
        H_Count_Value <= H_Count_Value + 1;
        enable_V_Counter <= 0;
        end
        else begin
            H_Count_Value <= 0;
            enable_V_Counter <= 1;
        end 
    end 

endmodule