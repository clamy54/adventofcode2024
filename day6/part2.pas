{$mode objfpc}{$H+}
uses Sysutils, Classes; 

const largeur=130;
      hauteur=130;

type tuile=record
          surface:char;
          visited:boolean;
          sensdejavisite:byte;
     end;

var
  myFile : TextFile;
  line: string;
  plateau:array[1..largeur,1..hauteur] of tuile;
  a,b,startx,starty:integer;
  total:integer;
  boucle:Boolean;


function testeplateau(obstaclex,obstacley:Integer):Boolean;
var plateautest:array[1..largeur,1..hauteur] of tuile;
    sortie:boolean;
    locala,localb,posx,posy:Integer;
    sensdeplacement:byte;

  procedure deplace(x,y:integer);
  begin
    
    posx:=x;
    posy:=y;
    if plateautest[posx,posy].visited=true then 
    begin
      if plateautest[posx,posy].sensdejavisite=sensdeplacement then boucle:=true;
    End
    else
    begin
      plateautest[posx,posy].visited:=true
    end;
  end;

  procedure tourneadroitepetitcon;
  begin
    inc(sensdeplacement);
    if sensdeplacement>4 then sensdeplacement:=1;
  end;


begin
  sensdeplacement:=1;
  sortie:=false;
  boucle:=false;
  posx:=startx;
  posy:=starty;
  // recopie du tableau original
  for localb:=1 to hauteur do
    for locala:=1 to hauteur do  
    begin
      plateautest[locala,localb].surface:=plateau[locala,localb].surface;
      plateautest[locala,localb].visited:=plateau[locala,localb].visited;
      plateautest[locala,localb].sensdejavisite:=plateau[locala,localb].sensdejavisite;
  end;  
  // on place le nouvel obstacle
  plateautest[obstaclex,obstacley].surface:='O';
  repeat
    // on va vert le haut
    if plateautest[posx,posy].sensdejavisite=0 then plateautest[posx,posy].sensdejavisite:=sensdeplacement;
    if sensdeplacement=1 then
    begin
      if posy=1 then sortie:=true else if plateautest[posx,posy-1].surface='.' then
      begin
       deplace(posx,posy-1);
      End
      else tourneadroitepetitcon;
    end;

    // on va vert la droite
    if sensdeplacement=2 then
    begin
      if posx=largeur then sortie:=true else if plateautest[posx+1,posy].surface='.' then
      begin
       deplace(posx+1,posy); 
      end
      else tourneadroitepetitcon;
    end;

    // on va vert le bas
    if sensdeplacement=3 then
    begin
      if posy=hauteur then sortie:=true else if plateautest[posx,posy+1].surface='.' then 
      begin
       deplace(posx,posy+1); 
      End
      else tourneadroitepetitcon;
    end;

    // on va vert la gauche
    if sensdeplacement=4 then
    begin
      if posx=1 then sortie:=true else if plateautest[posx-1,posy].surface='.' then
      begin
       deplace(posx-1,posy);
      end
      else tourneadroitepetitcon;
    end;
  until (sortie=true) or (boucle=true);
  testeplateau:=boucle;
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
        plateau[a,b].sensdejavisite:=0;
      end
      else
      begin
         plateau[a,b].surface:='.';
         plateau[a,b].visited:=true;
         plateau[a,b].sensdejavisite:=1;
         startx:=a;
         starty:=b;
      end;
    end;
  end;
  Closefile(myFile);
  writeln('On demarre le parcours en position : '+IntToStr(startx)+' - '+inttostr(starty));
  total:=0;
  for b:=1 to hauteur do
    for a:=1 to hauteur do  
    begin
      if plateau[a,b].surface='.' then
      begin
       if testeplateau(a,b)=true then inc(total);
      end;
    end;
  Writeln('Nombre d obstacles possibles : '+inttostr(total));
end.