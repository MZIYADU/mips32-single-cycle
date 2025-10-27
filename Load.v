// Loard a word stored in memory location 120 and add 45 to it, and store the result in memory location 121

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

    MIPS32.MEM.Mem[0] = 32'h28010078;  // ADDI R1, R0, 120
    MIPS32.MEM.Mem[1] = 32'h20220000;  // LW   R2, 0(R1)
    MIPS32.MEM.Mem[2] = 32'h2842002d;  // ADDI R2, R2, 45
    MIPS32.MEM.Mem[3] = 32'h24220001;  // SW   R2, 1(R1)
    MIPS32.MEM.Mem[4] = 32'hfc000000;  // HLT

    MIPS32.MEM.Mem[120] = 85;

    CONT.HALTED = 0;
    MIPS32.PC.data_out = 0;

    #600
    $display ("Mem[120] = %4d \nMem[121] = %4d",MIPS32.MEM.Mem[120], MIPS32.MEM.Mem[121]);

    end

    initial
    begin
        $dumpfile("mips_load_store.vcd");
        $dumpvars(0, test_mips32);
        #700 $finish;
    end
    initial #2 start = 1;

endmodule