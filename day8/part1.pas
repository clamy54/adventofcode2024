{$mode objfpc}{$H+}
uses Sysutils, Classes; 

const largeur=50;
      hauteur=50;
      nomfichier='input.txt';

type tuile=record
          surface:char;
          antinode:boolean;
     end;

var myFile : TextFile;
    carte:array[1..largeur,1..hauteur] of tuile;


function CountAntinodes():integer;
var x,y:integer;

begin
  CountAntinodes:=0;
  for y:=1 to hauteur do
  begin
    for x:=1 to largeur do
    begin
      if carte[x,y].antinode=true then inc(CountAntinodes);
    end;
  end;
end;

procedure AfficheCarte();
var x,y:integer;

begin
  for y:=1 to hauteur do
  begin
    for x:=1 to largeur do
    begin
      Write(carte[x,y].surface);
    end;
    Writeln();
  end;
end;

procedure Loadfile(nom:string);
var a,b:integer;
    line:string;

begin
  AssignFile(myFile, nom);
  Reset(myFile);
  for b:=1 to hauteur do
  begin
    ReadLn(myFile, line);
    if length(line)>=largeur then for a:=1 to largeur do 
    begin
      carte[a,b].surface:=line[a];
      carte[a,b].antinode:=false;
    end;
    if Eof(myFile) then break;
  end;
  Closefile(myFile);
end;

procedure SearchAntinodes;
var x,y:integer;
    anx,any,distx,disty:integer;
    C:char;

begin
  for y:=1 to hauteur do
  begin
    for x:=1 to largeur do
    begin
      C:=carte[x,y].surface;
      if (C<>'.') and (C<>'#') then
      begin
        if x=largeur then 
        begin
          distx:=1;
          if y<>hauteur then disty:=y+1 else break;
        end
        else
        begin
          distx:=x+1;
          disty:=y;
        end;
        repeat
          if distx>largeur then
          begin
            distx:=1;
            inc(disty);
          end;
          if carte[distx,disty].surface=C then
          begin
            // first antinode
            anx:=x-(distx-x);
            any:=y-(disty-y);
            if (anx>=1) and (anx<=largeur) and (any>=1) and (any<=hauteur) then 
            begin
              if carte[anx,any].surface='.' then carte[anx,any].surface:='#';
              carte[anx,any].antinode:=true;
            end;
            // second antinode
            anx:=distx+(distx-x);
            any:=disty+(disty-y);
            if (anx>=1) and (anx<=largeur) and (any>=1) and (any<=hauteur) then 
            begin
              if carte[anx,any].surface='.' then carte[anx,any].surface:='#';
              carte[anx,any].antinode:=true;
            end;
          end;
          inc(distx);
        until (distx=largeur+1) and (disty=hauteur);
      end; 
    end;
  end;
end;


begin
  Loadfile(nomfichier);
  AfficheCarte;
  Writeln();
  Writeln('======== RESOLUTION ========');
  Writeln();
  SearchAntinodes;
  AfficheCarte;
  Writeln();
  Writeln('Number of antinodes : '+inttostr(CountAntinodes()));
end.
