{$mode objfpc}{$H+}
uses Sysutils, Classes; 

const largeur=130;
      hauteur=130;

type tuile=record
          surface:char;
          visited:boolean;
     end;

var
  myFile : TextFile;
  line: string;
  plateau:array[1..largeur,1..hauteur] of tuile;
  a,b,posx,posy:integer;
  sensdeplacement:byte;
  sortie:boolean;
  total:integer;


procedure deplace(x,y:integer);
begin
  posx:=x;
  posy:=y;
  plateau[posx,posy].visited:=true;
end;

procedure tourneadroitepetitcon;
begin
  inc(sensdeplacement);
  if sensdeplacement>4 then sensdeplacement:=1;
end;

begin
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  for b:=1 to hauteur do
  begin
    ReadLn(myFile, line);
    for a:=1 to largeur do
    begin
      if line[a]<>'^' then 
      begin
        plateau[a,b].surface:=line[a];
        plateau[a,b].visited:=false;
      end
      else
      begin
         plateau[a,b].surface:='.';
         plateau[a,b].visited:=true;
         posx:=a;
         posy:=b;
         sensdeplacement:=1;
      end;
    end;
  end;
  Closefile(myFile);
  sortie:=false;
  writeln('On demarre le parcours en position : '+IntToStr(posx)+' - '+inttostr(posy));
  repeat
    // on va vert le haut
    if sensdeplacement=1 then
    begin
      if posy=1 then sortie:=true else if plateau[posx,posy-1].surface='.' then deplace(posx,posy-1) else tourneadroitepetitcon;
    end;

    // on va vert la droite
    if sensdeplacement=2 then
    begin
      if posx=largeur then sortie:=true else if plateau[posx+1,posy].surface='.' then deplace(posx+1,posy) else tourneadroitepetitcon;
    end;

    // on va vert le bas
    if sensdeplacement=3 then
    begin
      if posy=hauteur then sortie:=true else if plateau[posx,posy+1].surface='.' then deplace(posx,posy+1) else tourneadroitepetitcon;
    end;

    // on va vert la gauche
    if sensdeplacement=4 then
    begin
      if posx=1 then sortie:=true else if plateau[posx-1,posy].surface='.' then deplace(posx-1,posy) else tourneadroitepetitcon;
    end;
    //writeln(IntToStr(posx)+' - '+inttostr(posy));
  until sortie=true;

  total:=0;
  // on compte le nb de tuiles visitees
  for b:=1 to hauteur do
    for a:=1 to hauteur do  
      if plateau[a,b].visited=true then inc(total);
  
  Writeln('Nombre de tuiles visitees : '+inttostr(total));
end.