`define SW_T (50_000)

task rotate_right;
input sw_num;
begin
  if (sw_num) begin
    r_sw1_a = 1;
    r_sw1_b = 1;
    #(`SW_T);
    r_sw1_a = 0;
    #(`SW_T);
    r_sw1_b = 0;
    #(`SW_T);
    r_sw1_a = 1;
    #(`SW_T);
    r_sw1_b = 1;
    #(`SW_T);
  end
  else begin
    r_sw0_a = 1;
    r_sw0_b = 1;
    #(`SW_T);
    r_sw0_a = 0;
    #(`SW_T);
    r_sw0_b = 0;
    #(`SW_T);
    r_sw0_a = 1;
    #(`SW_T);
    r_sw0_b = 1;
    #(`SW_T);
  end
end
endtask

task rotate_left;
input sw_num;
begin
  if (sw_num) begin
    r_sw1_a = 1;
    r_sw1_b = 0;
    #(`SW_T);
    r_sw1_a = 0;
    #(`SW_T);
    r_sw1_b = 1;
    #(`SW_T);
    r_sw1_a = 1;
    #(`SW_T);
    r_sw1_b = 0;
    #(`SW_T);
    r_sw1_b = 1;
    #(`SW_T);
  end
  else begin
    r_sw0_a = 1;
    r_sw0_b = 0;
    #(`SW_T);
    r_sw0_a = 0;
    #(`SW_T);
    r_sw0_b = 1;
    #(`SW_T);
    r_sw0_a = 1;
    #(`SW_T);
    r_sw0_b = 0;
    #(`SW_T);
    r_sw0_b = 1;
    #(`SW_T);
  end
end
endtask

task push_button;
input sw_num;
begin
  if (sw_num) begin
    r_sw1_sw = 1;
    #(`SW_T)
    r_sw1_sw = 0;
    repeat(10) #(`SW_T)
    r_sw1_sw = 1;
  end
  else begin
    r_sw0_sw = 1;
    #(`SW_T)
    r_sw0_sw = 0;
    repeat(10) #(`SW_T)
    r_sw0_sw = 1;
  end
end
endtask
