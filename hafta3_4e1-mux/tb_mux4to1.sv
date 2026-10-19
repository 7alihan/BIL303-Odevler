`timescale 1ns/1ps

module tb_mux4to1;

    logic [7:0] d0, d1, d2, d3;
    logic [1:0] sel;
    logic [7:0] y;

    int errors = 0;
    int tests  = 0;

    mux4to1 dut (
        .d0(d0), .d1(d1), .d2(d2), .d3(d3),
        .sel(sel),
        .y(y)
    );

    function automatic logic [7:0] ref_mux(input logic [1:0] s);
        case (s)
            2'b00: return d0;
            2'b01: return d1;
            2'b10: return d2;
            default: return d3;
        endcase
    endfunction

    task automatic check();
        logic [7:0] exp;
        exp = ref_mux(sel);
        tests++;
        if (y !== exp) begin
            errors++;
            $display("HATA  t=%0t sel=%0d d0=%h d1=%h d2=%h d3=%h -> y=%h (beklenen %h)",
                     $time, sel, d0, d1, d2, d3, y, exp);
        end else begin
            $display("OK    t=%0t sel=%0d -> y=%h", $time, sel, y);
        end
    endtask

    initial begin
        $dumpfile("mux4to1.vcd");
        $dumpvars(0, tb_mux4to1);

        d0 = 8'hAA; d1 = 8'hBB; d2 = 8'hCC; d3 = 8'hDD;
        for (int i = 0; i < 4; i++) begin
            sel = i[1:0];
            #10;
            check();
        end

        d0 = 8'h00; d1 = 8'hFF; d2 = 8'h00; d3 = 8'hFF;
        for (int i = 0; i < 4; i++) begin
            sel = i[1:0];
            #10;
            check();
        end

        repeat (20) begin
            d0  = $urandom;
            d1  = $urandom;
            d2  = $urandom;
            d3  = $urandom;
            sel = $urandom_range(0, 3);
            #10;
            check();
        end

        $display("--------------------------------------");
        if (errors == 0)
            $display("TEST GECTI: %0d testin hepsi basarili", tests);
        else
            $display("TEST BASARISIZ: %0d / %0d hata", errors, tests);
        $display("--------------------------------------");
        $finish;
    end

endmodule
