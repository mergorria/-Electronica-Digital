module Controlador(
    input clk, 
    output reg [4:0] direccion_nota,
    output reg [23:0] contador_tiempo 
);


parameter tiempo_por_nota = 6000000; // 60MHz, así cada nota dura medio segundo


initial begin
    contador_tiempo = 0;
    direccion_nota = 0;
end


always @(posedge clk) begin
    if (contador_tiempo >= tiempo_por_nota - 1) begin
        if (direccion_nota < 24) begin
            direccion_nota <= direccion_nota + 1;
        end else begin
            direccion_nota <= 0;
        end
        contador_tiempo <= 0;
    end else begin
        contador_tiempo <= contador_tiempo + 1;
    end
end

endmodule
