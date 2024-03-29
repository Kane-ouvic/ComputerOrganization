module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output match;
output [4:0] match_index;
output valid;
// reg match;
// reg [4:0] match_index;
// reg valid;

reg match;
reg[4:0] match_index;
reg valid;
reg[5:0] index_s;
reg[4:0] index_p;
reg[4:0] index_p_temp;
reg[4:0] cnt_m;
reg[4:0] cnt_m_temp;


reg[2:0] cs;
reg[2:0] ns;
reg[2:0] cs_p;
reg[2:0] ns_p;
reg[7:0] string_reg[0:31];
reg[7:0] pattern_reg[0:7];
reg[4:0] cnt_p;
reg done;
reg star_flag;

wire [7:0] s_debug = string_reg[index_s];
wire [7:0] p_debug = pattern_reg[index_p];
wire [7:0] p_debug_head = pattern_reg[index_p+5'd1];

parameter IDLE = 3'd0;
parameter RECV_S = 3'd1;
parameter RECV_P = 3'd2;
parameter PROCESS = 3'd3;
parameter DONE = 3'd4;

parameter P_IDLE = 3'd0;
parameter CHECK = 3'd1;
parameter CHECK_MATCH = 3'd2;
parameter P_DONE_MATCH = 3'd3;
parameter P_DONE_UNMATCH = 3'd4;

always @(posedge clk or posedge reset) //S
begin
    if(reset)
    begin
        cs <= IDLE;
        cs_p <= P_IDLE;
        
        //
        index_s <= 6'd0;
        index_p <= 5'd0;
        index_p_temp <= 5'd0;
        cnt_m <= 5'd0;
        cnt_m_temp <= 5'd0;
        match_index <= 5'd0;
        done <= 1'd0;
        star_flag <= 1'd0;
        //
        match <= 1'd0;
        valid <= 1'd0;

    end
    else if(cs == DONE)
    begin
        index_s <= 6'd0;
        index_p <= 5'd0;
        index_p_temp <= 5'd0;
        cnt_m <= 5'd0;
        cnt_m_temp <= 5'd0;
        match_index <= 5'd0;
        done <= 1'd0;
        star_flag <= 1'd0;
        valid <= 1'd1;
    end
    else if(cs == PROCESS)
    begin
        if(cs_p == CHECK)
        begin
            if(string_reg[index_s] == pattern_reg[index_p] || pattern_reg[index_p] == 8'h2e)
            begin
                index_p <= index_p + 5'd1;
                index_s <= index_s + 6'd1;
                cnt_m <= cnt_m + 5'd1;
                if(index_p == 5'd0)
                    match_index <= index_s;
            end
            else if(pattern_reg[index_p] == 8'h5e)
            begin
                if(index_s == 6'd0 && (string_reg[index_s] == pattern_reg[index_p + 5'd1] || pattern_reg[index_p + 5'd1] == 8'h2e))
                begin
                    index_p <= index_p + 5'd1;
                    index_s <= index_s + 6'd1;
                    cnt_m <= cnt_m + 5'd1;
                    if(string_reg[index_s] == 8'h20)
                        match_index <= index_s + 6'd1;
                    else
                        match_index <= index_s;
                end
                else if(string_reg[index_s] == 8'h20 && (string_reg[index_s+5'd1] == pattern_reg[index_p+5'd1] || pattern_reg[index_p+5'd1] == 8'h2e) ) 
                begin
                    index_p <= index_p + 5'd1;
                    index_s <= index_s + 6'd1;
                    cnt_m <= cnt_m + 5'd1; 
                    if(string_reg[index_s] == 8'h20) 
                        match_index <= index_s + 6'd1;
                    else 
                        match_index <= index_s;
                end
                else
                begin
                    index_p <= index_p_temp;
                    cnt_m <= 5'd0;
                    if(index_p != 5'd0)
                        index_s <= match_index + 6'd1;
                    else
                        index_s <= index_s + 6'd1;
                end
            end
            else if(pattern_reg[index_p] == 8'h24 && (index_s == cnt_s || string_reg[index_s] == 8'h20))
            begin
               index_p <= index_p + 5'd1;
               index_s <= index_s + 6'd1;
               cnt_m <= cnt_m + 5'd1;
               if(index_p == 5'd0)
                    match_index <= index_s;
            end
            else if(pattern_reg[index_p] == 8'h2A)
            begin
                star_flag <= 1'd1;
                index_p <= index_p + 5'd1;
                index_p_temp <= index_p + 5'd1;
                index_s <= index_s;
                cnt_m <= cnt_m + 5'd1;
                cnt_m_temp <= cnt_m + 5'd1;
                if(index_p == 5'd0)
                    match_index <= index_s;
            end
            else if(star_flag == 1'd1 && string_reg[index_s] != pattern_reg[index_p] && pattern_reg[index_p] != 8'h2e)
            begin
                index_p <= index_p_temp;
                cnt_m <= cnt_m_temp;
                index_s <= index_s + 6'd1;
            end
            else if(string_reg[index_s] != pattern_reg[index_p] && pattern_reg[index_p] != 8'h2e)
            begin
                index_p <= index_p_temp;
                cnt_m <= 5'd0;
                if(index_p != 5'd0) 
                    index_s <= match_index + 6'd1;
                else 
                    index_s <= index_s + 6'd1;
            end
        end
        else if(cs_p == P_DONE_MATCH)
        begin
            done <= 1'd1;
            match <= 1'd1;
        end
        else if(cs_p == P_DONE_UNMATCH)
        begin
            done <= 1'd1;
            match <= 1'd0;
        end
    end
    else
    begin
        cs <= ns;
        cs_p <= ns_p;
        done <= 1'd0;
    end    
end

always@(*)
begin
    case(cs)
        IDLE:
        begin
            if(isstring == 1'd1) 
                ns = RECV_S;
            else if(ispattern == 1'd1) 
                ns = RECV_P;
            else ns = IDLE;
            ns_p = P_IDLE;
        end
        RECV_S:
        begin
            if(isstring == 1'd1)
                ns = RECV_S;
            else
                ns = RECV_P;
            ns_p = P_IDLE;
        end
        RECV_P:
        begin
            if(ispattern == 1'd1)
                ns = RECV_P;
            else
                ns = PROCESS;
            ns_p = P_IDLE;
        end
        PROCESS:
        begin
            if(done == 1'd1)
                ns = DONE;
            else
                ns = PROCESS;
            //
            case(cs_p)
                P_IDLE:
                begin
                    ns_p = CHECK;
                end
                CHECK:
                begin
                    if(cnt_m == cnt_p)
                        ns_p = P_DONE_MATCH;
                    else if(cnt_s == index_s || cnt_p == index_p)
                        ns_p = CHECK_MATCH;
                    else
                        ns_p = CHECK;
                end
                CHECK_MATCH:
                begin
                    if(pattern_reg[cnt_p - 5'd1] == 8'h24)
                    begin
                        if(cnt_m + 5'd1 == cnt_p)
                            ns_p = P_DONE_MATCH;
                        else
                            ns_p = P_DONE_UNMATCH;
                    end
                end
                P_DONE_MATCH:
                begin
                    ns_p = P_IDLE;
                end
                P_DONE_UNMATCH:
                begin
                    ns_p = P_IDLE;
                end
                default:
                    ns_p = P_IDLE;
            //
            endcase
        end
            
        DONE:
        begin
            if(isstring == 1'd1)
                ns = RECV_S;
            else if(ispattern == 1'd1)
                ns = RECV_P;
            else
                ns = IDLE;
            ns_p = P_IDLE;
        end
        default:
        begin
            ns = IDLE;
            ns_p = P_IDLE;
        end
            
    endcase
end

endmodule
