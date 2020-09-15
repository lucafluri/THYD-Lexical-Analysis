program HelloWorld;
var
    i : Integer;
begin
    i := 2;

    case i of
      1: begin
             WriteLn(1)
         end;
      1..2: WriteLn(2);
      3: WriteLn(3)
    else
      WriteLn(i);
      WriteLn(i)
    end;

    for i := 5 downto 1 do
    begin
        WriteLn(i);
        {if i = 1 then i := 10;}
    end;
    WriteLn(i);

    i := 10;
    repeat
        i := i - 1; {1.E2};
        {'fds''dfs'};
    until i = 0;
    WriteLn(i);
end.

