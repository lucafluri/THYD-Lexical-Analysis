
Program Test1;
var
    n: Integer;
    a, b: Integer;
begin
    a := 1 + 2;
    WriteLn( a );
    b := 3 * a div 2;
    WriteLn( b );
    if a = b then
        a := -a
    else
        b := -a;
    WriteLn( a, b );
    n := 1;
    while n < 4 do
    begin
        WriteLn( n );
        a := (a + 1) mod 3;
        b := b - 1;
        n := n + 1;
    end;
    WriteLn( n );
    WriteLn( n );
end.
