module MUX(data_out, data1, data2, sel);

    input [31 : 0] data1, data2;
    input sel;
    output [31 : 0] data_out;

    assign data_out = sel? data2 : data1;
endmodule
