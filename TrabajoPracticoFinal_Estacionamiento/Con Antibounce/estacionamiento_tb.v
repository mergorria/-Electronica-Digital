`timescale 1ns / 1ps

module tb_fsm_estacionamiento();

    reg clk;
    reg reset;
    reg a;
    reg b;
    wire [2:0] ocupacion;

    fsm_estacionamiento dut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .cantidad(ocupacion)
    );

    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

    task apply_reset();
        begin
            reset = 0; a = 0; b = 0; #40;
            reset = 1; #20;
        end
    endtask

    task entrada_completa();
        begin
            a = 1; b = 0; #40;
            a = 1; b = 1; #40;
            a = 0; b = 1; #40;
            a = 0; b = 0; #40;
        end
    endtask

    task salida_completa();
        begin
            a = 0; b = 1; #40;
            a = 1; b = 1; #40;
            a = 1; b = 0; #40;
            a = 0; b = 0; #40;
        end
    endtask

    initial begin
        $dumpfile("estacionamiento_tb.vcd");
        $dumpvars(0, tb_fsm_estacionamiento);

        clk = 0; reset = 0; a = 0; b = 0;

        apply_reset();

        entrada_completa();

        entrada_completa();

        entrada_completa();

        salida_completa();

        salida_completa();
        
        salida_completa();

        #100;
        $finish;
    end

endmodule