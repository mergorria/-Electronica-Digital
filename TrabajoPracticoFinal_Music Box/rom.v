module ROM(
    input [4:0] direccion_nota,
    output reg [15:0] ciclos_de_nota
);

reg [15:0] memoria [24:0];

initial begin
    //1era estrofa
    memoria[0] = 22900; // Do
    memoria[1] = 22900; // Do
    memoria[2] = 20407; // Re
    memoria[3] = 22900; // Do
    memoria[4] = 17191; // Fa
    memoria[5] = 18181; // Mi
    //2da estrofa
    memoria[6] = 22900; // Do
    memoria[7] = 22900; // Do
    memoria[8] = 20407; // Re
    memoria[9] = 22900; // Do
    memoria[10] = 15305; // Sol
    memoria[11] = 17191; // Fa
    //3era estrofa
    memoria[12] = 22900; // Do
    memoria[13] = 22900; // Do
    memoria[14] = 11471; // +Do
    memoria[15] = 13635; // La
    memoria[16] = 17191; // Fa
    memoria[17] = 18181; // Mi
    memoria[18] = 20407; // Re
    //4ta
    memoria[19] = 12875; // La#
    memoria[20] = 12875; // La#
    memoria[21] = 13635; // La
    memoria[22] = 17191; // Fa
    memoria[23] = 15305; // Sol
    memoria[24] = 17191; // Fa
end

always @(*) begin
    ciclos_de_nota = memoria[direccion_nota];
end

endmodule
