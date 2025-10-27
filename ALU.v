module ALU(Out, in1, in2, alufunc);
    input [31 : 0] in1, in2;
    input [2 : 0] alufunc;
    output reg [31 : 0] Out;
    parameter  ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, SLT = 3'b100, MUL = 3'b101;

    always @(*)
    case (alufunc)
        ADD : Out <= #2 in1 + in2;
        SUB : Out <= #2 in1 - in2;
        AND : Out <= #2 in1 & in2;
        OR  : Out <= #2 in1 | in2;
        SLT : Out <= #2 in1 < in2;
        MUL : Out <= #2 in1 * in2;
    endcase

endmodule