module memory (rdData, wrData, addr, read, write, clk);
    input clk, write, read;
    input [31 : 0] addr;
    input [31 : 0] wrData;
    output reg [31 : 0] rdData;

    reg [31 : 0] Mem [1023 :  0];

    always @(*)
    if (read) rdData <= Mem[addr];
    

    always @(posedge clk)
    if (write) Mem[addr] <= wrData;
endmodule