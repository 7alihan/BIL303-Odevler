module tb_adder4;
    logic [3:0] a, b;
    logic [4:0] sum;

    adder4 dut (a, b, sum);

    initial begin
        $monitor("%0d + %0d = %0d", a, b, sum);
        a = 3;  b = 4;  #10;
        a = 9;  b = 5;  #10;
        a = 15; b = 15; #10;
    end
endmodule
