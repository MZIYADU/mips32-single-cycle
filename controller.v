module controller (LoadPC, LoadNPC, LoadIR, LoadA, LoadB, LoadImm, MuxALU1, MuxALU2, Alufunc, LoadALUout, 
        MuxPC, ReadM, WriteM, LoadLMD, MuxWB, WriteReg, MuxRegeWr,MuxmemRD, IRout, cond, clk, start);

    input [31 : 0] IRout;
    input cond, clk, start;
    output reg LoadPC, LoadNPC, LoadIR, LoadA, LoadB, LoadImm, MuxALU1, MuxALU2, LoadALUout, 
               MuxPC, ReadM, WriteM, LoadLMD, MuxWB, WriteReg, MuxRegeWr, MuxmemRD;
    output reg [2 : 0] Alufunc;

    reg [2 : 0] state, next_state;
    reg HALTED;

    parameter S0 = 3'b000, IF = 3'b001, ID = 3'b010, EX = 3'b011, MEM = 3'b100, WB = 3'b101;

    parameter  ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, SLT = 3'b100, MUL = 3'b101;

    parameter ADD_RR = 6'b000000, SUB_RR = 6'b000001, AND_RR = 6'b000010, OR_RR = 6'b000011, SLT_RR = 6'b000100,
              MUL_RR = 6'b000101, HLT = 6'b111111, LW  = 6'b001000, SW = 6'b001001, ADD_I = 6'b001010,
              SUB_I = 6'b001011, SLT_I = 6'b001100, BNEQZ = 6'b001101, BEQZ = 6'b001110;

    always @(posedge clk)
    state <= next_state;

    always @(*)
    case (state)
    S0 : if (HALTED) begin next_state = S0; LoadPC = 0; LoadNPC = 0; LoadIR = 0; LoadA = 0; LoadB = 0; LoadImm = 0; MuxALU1 = 0; 
            MuxALU2 = 0; Alufunc = 0; LoadALUout = 0; MuxPC = 0; ReadM = 0; WriteM = 0; LoadLMD = 0;
            MuxWB = 0; WriteReg = 0; MuxRegeWr = 0; MuxmemRD = 0; end
        else if (start) begin next_state = IF; LoadPC = 0; LoadNPC = 0; LoadIR = 0; LoadA = 0; LoadB = 0; LoadImm = 0; MuxALU1 = 0; 
               MuxALU2 = 0; Alufunc = 0; LoadALUout = 0; MuxPC = 0; ReadM = 0; WriteM = 0; LoadLMD = 0;
               MuxWB = 0; WriteReg = 0; MuxRegeWr = 0; MuxmemRD = 0; end
        else begin next_state = S0; LoadPC = 0; LoadNPC = 0; LoadIR = 0; LoadA = 0; LoadB = 0; LoadImm = 0; MuxALU1 = 0; 
             MuxALU2 = 0; Alufunc = 0; LoadALUout = 0; MuxPC = 0; ReadM = 0; WriteM = 0; LoadLMD = 0;
             MuxWB = 0; WriteReg = 0; MuxRegeWr = 0; MuxmemRD=0; end

    IF : begin
        next_state = ID;
        #2 MuxmemRD = 0; ReadM = 1; LoadIR = 1; LoadNPC = 1; LoadPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; MuxALU1 = 0; 
           MuxALU2 = 0; Alufunc = 0; LoadALUout = 0; MuxPC = 0; WriteM = 0; LoadLMD = 0;
           MuxWB = 0; WriteReg = 0; MuxRegeWr = 0;
        end
    
    ID : begin next_state = EX;
        #2 LoadIR = 0; LoadNPC = 0; ReadM = 0; LoadA = 1; LoadB = 1; LoadImm = 1; end

    EX : begin  
         case (IRout [31 : 26])
         ADD_RR : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 0; Alufunc = ADD; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 1; end
         SUB_RR : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 0; Alufunc = SUB; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 1; end
         AND_RR : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 0; Alufunc = AND; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 1; end
         OR_RR  : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 0; Alufunc = OR; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0;  LoadALUout = 1; end
         SLT_RR : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 0; Alufunc = SLT; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 1; end
         MUL_RR : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 0; Alufunc = MUL; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 1; end
         LW, SW : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 1; Alufunc = ADD; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 1; end
         ADD_I  : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 1; Alufunc = ADD; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 1; end
         SUB_I  : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 1; Alufunc = SUB; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 1; end
         SLT_I  : begin next_state = MEM; #2 MuxALU1 = 1; MuxALU2 = 1; Alufunc = SLT; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 1; end
         BNEQZ  : begin next_state = MEM; #2 MuxALU1 = 0; MuxALU2 = 1; Alufunc = ADD; HALTED = 0; LoadALUout = 1;
                    if(cond == 1) MuxPC = 0;
                    else MuxPC = 1; end
         BEQZ  : begin next_state = MEM; #2 MuxALU1 = 0; MuxALU2 = 1; Alufunc = ADD; HALTED = 0; LoadALUout = 1;
                    if (cond ==1) MuxPC = 1;
                    else MuxPC = 0; end
         HLT    : begin next_state = S0; #2 MuxALU1 = 1'bx; MuxALU2 =1'bx ; Alufunc = 1'bx; HALTED = 1; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 0; end
         default: begin next_state = IF; #2 MuxALU1 = 1; MuxALU2 = 0; Alufunc = ADD; HALTED = 0; MuxPC = 0; LoadA = 0; LoadB = 0; LoadImm = 0; LoadALUout = 0; end
         endcase
    end

    MEM : case (IRout [31 : 26])
          LW : begin next_state = WB; #2 LoadPC = 1; ReadM = 1; MuxmemRD = 1; LoadLMD = 1; end
          SW : begin next_state = IF; #2 LoadPC = 1; WriteM = 1; MuxmemRD = 1; end
          BEQZ, BNEQZ : begin next_state = IF; #2 LoadPC = 1; end
          default : begin next_state = WB; #2 LoadPC = 1; end
          endcase

    WB : case (IRout [31 : 26])
         LW : begin next_state = IF; #2 MuxWB = 0; MuxRegeWr = 0; WriteReg = 1; end
         ADD_RR, SUB_RR, SLT_RR, ADD_RR, OR_RR, MUL_RR : begin next_state = IF; #2 MuxWB = 1;MuxRegeWr = 1; WriteReg = 1; end
         ADD_I, SUB_I, SLT_I : begin next_state = IF; #2 MuxWB = 1; MuxRegeWr = 0; WriteReg =1; end
         default : next_state = IF;
         endcase

    default : begin next_state = S0; LoadPC = 0; LoadNPC = 0; LoadIR = 0; LoadA = 0; LoadB = 0; LoadImm = 0; MuxALU1 = 0; 
            MuxALU2 = 0; Alufunc = 0; LoadALUout = 0; MuxPC = 0; ReadM = 0; WriteM = 0; LoadLMD = 0;
            MuxWB = 0; WriteReg = 0; MuxRegeWr = 0; MuxmemRD = 0; end
    endcase
endmodule