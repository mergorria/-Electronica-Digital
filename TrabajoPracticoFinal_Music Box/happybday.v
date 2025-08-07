module happybday(
    input clk,
    output reg speaker
);

wire [15:0] ciclos_de_nota;
wire [4:0] direccion_nota;
wire [23:0] contador_tiempo;

ROM rom_inst (
    .direccion_nota(direccion_nota),
    .ciclos_de_nota(ciclos_de_nota)
);

Controlador controlador_inst (
    .clk(clk),
    .direccion_nota(direccion_nota),
    .contador_tiempo(contador_tiempo)
);

reg [15:0] contador;

initial begin
    speaker = 0; 
    contador = 0;
end

always @(posedge clk) begin
    if (contador >= ciclos_de_nota) begin
        speaker <= ~speaker;
        contador <= 0;
    end else begin
        contador <= contador + 1;
    end
end

endmodule
