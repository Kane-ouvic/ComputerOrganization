`timescale 1ns/10ps
module CS(Y, X, reset, clk);

  input clk, reset; 
  input 	[7:0] X;
  output reg[9:0] Y;
  
  //--------------------------------------
  //  \^o^/   Write your code here~  \^o^/
  //--------------------------------------
  reg[7:0] XS[8:0];
  reg[10:0] sum;
  reg[7:0] X_avg;
  reg[7:0] X_app;
  reg[7:0] min;
  reg[3:0] n;
  reg[3:0] j;

  always@(negedge clk, posedge reset)
  begin
      if(reset)
      begin
        XS[0] = 0; XS[1] = 0; XS[2] = 0; XS[3] = 0; XS[4] = 0;
        XS[5] = 0; XS[6] = 0; XS[7] = 0; XS[8] = 0;
        sum = 0;
        X_avg = 0;
        X_app = 0;
        min = 8'b11111111;
        n = 0;
        j = 0;
      end
      else
      begin
        if(n < 4'd8)
        begin
          XS[j] = X;
          n = n + 4'd1;
          sum = sum + X;
          j = j + 4'd1;
        end
        else
        begin
          
          sum = sum + X - XS[j];
          XS[j] = X;
          X_avg = (sum)/9;
          //
          min = 8'b11111111;

          if(XS[0] <= X_avg && min > (X_avg - XS[0]))
          begin
              min = X_avg - XS[0];
              X_app = XS[0];
          end
          if(XS[1] <= X_avg && min > (X_avg - XS[1]))
          begin
              min = X_avg - XS[1];
              X_app = XS[1];
          end
          if(XS[2] <= X_avg && min > (X_avg - XS[2]))
          begin
              min = X_avg - XS[2];
              X_app = XS[2];
          end
          if(XS[3] <= X_avg && min > (X_avg - XS[3]))
          begin
              min = X_avg - XS[3];
              X_app = XS[3];
          end
          if(XS[4] <= X_avg && min > (X_avg - XS[4]))
          begin
              min = X_avg - XS[4];
              X_app = XS[4];
          end
          if(XS[5] <= X_avg && min > (X_avg - XS[5]))
          begin
              min = X_avg - XS[5];
              X_app = XS[5];
          end
          if(XS[6] <= X_avg && min > (X_avg - XS[6]))
          begin
              min = X_avg - XS[6];
              X_app = XS[6];
          end
          if(XS[7] <= X_avg && min > (X_avg - XS[7]))
          begin
              min = X_avg - XS[7];
              X_app = XS[7];
          end
          if(XS[8] <= X_avg && min > (X_avg - XS[8]))
          begin
              min = X_avg - XS[8];
              X_app = XS[8];
          end
        Y = (sum + 9*X_app)/8;
        if(j == 4'd8)
          j = 0;
        else 
          j = j + 4'd1;
        end
      end
  end

endmodule