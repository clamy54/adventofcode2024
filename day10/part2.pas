{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt; 

const nomfichier='input.txt';
      hauteur=54;
      largeur=54;

type tuile=record
          valeur:char;
          visited:boolean;
     end;

var  carte:array[1..largeur,1..hauteur] of tuile;
     myFile : TextFile;
     score:integer;


procedure initVisited;
var a,b:integer;
begin
  for b:=1 to hauteur do
    for a:=1 to largeur do
      carte[a,b].visited:=false;
end;

procedure majScore;
var a,b:integer;
begin
  for b:=1 to hauteur do
    for a:=1 to largeur do
      if (carte[a,b].visited=true) and (carte[a,b].valeur='9') then inc(score);
end;

procedure displaymap;
var a,b:integer;
begin
  for b:=1 to hauteur do
  begin
    for a:=1 to largeur do
    begin
      if (carte[a,b].visited=true) then Textcolor(Red) else Textcolor(white);
      write(carte[a,b].valeur);
    end;
    writeln();
  end;
  writeln();
end;

procedure displaycurrentposition(x,y:integer);
var a,b:integer;
begin
  for b:=1 to hauteur do
  begin
    for a:=1 to largeur do
    begin
      if (a=x) and (b=y) then Textcolor(Red) else Textcolor(white);
      write(carte[a,b].valeur);
    end;
    writeln();
  end;
  writeln();
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
    for a:=1 to largeur do carte[a,b].valeur:=line[a];    
  end;
  Closefile(myFile);
end;

procedure visit(a,b:integer);
var valeur,valeurvoisine:Integer;
begin
  if (carte[a,b].valeur='9')  then
  begin
    inc(score);
    if (carte[a,b].visited=false)  then
    begin
     carte[a,b].visited:=true;
    end;
  end
  else
  begin 
    valeur:=StrToInt(carte[a,b].valeur);
    // gauche
    if a>1 then 
    begin
      if carte[a-1,b].valeur<>'.' then 
      begin
        valeurvoisine:=StrToInt(carte[a-1,b].valeur);
        if valeurvoisine=valeur+1 then visit(a-1,b);
      end;
    end; 
    // haut
    if b>1 then 
    begin
      if carte[a,b-1].valeur<>'.' then 
      begin
        valeurvoisine:=StrToInt(carte[a,b-1].valeur);
        if valeurvoisine=valeur+1 then visit(a,b-1);
      end;
    end;    
    // droit
    if a<largeur then 
    begin
      if carte[a+1,b].valeur<>'.' then 
      begin     
        valeurvoisine:=StrToInt(carte[a+1,b].valeur);
        if valeurvoisine=valeur+1 then visit(a+1,b);
      end;
    end;    
    // bas
    if b<hauteur then 
    begin
      if carte[a,b+1].valeur<>'.' then 
      begin
        valeurvoisine:=StrToInt(carte[a,b+1].valeur);
        if valeurvoisine=valeur+1 then visit(a,b+1);
      end;
    end;   
  end;
end;

procedure findpath;
var a,b:integer;
begin
  score:=0;
   for b:=1 to hauteur do
    for a:=1 to largeur do
    begin
      if carte[a,b].valeur='0' then
      begin
        initVisited;
        visit(a,b);
      end;
    end; 
end;

begin
  Loadfile(nomfichier);
  findpath;
  Textcolor(Yellow);
  Writeln('Score : '+IntToStr(score));
end.