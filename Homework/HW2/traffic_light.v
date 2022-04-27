module traffic_light (
    input  clk,
    input  rst,
    input  pass,
    output reg R,
    output reg G,
    output reg Y
);


reg[1:0] state = 1;
reg[9:0] timer = 0;
reg[1:0] counter = 0;
//write your code here
always@(state)
begin
    case(state)
        2'd0:
        begin
            R = 0; G = 0; Y = 0;
        end
        2'd1:
        begin
            R = 0; G = 1; Y = 0;
        end
        2'd2:
        begin
            R = 0; G = 0; Y = 1;
        end
        2'd3:
        begin
            R = 1; G = 0; Y = 0;
        end
    endcase
end

always@(posedge clk, posedge rst)
begin
    if(rst)
    begin
        state <= 1;
        counter <= 0;
        timer <= 0;
    end
    else
    begin
        if(pass)
        begin
            if(state != 1 || counter != 0)
            begin
                state <= 1;
                counter <= 0;
                timer <= 1;
            end
        end
        else
        begin
            case(state)
            2'd0:
            begin
                if(timer == 8'd63)
                begin
                    state = 1;
                    timer <= 0;
                end
                else
                    timer <= timer + 1;
            end
            2'd1:
            begin
                if(counter == 2'd0 && timer == 10'd511)
                begin
                    state = 0;
                    timer <= 0;
                    counter <= 1;
                end
                else if(counter == 2'd1 && timer == 10'd63)
                begin
                    state = 0;
                    timer <= 0;
                    counter <= 2;
                end
                else if(counter == 2'd2 && timer == 10'd63)
                begin
                    state <= 2;
                    timer <= 0;
                    counter <= 0;
                end
                else
                    timer <= timer + 1;
            end
            2'd2:
            begin
                if(timer == 10'd255)
                begin
                    state = 3;
                    timer <= 0;
                end
                else
                    timer <= timer + 1;
            end
            2'd3:
            begin
                if(timer == 10'd511)
                begin
                    state = 1;
                    timer <= 0;
                end
                else
                    timer <= timer + 1;
            end
        endcase
        end
        //
    end
end
endmodule
