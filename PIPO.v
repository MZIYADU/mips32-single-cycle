module PIPO (data_out, data_in, load, clk);
    input [31 : 0] data_in;
    input load, clk;
    output reg [31 : 0] data_out;

    always @(posedge clk)
    if (load) data_out <= #2 data_in;

endmodule