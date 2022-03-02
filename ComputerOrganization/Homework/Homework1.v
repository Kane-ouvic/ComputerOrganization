`timescale 1ns/10ps
module CS(Y, X, reset, clk);

  input clk, reset; 
  input 	[7:0] X;
  output reg [9:0] Y;
  
  //--------------------------------------
  //  \^o^/   Write your code here~  \^o^/
  //--------------------------------------
    reg[9:0] sum;

    reg[7:0] XS[9:0];
    reg[7:0] X_avg;
    reg[7:0] X_app;
    reg[7:0] n;
    reg[3:0] j;
    integer i;
    integer min = 100000;
    integer comparator;

  always @(posedge clk)
  begin
      if(!reset)
      begin
          sum <= 0;
          n <= 0;
          Y <= 0;
          X_app <= 0;
          X_avg <= 0;
      end
      else
      begin
          n = n + 1;
          XS[j] = X;
          sum = sum + X;
          
        
          if(n < 9)
          begin
              n = n + 1;
              XS[j] = X;
              sum = sum + X;
              //
              if(n == 8)
              begin
                  X_avg = sum / 9;
                  X_app = XS[0];
                  for(i=0; i < 9; i = i + 1)
                  begin
                      if(X_avg > XS[i])
                      begin
                          if(min > (X_avg - XS[i]))
                          begin
                            min = X_avg - XS[i];
                            X_app = XS[i];
                          end
                          else
                          begin
                            min = min;
                          end
                      end
                      else
                      begin

                      end
                  end
                  for(i=0; i < 9; i = i + 1)
                  begin
                      Y = Y + XS[i] + X_app;
                  end
                  Y = Y / 8;
              end
              else
              begin
                  X_avg = X_avg;
              end
          end
          else
          begin
              sum = sum - X[j];
              XS[j] = X;
              X_avg = sum / 9;
              X_app = XS[0];
              for(i=0; i < 9; i = i + 1)
                begin
                      if(X_avg > XS[i])
                      begin
                          if(min > (X_avg - XS[i]))
                          begin
                            min = X_avg - XS[i];
                            X_app = XS[i];
                          end
                          else
                          begin
                            min = min;
                       end
                    end
                end
              //
              for(i=0; i < 9; i = i + 1)
                begin
                    Y = Y + XS[i] + X_app;
                end
               Y = Y / 8;
          end
          if(j == 8)
            j = 0;
          else
            j = j+1;
      end
  end



endmodule