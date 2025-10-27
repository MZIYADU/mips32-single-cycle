module regbank (rdData1, rdData2, wrData, sr1, sr2, dr, write, clk);
    input clk, write;
    input [4 : 0] sr1, sr2, dr;
    input [31 : 0] wrData;
    output reg [31 : 0] rdData1, rdData2;

    reg [31 : 0] regfile [31 :  0];
    always @(*)
    begin
        if(sr1 == 0)
        rdData1 <= 0;
        else
        rdData1 <= regfile[sr1];

        if (sr2 == 0)
        rdData2 <= 0;
        else
        rdData2 <= regfile[sr2];
    end

    always @(posedge clk)
    if (write && dr != 0) regfile [dr] <= wrData;
endmodule