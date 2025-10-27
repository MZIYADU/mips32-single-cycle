module comparator (cond, data);
    input [31 : 0] data;
    output reg cond;

    always @(data)
    if (data == 0) cond =1'b1;
    else cond = 1'b0;
endmodule 