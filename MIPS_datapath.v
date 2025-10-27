module MIPS_datapath(IRout, cond, LoadPC, LoadNPC, LoadIR, LoadA, LoadB, 
                LoadImm, MuxALU1, MuxALU2, Alufunc, LoadALUout, MuxPC, ReadM, 
                WriteM, LoadLMD, MuxWB, WriteReg, MuxRegeWr, MuxmemRD, clk);

    
    input LoadPC, LoadNPC, LoadIR, LoadA, LoadB, LoadImm, MuxALU1, MuxALU2, LoadALUout, 
            MuxPC, ReadM, WriteM, LoadLMD, MuxWB, WriteReg, MuxRegeWr, MuxmemRD, clk;
    input [2 : 0] Alufunc;

    output [31 : 0] IRout;
    output cond;

    wire [31 : 0] PCout, Aout, Bout, Immout, ALUout, LMDout, NPCout, rdDataReg1, rdDataReg2, MemData, x, y , z, p, q, r, s, wrDataReg;
    wire [4 :0] dr;

    PIPO PC (PCout, x, LoadPC, clk);
    adder Ad (y, PCout);
    PIPO NPC (NPCout, y, LoadNPC, clk);
    regbank Reg (rdDataReg1, rdDataReg2, wrDataReg, IRout[25 : 21], IRout[20 : 16], dr, WriteReg, clk);
    MUX mem_addr (s, PCout, ALUout, MuxmemRD);
    memory MEM (MemData, Bout, s, ReadM, WriteM, clk);
    PIPO IR (IRout, MemData, LoadIR, clk);
    PIPO A (Aout, rdDataReg1, LoadA, clk);
    PIPO B (Bout, rdDataReg2, LoadB, clk);
    PIPO_Imm Imm (Immout, IRout[15 :0], LoadImm, clk);
    MUX MUX_ALU1 (p, NPCout, Aout, MuxALU1);
    MUX MUX_ALU2 (q, Bout, Immout, MuxALU2);
    ALU OUT (r, p, q, Alufunc);
    PIPO ALU_out (ALUout, r, LoadALUout, clk);
    MUX MUX_PC (x, NPCout, ALUout, MuxPC);
    PIPO LMD (LMDout, MemData, LoadLMD, clk);
    MUX MUX_WB (wrDataReg, LMDout, ALUout, MuxWB);
    MUX_addr D_ADDR (dr, IRout[20 : 16], IRout [15 : 11], MuxRegeWr);
    comparator COMP (cond, Aout);
endmodule