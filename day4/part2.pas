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
  // M   S
  //   A
  // M   S
  if (puzzle[posy][posx]='A') and (puzzle[posy-1][posx-1]='M') and (puzzle[posy-1][posx+1]='S') and (puzzle[posy+1][posx-1]='M') and (puzzle[posy+1][posx+1]='S') then inc(compteur);


  // M   M
  //   A
  // S   S
  if (puzzle[posy][posx]='A') and (puzzle[posy-1][posx-1]='M') and (puzzle[posy-1][posx+1]='M') and (puzzle[posy+1][posx-1]='S') and (puzzle[posy+1][posx+1]='S') then inc(compteur);

  // S   M
  //   A
  // S   M
  if (puzzle[posy][posx]='A') and (puzzle[posy-1][posx-1]='S') and (puzzle[posy-1][posx+1]='M') and (puzzle[posy+1][posx-1]='S') and (puzzle[posy+1][posx+1]='M') then inc(compteur);


  // S   S
  //   A
  // M   M
  if (puzzle[posy][posx]='A') and (puzzle[posy-1][posx-1]='S') and (puzzle[posy-1][posx+1]='S') and (puzzle[posy+1][posx-1]='M') and (puzzle[posy+1][posx+1]='M') then inc(compteur);
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
  for y:=2 to hauteur-1 do
  begin
    for x:=2 to largeur-1 do
    begin
      if puzzle[y][x]='A' then checkifxmas(x,y);
    end;
  end;
  writeln('XMAS appears '+inttostr(compteur)+' times');
end.