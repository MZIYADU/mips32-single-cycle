module PIPO_Imm (data_out, data_in, load, clk);
    input [15 : 0] data_in;
    input load, clk;
    output reg [31 : 0] data_out;

    always @(posedge clk)
    if (load) data_out = {{16{data_in[15]}},data_in[15 : 0]};
endmodule