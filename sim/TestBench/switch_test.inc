task ClearSWCounter;
input sw_num;
begin
  repeat(4) rotate_left(sw_num);
end
endtask

task SetPowerLevel;
input [1:0] turns;
begin
  repeat(turns) rotate_right(1);
  push_button(1);
end
endtask

task SetPowerOK;
input [1:0] turns;
begin
  rotate_right(0);
  repeat(turns) rotate_right(1);
  push_button(1);
end
endtask

task SetVoltageCheck;
input [1:0] turns;
begin
  repeat(2) rotate_right(0);
  repeat(turns) rotate_right(1);
  push_button(1);
end
endtask
