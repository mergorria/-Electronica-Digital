`timescale 1ns/1ps

module happybday_tb;

    // Variables del testbench
    reg clk;
    wire speaker;

    // Instancia del módulo controlador de melodía
    happybday uut (
        .clk(clk),
        .speaker(speaker)
    );

    // Generación del reloj de 12 MHz
    initial begin   
        clk = 0;
    end

    always begin
        #41.6667 clk = ~clk; // Período de 12 MHz (83.3333 ns, la mitad del periodo es 41.6667 ns)
    end

    // Monitoreo de las salidas y señales internas
    initial begin
        $dumpfile("happybday_tb.vcd");
        $dumpvars(0, happybday_tb);

        // Corre la simulación por suficiente tiempo para observar la melodía completa
        // #25000000000;  25 segundos en nanosegundos

        // Tiempo suficiente para escuchar la primer estrofa. (Tiempo por nota medio segundo)
        #3000000000; // 3 segundos en nanosegundos
        $finish; 
    end


endmodule
