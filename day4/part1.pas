{$mode objfpc}{$H+}
uses Sysutils, Classes; 

const  largeur=140;
       hauteur=140;

var puzzle:array[1..hauteur] of string;
    dummy:integer;
    x,y,compteur:integer;
    myFile : TextFile;


procedure  checkifxmas(posx,posy:integer);
begin
  // XMAS
  if posx<largeur-2 then 
  begin
   if (puzzle[posy][posx]='X') and (puzzle[posy][posx+1]='M') and (puzzle[posy][posx+2]='A') and (puzzle[posy][posx+3]='S') then inc(compteur);
  end;

  // SAMX
  if posx>3 then 
  begin
   if (puzzle[posy][posx]='X') and (puzzle[posy][posx-1]='M') and (puzzle[posy][posx-2]='A') and (puzzle[posy][posx-3]='S') then inc(compteur);
  end;

  //  X
  //  M
  //  A
  //  S
  if posy<hauteur-2 then 
  begin
   if (puzzle[posy][posx]='X') and (puzzle[posy+1][posx]='M') and (puzzle[posy+2][posx]='A') and (puzzle[posy+3][posx]='S') then inc(compteur);
  end;

  //  S
  //  A
  //  M
  //  X
  if posy>3 then 
  begin
   if (puzzle[posy][posx]='X') and (puzzle[posy-1][posx]='M') and (puzzle[posy-2][posx]='A') and (puzzle[posy-3][posx]='S') then inc(compteur);
  end;

  //  X
  //   M
  //    A
  //     S
  if (posx<largeur-2) and (posy<hauteur-2) then
  begin
   if (puzzle[posy][posx]='X') and (puzzle[posy+1][posx+1]='M') and (puzzle[posy+2][posx+2]='A') and (puzzle[posy+3][posx+3]='S') then inc(compteur);
  end;

  //    X
  //   M
  //  A
  // S
  if (posx>3) and (posy<hauteur-2) then
  begin
   if (puzzle[posy][posx]='X') and (puzzle[posy+1][posx-1]='M') and (puzzle[posy+2][posx-2]='A') and (puzzle[posy+3][posx-3]='S') then inc(compteur);
  end;

  //  S
  //   A
  //    M
  //     X
  if (posx>3) and (posy>3) then
  begin
   if (puzzle[posy][posx]='X') and (puzzle[posy-1][posx-1]='M') and (puzzle[posy-2][posx-2]='A') and (puzzle[posy-3][posx-3]='S') then inc(compteur);
  end;

  //    S
  //   A
  //  M
  // X
  if (posx<largeur-2) and (posy>3) then
  begin
   if (puzzle[posy][posx]='X') and (puzzle[posy-1][posx+1]='M') and (puzzle[posy-2][posx+2]='A') and (puzzle[posy-3][posx+3]='S') then inc(compteur);
  end;
end;


begin
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  for dummy:=1 to hauteur do
  begin
    ReadLn(myFile, puzzle[dummy]);
  end;
  Closefile(myFile);
  compteur:=0;
  x:=1;
  y:=1;
  for y:=1 to hauteur do
  begin
    for x:=1 to largeur do
    begin
      if puzzle[y][x]='X' then checkifxmas(x,y);
    end;
  end;
  writeln('XMAS appears '+inttostr(compteur)+' times');
end.