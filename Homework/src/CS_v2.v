`timescale 1ns/10ps
module CS(Y, X, reset, clk);

  input clk, reset; 
  input[7:0] X;
  output reg[9:0] Y;
  
  reg[7:0] XS[8:0];
  reg[10:0] sum;
  reg[7:0] X_avg;
  reg[7:0] X_app;
  reg[7:0] min;
  reg[3:0] n;
  reg[3:0] j;
  integer  i;

  always@(sum)
  begin

      if(n < 9)
      begin
        sum = sum;
      end
      else
      begin
        X_avg = (sum)/9;
        min = 8'b11111111;

        for(i = 0; i < 9; i = i + 1)
        begin
            if(XS[i] <= X_avg && min > (X_avg - XS[i]))
            begin
              min = X_avg - XS[i];
              X_app = XS[i];
            end
        end
          Y = (sum + 9*X_app)/8;
    
        end
  end

  always@(negedge clk, posedge reset)
  begin
      if(reset)
      begin
        XS[0] <= 0; XS[1] <= 0; XS[2] <= 0; XS[3] <= 0; XS[4] <= 0;
        XS[5] <= 0; XS[6] <= 0; XS[7] <= 0; XS[8] <= 0;
        sum <= 0;
        Y <= 0;
        X_avg <= 0;
        X_app <= 0;
        j <= 0;
        n <= 0;
      end
      else
      begin
        
        XS[j] <= X;
        sum <= sum + X - XS[j];
        if(j == 4'd8)
          j <= 0;
        else 
          j <= j + 4'd1;
        
        if(n < 9)
          n <= n + 1;
          
        
      end
  end

endmodule