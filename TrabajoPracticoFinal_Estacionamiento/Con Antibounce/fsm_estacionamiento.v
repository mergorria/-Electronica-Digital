module fsm_estacionamiento(
    input wire clk,
    input wire reset,
    input wire a,
    input wire b,
    output reg [2:0] cantidad // Conteo de autos en el estacionamiento

);
    wire ai, bi, clki, rsti;
    assign ai = ~a;
    assign bi = ~b;
    assign clki = ~clk;
    assign rsti = ~reset;
    reg [2:0] count = 3'd0; // Contador interno de autos
    localparam [2:0]
        reposo = 3'b000,      // Estado inicial - esperando acción
        entrada1 = 3'b001,    // Primera fase de entrada
        entrada2 = 3'b010,    // Segunda fase de entrada  
        entrada3 = 3'b011,    // Tercera fase - confirmando entrada
        salida1 = 3'b100,     // Primera fase de salida
        salida2 = 3'b101,     // Segunda fase de salida
        salida3 = 3'b110,     // Tercera fase - confirmando salida
        estado_invalido = 3'b111; 
    
    reg [2:0] estado_actual, estado_siguiente;
    reg sum, res; // Señales de suma y resta para el contador
    //reg entrada_reg, salida_reg;
    always @(posedge clki or posedge rsti) begin
        if (rsti) begin
            estado_actual <= reposo;
            count <= 3'd0; // Conteo inicia en 0 al resetear
        end else if (sum && count < 3'b111) begin
            count <= count + 1'b1; // Suma si solo entra auto
            estado_actual = estado_siguiente;
        end else if (res && count > 3'b000) begin
            count <= count - 1'b1; // Resta si solo sale auto y no está vacío
            estado_actual = estado_siguiente;
        end else
            estado_actual = estado_siguiente;
    end

always @(*) begin
    estado_siguiente = estado_actual; // Por defecto, mantener el estado actual
    cantidad = count; // Actualiza la salida con el conteo actual
    sum = 0;
    res = 0;
    case (estado_actual)
        reposo: begin
            if (ai && !bi)
                estado_siguiente = entrada1;
            else if (!ai && bi)
                estado_siguiente = salida1;
            else if (ai && bi)
                estado_siguiente = estado_invalido; // Estado reposo
        end
        entrada1: begin
            if (ai && bi)
                estado_siguiente = entrada2;
            else if (!ai && !bi) begin
                estado_siguiente = reposo;
            end else if (ai && !bi)
                estado_siguiente = entrada1;
        end
        entrada2: begin
            if (!ai && bi)
                estado_siguiente = entrada3;
            else if (ai && !bi) begin
                estado_siguiente = entrada1;
            end else if (ai && bi)
                estado_siguiente = entrada2; //Secuencia incompleta
        end
        entrada3: begin
            if (!ai && !bi) begin
                sum = 1; // Pulsar entrada
                estado_siguiente = reposo;
            end else if (ai && bi) begin
                estado_siguiente = entrada2; // Secuencia de salida completa
            end else if (!ai && bi) begin
                estado_siguiente = entrada3; // Secuencia incompleta
        end
        end
        salida1: begin
            if (ai && bi)
                estado_siguiente = salida2;
            else if (!ai && !bi) begin
                estado_siguiente = reposo;
            end else if (!ai && bi)
                estado_siguiente = salida1; // Estado invalido
        end
        salida2: begin
            if (ai && !bi)
                estado_siguiente = salida3;
            else if (!ai && bi) begin
                estado_siguiente = salida1;
            end else if (ai && bi)
                estado_siguiente = salida2; // Secuencia incompleta
        end
        salida3: begin
            if (!ai && !bi) begin
                res = 1; // Pulsar salida
                estado_siguiente = reposo;
            end else if (ai && bi) begin
                estado_siguiente = salida2; // Secuencia de entrada completa
            end else if (ai && !bi) begin
                estado_siguiente = salida3; // Secuencia incompleta
            end
        end
        estado_invalido: begin
            // Si se llega a un estado invalido, se resetea al estado inicial
            estado_siguiente = reposo;
        end
        default: begin
            estado_siguiente = reposo; // Reseteo a estado inicial por defecto
        end
    endcase
end

//assign entrada = entrada_reg;
//assign salida = salida_reg;
endmodule