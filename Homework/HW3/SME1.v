module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output match;
output [4:0] match_index;
output valid;
reg match;
reg [4:0] match_index;
reg valid;
reg [5:0] index_s;
reg [4:0] index_p;
reg [4:0] index_p_temp;
reg [4:0] cnt_m;
reg [4:0] cnt_m_temp;
reg [2:0] cs;
reg [2:0] cs_p;
reg [2:0] ns;
reg [2:0] ns_p;
reg [7:0] string_reg [0:31];
reg [5:0] cnt_s;
reg [7:0] pattern_reg [0:7];
reg [4:0] cnt_p;
reg done;
reg flag;
//////
parameter IDLE = 0;
parameter STR = 1;
parameter PAT = 2;
parameter PROCESS = 3;
parameter DONE = 4;
///////
parameter CHECK = 1;
parameter CHECKMATCH = 2;
parameter MATCH = 3;
parameter UNMATCH = 4;


reg [5:0] cnt_s_reg;
//#1 Combinational
always@(*) 
begin
    case(cs)
        IDLE: 
        begin
            if(isstring == 1) 
                ns = STR;
            else if(ispattern == 1) 
                ns = PAT;
            else 
                ns = IDLE;
        end
        STR:
        begin
            if(isstring == 1) 
                ns = STR;
            else 
                ns = PAT;
        end
        PAT: 
        begin
            if(ispattern == 1) 
                ns = PAT;
            else 
                ns = PROCESS;
        end
        PROCESS: 
        begin
            if(done == 1) 
                ns = DONE;
            else 
                ns = PROCESS;
        end
        DONE:
        begin
            if(isstring == 1) 
                ns = STR;
            else if(ispattern == 1) 
                ns = PAT;
            else 
                ns = IDLE;
        end
        default: 
            ns = IDLE;
    endcase

    if(cs == DONE && ns == STR)
        cnt_s = 6'd0;
    else if(cs  == IDLE && ns == STR)
        cnt_s = 6'd0;
    else if(isstring == 1)
        cnt_s = cnt_s_reg + 6'd1;
    else 
        cnt_s = cnt_s_reg;
end

//#2 Combinational
always@(*) begin
    if(cs == PROCESS) 
    begin
        case(cs_p)
            IDLE: 
                ns_p = CHECK;
            CHECK: 
            begin
                if(cnt_m == cnt_p) 
                    ns_p = MATCH;
                else if(cnt_s == index_s || cnt_p == index_p) 
                    ns_p = CHECKMATCH;
                else 
                    ns_p = CHECK;
            end 
            CHECKMATCH:
            begin
                if(pattern_reg[cnt_p-5'd1] == 8'h24) 
                begin
                    if(cnt_m+5'd1 == cnt_p) 
                        ns_p = MATCH;
                    else 
                        ns_p = UNMATCH;
                end
                else 
                begin
                    if(cnt_m == cnt_p) 
                        ns_p = MATCH;
                    else 
                        ns_p = UNMATCH;
                end
            end
            MATCH: 
                ns_p = IDLE;
            UNMATCH: 
                ns_p = IDLE;
            default: 
                ns_p = IDLE;
        endcase 
    end
    else 
        ns_p = IDLE;
end

//Sequential
integer  i;
always@(posedge clk or posedge reset) 
begin
    if(reset) 
    begin
        cs <= IDLE;
        cs_p <= IDLE;
    end
    else 
    begin
        cs <= ns;
        cs_p <= ns_p;
    end
    //
    if(reset) 
        match <= 0;
    else if(ns_p == MATCH) 
        match <= 1;
    else if(ns_p == UNMATCH)
    begin
        match <= 0;
        match_index <= 0;
    end
    //
    if(reset) 
        valid <= 0;
    else if(ns == DONE) 
        valid <= 1;
    else 
        valid <= 0;
    //
    if(reset) 
    begin
        for(i=0; i < 32; i=i+1) 
            string_reg[i] <= 8'd0;
    end
    else if(cs == DONE && ns == STR) 
        string_reg[5'd0] <= chardata;
    else if(isstring == 1) 
        string_reg[cnt_s] <= chardata;
    //
    if(reset) 
        cnt_s_reg <= 6'd0;
    else if(isstring == 1) 
        cnt_s_reg <= cnt_s;
    //
    if(reset) 
    begin
        for(i = 0; i < 8; i=i+1) 
            pattern_reg[i] <= 8'd0;
    end
    else if(ispattern == 1) 
        pattern_reg[cnt_p] <= chardata;
    //
    if(reset) 
        cnt_p <= 5'd0;
    else if(ispattern == 1) 
        cnt_p <= cnt_p + 5'd1;
    else if(ns == DONE) 
        cnt_p <= 5'd0;
    //
    if(reset || cs == DONE) 
    begin
        index_s <= 6'd0;
        index_p <= 5'd0;
        index_p_temp <= 5'd0;
        cnt_m <= 5'd0;
        cnt_m_temp <= 5'd0;
        match_index <= 5'd0;
        done <= 1'd0;
        flag <= 1'd0;
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
            else if(pattern_reg[index_p] == 8'h5e) //^
            begin
                if(index_s == 6'd0 && (string_reg[index_s] == pattern_reg[index_p+5'd1] || pattern_reg[index_p+5'd1] == 8'h2e))
                begin
                    index_p <= index_p + 5'd1;
                    index_s <= index_s + 6'd1;
                    cnt_m <= cnt_m + 5'd1;
                    if(string_reg[index_s] == 8'h20)
                        match_index <= index_s + 6'd1;
                    else
                        match_index <= index_s;
                end
                else if(string_reg[index_s] == 8'h20 && (string_reg[index_s+5'd1] == pattern_reg[index_p+5'd1] || pattern_reg[index_p+5'd1] == 8'h2e)) 
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
            else if(flag == 1'd1 && string_reg[index_s] != pattern_reg[index_p] && pattern_reg[index_p] != 8'h2e)
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
        else if(cs_p == MATCH || cs_p == UNMATCH)
        begin 
            done <= 1'd1;
        end
    end
    else
    begin
        done <= 1'd0;
    end
end
endmodule