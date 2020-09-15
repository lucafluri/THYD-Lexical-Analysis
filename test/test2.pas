Program SumOfSquares;
var
    len: Integer;
    n, sum: Integer;
begin
    len := 10;
    sum := 0;
    n := 1;
    while n <= 10 do
    begin
        sum := sum + n * n;
        n := n + 1
    end;
    WriteLn( sum );
    if (sum >= 0) and (sum < 500) or (sum = +0) and (len <> -1) then
        WriteLn( (sum + 2 * 3) div 4 );
    WriteLn(-3);
    WriteLn( not 1 );
    WriteLn( not 0 );
end.

