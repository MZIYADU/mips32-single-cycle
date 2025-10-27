// add 10 + 20 + 35
module test_mips32;
    reg clk;
    reg start;

    integer k;
    wire [31 :0] IRout;
    wire [2 : 0] Alufunc;

    MIPS_datapath MIPS32(IRout, cond, LoadPC, LoadNPC, LoadIR, LoadA, LoadB, 
                LoadImm, MuxALU1, MuxALU2, Alufunc, LoadALUout, MuxPC, ReadM, 
                WriteM, LoadLMD, MuxWB, WriteReg, MuxRegeWr, MuxmemRD, clk);
    controller CONT(LoadPC, LoadNPC, LoadIR, LoadA, LoadB, LoadImm, MuxALU1, MuxALU2, Alufunc, LoadALUout, 
        MuxPC, ReadM, WriteM, LoadLMD, MuxWB, WriteReg, MuxRegeWr,MuxmemRD, IRout, cond, clk, start);
    
    initial clk = 1'b0;

    always #5 clk = ~clk;

    initial
    begin
    for (k =0; k<31; k++)
    MIPS32.Reg.regfile[k] = k;

    MIPS32.MEM.Mem[0] = 32'h2801000a;  // ADDI R1, R0, 10
    MIPS32.MEM.Mem[1] = 32'h28020014;  // ADDI R2, R0, 20
    MIPS32.MEM.Mem[2] = 32'h28030019;  // ADDI R3, R0, 25
    MIPS32.MEM.Mem[3] = 32'h00222000;  // ADD  R4, R1, R2
    MIPS32.MEM.Mem[4] = 32'h00832800;  // ADD  R5, R4, R3
    MIPS32.MEM.Mem[5] = 32'hfc000000;  // HLT

    CONT.HALTED = 0;
    MIPS32.PC.data_out = 0;

    #400
    for(k=0; k<6; k++)
    $display ("R%1d = %2d",k,MIPS32.Reg.regfile[k]);

    end

    initial
    begin
        $dumpfile("mips_add.vcd");
        $dumpvars(0, test_mips32);
        #500 $finish;
    end
    initial #2 start = 1;

endmodule