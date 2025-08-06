module estacionamiento(
    input wire clk,
    input wire reset,
    input wire a, // Sensor A (entrada de autos)
    input wire b, // Sensor B (salida de autos)
    output wire [2:0] cantidad // Contador de autos
);
    // Registros y cables internos
    wire a_limpio, b_limpio;           // Señales de sensores sin rebote
    antibounce anti_rebote_a(
        .clk(clk),
        .reset(reset),
        .sw_low(a),         // Sensor A activo bajo
        .db(a_limpio)       // Salida sin rebote activo alto
    );

    antibounce anti_rebote_b(
        .clk(clk),
        .reset(reset),
        .sw_low(b),         // Sensor B activo bajo
        .db(b_limpio)       // Salida sin rebote activo alto
    );

    // Instancia de la máquina de estados
    fsm_estacionamiento fsm (
        .clk(clk),
        .reset(reset),
        .a(a_limpio),
        .b(b_limpio),
        .cantidad(cantidad) // Salida del contador de autos
    );


endmodule