module antibounce(
    input clk,          // Reloj del sistema
    input reset,        // Reset activo bajo
    input sw_low,       // Entrada del sensor (activo bajo)
    output reg db       // Salida sin rebote (activo alto)
);
    
    // Parámetros del anti-rebote
    localparam N = 20;  // Contador de 2^20 ciclos = ~21ms a 50MHz

    localparam [2:0] 
        CERO     = 3'd0,    // Entrada estable en 0
        ESP0_1   = 3'd1,    // Esperando estabilización 0->1 (primera etapa)
        ESP0_2   = 3'd2,    // Esperando estabilización 0->1 (segunda etapa)  
        UNO      = 3'd3,    // Entrada estable en 1
        ESP1_1   = 3'd4,    // Esperando estabilización 1->0 (primera etapa)
        ESP1_2   = 3'd5;    // Esperando estabilización 1->0 (segunda etapa)
    
    reg [2:0] estado_actual, estado_siguiente;
    reg [N-1:0] contador;       // Contador para temporización
    wire [N-1:0] contador_siguiente;
    wire sw, tick;
    wire rst_n = ~reset; // Invertir reset para uso interno

    assign sw = !sw_low;         // Convertir a activo alto

    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            estado_actual <= CERO;
            contador <= 0;
        end
        else begin
            estado_actual <= estado_siguiente;
            contador <= contador_siguiente;
        end
    end
    
    // Contador libre y señal de tick
    assign contador_siguiente = contador + 1;
    assign tick = (contador == 0);     // Tick cada ~21ms
    

    always @(*) begin
        estado_siguiente = estado_actual;
        db = 0;
        
        case (estado_actual)
            // Entrada estable en 0
            CERO: begin
                if (sw) 
                    estado_siguiente = ESP0_1;  // Detectar transición 0->1
            end
            
            // Primera etapa de estabilización 0->1
            ESP0_1: begin
                if (!sw) 
                    estado_siguiente = CERO;    // Falsa transición
                else if (tick) 
                    estado_siguiente = ESP0_2;  // Continuar estabilización
            end
            
            // Segunda etapa de estabilización 0->1
            ESP0_2: begin
                if (!sw) 
                    estado_siguiente = CERO;    // Falsa transición
                else if (tick) 
                    estado_siguiente = UNO;     // Entrada estabilizada en 1
            end
            
            // Entrada estable en 1
            UNO: begin
                db = 1;                         // Salida activa
                if (!sw) 
                    estado_siguiente = ESP1_1;  // Detectar transición 1->0
            end
            
            // Primera etapa de estabilización 1->0
            ESP1_1: begin
                db = 1;                         // Mantener salida activa
                if (sw) 
                    estado_siguiente = UNO;     // Falsa transición
                else if (tick) 
                    estado_siguiente = ESP1_2;  // Continuar estabilización
            end
            
            // Segunda etapa de estabilización 1->0
            ESP1_2: begin
                db = 1;                         // Mantener salida activa
                if (sw) 
                    estado_siguiente = UNO;     // Falsa transición
                else if (tick) 
                    estado_siguiente = CERO;    // Entrada estabilizada en 0
            end
            
            default: 
                estado_siguiente = CERO;        // Estado seguro
        endcase
    end
    
endmodule
