{ https://github.com/makarcz/mktetr_tp3/blob/master/mktris.pas }
program mktris{(input,output)};

{
   ----------------------------------------------------------------------
   Project: MKTRIS
            Tetris-like game / Tetris clone.
   File:    mktris.pas
   Purpose: Main source code file. Game logic. Main game loop.
   Author:  Copyright (C) by Marek Karcz 2016-2018.
            All rights reserved.
   ----------------------------------------------------------------------
}

(* test this name of a comment *)

const { constant definitions }

   ScWidth   = 10;  {scene width}
   InfoCol   = 25;  {column where info texts start}
   ScHeight  = 23;  {scene height}
   ScRow     = 1;   {scene left-upper corner coordinate (Y or Row)}
   { uncomment the constant below in final version }
   {ScCol     = 1;}   {scene left-upper corner coordinate (X or Col)}
   IntlSpd   = 75;  {initial # of frames to refresh falling piece}
   RefrRate  = 1;   {determines delay in the loop while the scene is refreshed}
   NumOfPcs  = 7;   {number of pieces}
   HiScFName = 'mktrishs.dat'; {hi-score file name}

name { name declarations }

   Cell = (Empty, Filled);
   Shape = array[1..4,1..4] of Cell; { puzzle shape definition }
   Block = array[1..4] of Shape; { all rotated variations of a puzzle }
   All = array[1..NumOfPcs] of Block;   { array of all puzzles }
   Scene = array[1..ScWidth,1..ScHeight] of Cell;

   { Piece falls and when it can no longer fall down, it is converted    }
   { or rather - transferred to the Scene. Once the piece becomes        }
   { part of the Scene, it is no longer abiding by the rules of the      }
   { Shape. The Scene is being reduced following different set of rules. }
   { If the row of the Scene is filled with Filled Cells, then it is     }
   { reduced and contents above it are scrolled down.                    }

   PtrBlkInfo = ^BlkInfo; { pointer to the piece information }

   BlkInfo = record  { keeps info about the falling piece}

               PrevRow:      Integer;
               PrevCol:      Integer; {previous coord. (for repainting)}
               PrevSeqNum:   Integer;
               Row,Col:      Integer; {block coordinates}
               Repaint:      Boolean; {flag if block needs repainting}
               ShNum,SeqNum: Integer; {shape and sequence numbers}

             end;

   PlName = string[20];

   HiScore = record { keeps information about player's score }

                PlrName: PlName;
                Score:   Integer;

             end;

   HiScoreTbl = array[1..5] of HiScore;

var { declare variables of the program }

   FallSpeed:   Integer;   {# of frames to refresh falling piece / scene}
   Frame:       Integer;   {frames counter}
   { remove variable below in final version - it will be a constant }
   ScCol:       Integer;   {scene X coordinate}
   Key:         Char;      {code of the key pressed by player}
   ValidKey:    Boolean;   {flag to validate the pressed key}
   sh:          Shape;
   sh2:         Shape;
   bl:          Block;
   bl2:         Block;
   Pieces:      All;
   CurrBlk:     PtrBlkInfo; {pointer to current block}
   NewBlk:      PtrBlkInfo; {pointer to new block - temporary}
   Bucket:      Scene;
   Freeze:      Boolean;    {pause / restore flag}
   Score:       Integer;
   {HiScore:     Integer;}
   HiScoreRec:  HiScore;
   HiScTbl:     HiScoreTbl;
   GameOver:    Boolean;
   {HiScoreFile: file of Integer;}
   HiScoreFile: file of HiScore;
   Pretty:      Boolean;
   SolidBlocks: Boolean;
   PlayerName:  PlName;
   i:           Integer;

{$I mktet01.pas}

{
  ---------------------------------------------------------
   Initialize game.
  ---------------------------------------------------------
}
procedure InitGame;
   var x1,x2 : Integer;
begin

   FallSpeed := IntlSpd;
   Frame := 0;
   Score := 0;
   {HiScore := ReadHiScore;}
   for i:= 1 to 5 do
   begin
      with HiScTbl[i] do
      begin
         PlrName := 'PLAYER ONE';
         Score := 0;
      end;
   end;
   ReadHiScore;
   HiScoreRec := HiScTbl[1];
   ScCol := 1;
   GameOver := False;
   InitAllShapes;
   for x1:=1 to ScWidth do
      for x2:=1 to ScHeight do
      begin
         Bucket[x1,x2] := Empty;
      end;
   Randomize;
   Key := 'r';
   ValidKey := False;
   Freeze := False;
   ClrScr;
   DrawBox(ScCol, ScRow, ScWidth, ScHeight);
   RefreshScore;
   { list hi-score records on the screen }
   for i := 1 to 5 do
   begin
      GotoXY(InfoCol, i+2);
      write(i, '. ');
      with HiScTbl[i] do
      begin
         GotoXY(InfoCol+4, i+2);
         write(PlrName);
         GotoXY(InfoCol+30, i+2);
         write(Score);
      end;
   end;
   GotoXY(InfoCol, 15); write('MKTRIS Copyright (C) by Marek Karcz 2016-2018.');
   GotoXY(InfoCol+12, 16); write('All rights reserved.');
   {GotoXY(InfoCol, 18); write('<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>');}
   GotoXY(InfoCol+8, 20); write('< > - move left/right');
   GotoXY(InfoCol+8, 21); write('A Z - rotate left/right');
   GotoXY(InfoCol+8, 22); write('  X - drop piece');
   GotoXY(InfoCol+8, 23); write('  @ - pause/resume');
   GotoXY(InfoCol+8, 24); write('  E - exit');
   { Spawn 1st piece. }
   New(NewBlk);
   CurrBlk := NewBlk;
   if CurrBlk <> nil then
      with CurrBlk^ do
      begin
        Col := ScCol + 1;
        Row := ScRow;
        PrevCol := Col;
        PrevRow := Row;
        Repaint := True;
        ShNum := Random(7) + 1;  {random shape 1..7}
        SeqNum := Random(4) + 1; {random orientation / sequence 1..4}
        PrevSeqNum := -1;
      end;
   NewBlk := nil;
end;

{
  ---------------------------------------------------------
  Function checks if piece can be moved to the right.
  ---------------------------------------------------------
}
function CanMoveRight(prow, pcol, sn, rn : Integer) : Boolean;
var
   fret     : Boolean;
   cf       : Boolean; { is any row in column filled? }
   k        : Integer; { index - how far to the right piece is filled }
   row, col : Integer; { piece matrix indexes }
begin
   fret := False;
   k := 3;
   bl := Pieces[sn];
   sh := bl[rn];
   for col := 4 to 1 do
   begin
      row := 1;
      cf := False;
      while (row < 5) and (cf = False) do
      begin
         if sh[col, row] = Filled then cf := True;
         row := row + 1;
      end;
      if cf = False then k := k - 1;
   end;
   if (pcol + k) < (ScCol + ScWidth) then fret := True;
   if fret = True then
   begin
      row := prow - ScRow;
      col := pcol - ScCol - 1;
      if (col + 4) < ScWidth then
         while (row < (prow - Scrow + 4)) and (fret = True) do
         begin
            if (Bucket[col + 4 + 1, row + 1] = Filled)
               and
               (sh[4,row - (prow - ScRow) + 1] = Filled)
            then fret := False;
            row := row + 1;
         end;
   end;

   CanMoveRight := fret;
end;

{
  ---------------------------------------------------------
  Function checks if piece can be moved to the left.
  ---------------------------------------------------------
}
function CanMoveLeft(prow, pcol, sn, rn : Integer) : Boolean;
var
   fret     : Boolean;
   k        : Integer;
   col, row : Integer;
   cf       : Boolean;
begin
   fret := False;
   k := 0;
   bl := Pieces[sn];
   sh := bl[rn];
   for col := 1 to 4 do
   begin
      row := 1;
      cf := False;
      while (row < 5) and (cf = False) do
      begin
         if sh[col, row] = Filled then cf := True;
         row := row + 1;
      end;
      if cf = False then k := k + 1;
   end;
   if (pcol + k) > (ScCol + 1) then fret := True;
   if fret = True then
   begin
      row := prow - ScRow;
      col := pcol + k - ScCol - 1;
      if col > 1 then
         while (row < (prow - Scrow + 4)) and (fret = True) do
         begin
            if (Bucket[col - 1, row + 1] = Filled)
               and
               (sh[1 + k, row - (prow - ScRow) + 1] = Filled)
            then fret := False;
            row := row + 1;
         end;
   end;
   CanMoveLeft := fret;
end;

{
  ---------------------------------------------------------
  Function checks if piece can be rotated.
  ---------------------------------------------------------
}
function CanRotate(prow, pcol, sn, rn : Integer; rright : Boolean) : Boolean;
var
   fret     : Boolean;
   rot      : Integer;
   col, row : Integer;
   c, r     : Integer;
begin
   rot := rn;
   if rright then
   begin
      rot := rot + 1;
      if rot > 4 then rot := 1;
   end
   else
   begin
      rot := rot - 1;
      if rot < 1 then rot := 4;
   end;
   bl := Pieces[sn];
   sh := bl[rot];
   sh2 := bl[rn];
   fret := True;
   for c := 1 to 4 do
   begin
      col := pcol - ScCol + c - 1;
      for r := 1 to 4 do
      begin
         row := prow - ScRow + r;
         if (row > 0) and (row < ScHeight)
            and (col > 0) and (col < ScWidth) then
         begin
            if sh2[c, r] = Empty then
            begin
               if (sh[c, r] = Filled)
                   and (Bucket[col, row] = Filled) then fret := False;
            end;
         end
         else
         begin
            if sh[c, r] = Filled then fret := False;
         end;
      end;
   end;
   CanRotate := fret;
end;

{
  ---------------------------------------------------------
   Function checks if piece can descent one step lower.
  ---------------------------------------------------------
}
function CanGoLower(blkptr : PtrBlkInfo) : Boolean;
var
   fret   : Boolean;
   i,j    : Integer;
   prow   : Integer;
   pcol   : Integer;
begin
   fret := False;
   with blkptr^ do
   begin
      bl := Pieces[ShNum];
      sh := bl[SeqNum];
      prow := Row;
      pcol := Col;
   end;
   if (prow + 4) < (ScHeight + ScRow) then fret := True;
   { If the piece can go lower in the Bucket without consideration of }
   { other pieces, then now is the time to check for collisions with  }
   { remaining pieces on the Scene (Bucket). }
   if fret = True then
   begin
      { check collisions with the Filled blocks on the Scene / Bucket }
      for i:=0 to 3 do
         for j:=0 to 3 do
         begin
            if (Bucket[pcol+i-ScCol-1+1,prow+j+1-ScRow+1] = Filled)
                and
                (sh[i+1,j+1] = Filled) then
               fret := False;
         end;
   end;
   CanGoLower := fret;
end;

{
  ---------------------------------------------------------
  Reduce filled lines on the scene. Update score.
  ---------------------------------------------------------
}
procedure ReduceLines;
var
   PrevScore : Integer;
   row, col  : Integer;
   i, j      : Integer;
   bonus     : Integer;
   cont      : Boolean;
begin
   PrevScore := Score;
   bonus := 20;

   for row := 1 to ScHeight do
   begin
      col := 1;
      cont := True;
      while (col <= ScWidth) and (cont = True) do
      begin
         if Bucket[col,row] = Empty then cont := False
         else col := col + 1;
      end;
      if cont = True then { filled row detected }
      begin
         Score := Score + bonus;
         bonus := bonus * 2;
         { reduce filled line and shift the scene contents }
         for i := (row - 1) downto 1 do
            for j := 1 to ScWidth do
               Bucket[j,i+1] := Bucket[j,i];
         for j := 1 to ScWidth do Bucket[j,1] := Empty;
      end;
   end;

   if bonus > 20 then
   begin
      RepaintBucket;
      { increase falling speed, bacause player seems to be good at it }
      if (FallSpeed - 5) > 0 then FallSpeed := FallSpeed - 5;
   end;
   if Score <> PrevScore then RefreshScore;
end;

{
  ---------------------------------------------------------
   Update scene.
  ---------------------------------------------------------
}
procedure UpdScene;
var
  Blk:            PtrBlkInfo;
  i, j:           Integer;
  bktcol, bktrow: Integer;

begin

  Blk := CurrBlk;

  { refresh block if needed }

  if Blk <> nil then
     with Blk^ do
     begin
        if (Repaint = True) and (Freeze = False) then
        begin
           if PrevSeqNum > 0 then
              DispBlock(PrevCol,PrevRow,ShNum,PrevSeqNum,True,True)
           else
              DispBlock(PrevCol,PrevRow,ShNum,SeqNum,True,True);
           DispBlock(Col,Row,ShNum,SeqNum,False,True);
           PrevCol := Col;
           PrevRow := Row;
           PrevSeqNum := -1;
           Repaint := False;
        end;
     end;

  { if new piece was created in previous step, dispose of CurrBlk and }
  { replace it with the new piece                                     }

  if NewBlk <> nil then
  begin
     Dispose(CurrBlk);
     CurrBlk := NewBlk;
     NewBlk := nil;
     Exit;
  end;

  { perform block rotation }

  if (Blk <> nil) and (Freeze = False) then
     with Blk^ do
     begin

        { rotate +90 degrees }

        if ValidKey and (Key = 'z') then
        begin
           if CanGoLower(Blk) = True then
           begin
              if CanRotate(Row, Col, ShNum, SeqNum, True) = True then
              begin
                 Repaint := True;
                 PrevSeqNum := SeqNum;
                 SeqNum := SeqNum + 1;
                 if SeqNum > 4 then SeqNum := 1;
              end;
           end;
        end;

        { rotate -90 degrees }

        if ValidKey and (Key = 'a') then
        begin
           if CanGoLower(Blk) = True then
           begin
              if CanRotate(Row, Col, ShNum, SeqNum, False) = True then
              begin
                 Repaint := True;
                 PrevSeqNum := SeqNum;
                 SeqNum := SeqNum - 1;
                 if SeqNum < 1 then SeqNum := 4;
              end;
           end;
        end;

     end;

  { perform block falling down and left / right movement }

  if (Blk <> nil) and (Freeze = False) then
     with Blk^ do
     begin

        { move right }

        if ValidKey and (Key = '.') then
        begin
           if CanMoveRight(Row, Col, ShNum, SeqNum) = True then
           begin
              Col := Col + 1;
              Repaint := True;
           end;
        end;

        { move left }

        if ValidKey and (Key = ',') then
        begin
           if CanMoveLeft(Row, Col, ShNum, SeqNum) = True then
           begin
              Col := Col - 1;
              Repaint := True;
           end;
        end;

        { drop }

        if ValidKey and (Key = 'x') then
        begin
           while CanGoLower(Blk) do
           begin
              Row := Row + 1;
              if (Freeze = False) then
              begin
                 DispBlock(PrevCol,PrevRow,ShNum,SeqNum,True,True);
                 DispBlock(Col,Row,ShNum,SeqNum,False,True);
                 PrevCol := Col;
                 PrevRow := Row;
              end;
           end;
        end;

        if CanGoLower(Blk) = True then
        begin
           Row := Row + 1;
           Repaint := True;
        end
        else { if piece can't go lower, map it to the scene and create new piece }
        begin
           bl := Pieces[ShNum];
           sh := bl[SeqNum];
           for i:=1 to 4 do
              for j:=1 to 4 do
              begin
                 bktcol := Col + j - 1 - ScCol - 1 + 1;
                 bktrow := Row + i - 1 - ScRow + 1;
                 if (bktcol <= ScWidth) and (bktrow <= ScHeight) then
                    if (bktcol > 0) and (bktrow > 0) then
                       if sh[j,i] = Filled then
                       begin
                          {if Bucket[bktcol,bktrow] = Empty then}
                          if Row > ScRow then
                             Bucket[bktcol,bktrow] := Filled
                          else GameOver := True;
                       end;
              end;
           if GameOver = True then Exit;
           ReduceLines; { reduce filled lines, update score }
           New(NewBlk);
           if NewBlk <> nil then
              with NewBlk^ do
              begin
                 Col := ScCol + 1 + Random(ScWidth - 4);
                 Row := ScRow;
                 PrevRow := Row;
                 PrevCol := Col;
                 ShNum := Random(7) + 1;
                 SeqNum := Random(4) + 1;
                 Repaint := True;
                 PrevSeqNum := -1;
              end;
        end;

    end;

    if ValidKey and (Key = '@') then
    begin
       { toggle freeze flag }
       if Freeze = True then
       begin
          Freeze := False;
          GotoXY(InfoCol, 10);
          write('           ');
       end
       else
       begin
          Freeze := True;
          GotoXY(InfoCol, 10);
          write('GAME PAUSED');
       end;
    end;

end;

{
 ---------------------------------------------------------
  Get input from player (keyboard).
  Previous key must be consumed before new read is
  allowed.
 ---------------------------------------------------------
}
procedure GetInput;
var
   LocKey: Char;
   KPress: Boolean;
begin
   LocKey := 'r'; { undefined }
   KPress := False;
   { always consume HW keyboard key }
   if KeyPressed then
   begin
      Read(Kbd,LocKey);
      KPress := True;
   end;
   if (ValidKey = False) and KPress then
   begin
      Key := LocKey;
      ValidKey := True;
   end;
end;

{
 ---------------------------------------------------------
  Check game-end condition.
 ---------------------------------------------------------
}
function GameEnd : Boolean;
var
   Ret: Boolean;
   i: Integer;
begin
   Ret := False;
   if ValidKey and (Key = 'e') then
   begin
      GotoXY(InfoCol, 12);
      write('Are you sure (Y/N)?');
      repeat until KeyPressed;
      Read(Kbd, Key);
      if (Key = 'y') or (Key = 'Y') then
      begin
         Ret := True;
      end;
      GotoXY(InfoCol, 12);
      for i := 1 to 20 do write(' ');
   end;
   Ret := Ret or GameOver;
   GameEnd := Ret;
end;

{
   ------------------------------------------------------------------
   Shift contents of hi-score table down and put new hi score on top.
   ------------------------------------------------------------------
}

procedure ShftScoreTbl(pn: PlName; scre: Integer);
var
   i: Integer;
   {n: PlName;
   s: Integer;}
begin
   for i := 5 downto 2 do
   begin
      HiScTbl[i] := HiScTbl[i-1];
      {
      with HiScTbl[i-1] do
      begin
         n := PlrName;
         s := Score;
      end;
      with HiScTbl[i] do
      begin
         PlrName := n;
         Score := s;
      end;
      }
   end;
   with HiScTbl[1] do
   begin
      PlrName := pn;
      Score := scre;
   end;
end;

{ --------------------- MAIN PROGRAM ---------------- }

begin

   Pretty := False;
   SolidBlocks := False;
   PlayerName := 'PLAYER ONE';
   writeln('Welcome to MKTRIS.');
   if ParamCount > 0 then
   begin
      for i := 1 to ParamCount do
      begin
         if ParamStr(i) = '-P' then Pretty := True
         else
         begin
            if ParamStr(i) = '-S' then SolidBlocks := True
            else
               PlayerName := ParamStr(i);
         end;
      end;
   end
   else
   begin
      writeln('MKTRIS usage:');
      writeln('   mktris [PlayerName] {[-p] [-s]}');
      writeln('Only on C-128 or platform that supports ADM31 terminal codes:');
      writeln('  -p - use solid (reverse color) lines to paint scene');
      writeln('  -s - use solid (reverse color) lines to paint blocks');
   end;
   if PlayerName = 'PLAYER ONE' then
   begin
      write('Please enter your name: ');
      readln(PlayerName);
   end;
   writeln('Hello ', PlayerName, '!');
   writeln('Have fun!');
   Delay(2000);
   InitGame;
   while ((not GameEnd) and (not GameOver)) do
   begin
      if (Frame mod FallSpeed) = 0 then
      begin
         UpdScene;
         if Frame > 30000 then Frame := 0;
         ValidKey := False;
      end;
      if GameOver then
      begin
         i := Score;
         with HiScTbl[1] do
         begin
            if i > Score then
            begin
               with HiScoreRec do
               begin
                  PlrName := PlayerName;
                  Score := i;
               end;
               GotoXY(InfoCol, 11);
               write('Updating hi-score file...');
               ShftScoreTbl(PlayerName, i);
               WriteHiScore;
               GotoXY(InfoCol, 11);
               write('                         ');
            end;
         end;
         {if Score > HiScore then WriteHiScore(Score);}
         GotoXY(InfoCol, 10);
         if Pretty then write(Chr(27), 'G2');
         write('*** G A M E   O V E R ***');
         if Pretty then write(Chr(27), 'G0');
         GotoXY(InfoCol, 12);
         write('Play again? (Y/N)');
         Key := 'r';
         while ((Key <> 'y') and (Key <> 'n')) do
         begin
            repeat until KeyPressed;
            Read(Kbd, Key);
         end;
         if Key = 'y' then
         begin
            Dispose(CurrBlk);
            InitGame;
         end;
      end;
      GetInput;
      Delay(RefrRate);
      Frame := Frame + 1;
   end;
   ClrScr;
   writeln('Thank you for playing!');
   writeln;
end.