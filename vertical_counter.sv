module vertical_counter #(parameter V_MAX = 0)(

    input clk_25MHz,
    output enable_V_Counter, 
    output logic [15:0] V_Count_Value = 0
);

    always@ (posedge clk_25MHz)begin 
        if(enable_V_Counter == 1'b1) begin
            if(V_Count_Value < V_MAX)
                V_Count_Value <= V_Count_Value + 1;
            else V_Count_Value <= 0; 
        end
    end 
    
endmodule