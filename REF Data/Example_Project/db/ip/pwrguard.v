/* Verilog netlist generated by SCUBA Diamond (64-bit) 3.12.1.454 */
/* Module Version: 1.2 */
/* C:\lscc\diamond\3.12\ispfpga\bin\nt64\scuba.exe -w -n pwrguard -lang verilog -synth synplify -bus_exp 7 -bb -arch xo2c00 -type power_guard -width 4  */
/* Thu Jul 14 14:31:02 2022 */


`timescale 1 ns / 1 ps
module pwrguard (D, E, Q)/* synthesis NGD_DRC_MASK=1 */;
    input wire [3:0] D;
    input wire E;
    output wire [3:0] Q;


    PG PG_3 (.D(D[3]), .E(E), .Q(Q[3]));

    PG PG_2 (.D(D[2]), .E(E), .Q(Q[2]));

    PG PG_1 (.D(D[1]), .E(E), .Q(Q[1]));

    PG PG_0 (.D(D[0]), .E(E), .Q(Q[0]));



    // exemplar begin
    // exemplar end

endmodule
