{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt; 

const nomfichier='input.txt';

type tuile=record
          valeur:char;
          visited:boolean;
     end;

var  carte:array of array of tuile;
     largeur,hauteur:Integer;
     prix:Integer;
     airetemp,perimtemp:Integer;

procedure DisplayMap;
var a,b:Integer;
Begin
  for b:=0 to hauteur-1 do 
  begin
    for a:=0 to largeur-1 do 
    begin
      if (carte[a,b]).visited=true then TextColor(red) else TextColor(White);
      write(carte[a,b].valeur);
    end;
    writeln();
  end;
   writeln();
  TextColor(LightGray);
end;


procedure Loadfile(nom:string);
var a,b:integer;
    line:string;
    myFile : TextFile;
 
begin
  a:=0;
  b:=0;
  // Premier passage pour dimensionner le tableau dynamique
  AssignFile(myFile, nom);
  Reset(myFile);
  repeat
    ReadLn(myFile, line);
    inc(b);
    if Length(line)>a then a:=Length(line);
  until (eof(myFile));
  Closefile(myFile);
  largeur:=a;
  hauteur:=b;
  // dimensionnement du tableau
  SetLength(carte, largeur, hauteur);
  // Second passage pour mettre les donnees dans le tableau
  Reset(myFile);
  b:=0;
  repeat
    ReadLn(myFile, line);
    for a:=1 to Length(line) do 
    begin
      carte[a-1,b].valeur:=line[a];
      carte[a-1,b].visited:=False;
    end;
    inc(b);
   until (eof(myFile));
  Closefile(myFile); 
end;

procedure Explore(a,b:Integer);
var pt:Integer;
begin
  if carte[a,b].visited=false then
  begin
     pt:=0;
     carte[a,b].visited:=true;   
     if a=0 then inc(pt) else if  carte[a-1,b].valeur<>carte[a,b].valeur then inc(pt);
     if b=0 then inc(pt) else if  carte[a,b-1].valeur<>carte[a,b].valeur then inc(pt);
     if a=largeur-1 then inc(pt) else if  carte[a+1,b].valeur<>carte[a,b].valeur then inc(pt);
     if b=hauteur-1 then inc(pt)  else if  carte[a,b+1].valeur<>carte[a,b].valeur then inc(pt);
     perimtemp:=perimtemp+pt;
     inc(airetemp);
     if (a>0) and  (carte[a-1,b].visited=False) and (carte[a-1,b].valeur=carte[a,b].valeur) then Explore(a-1,b);
     if (a<largeur-1) and  (carte[a+1,b].visited=False) and (carte[a+1,b].valeur=carte[a,b].valeur)  then Explore(a+1,b);
     if (b>0) and  (carte[a,b-1].visited=False) and (carte[a,b-1].valeur=carte[a,b].valeur) then Explore(a,b-1);
     if (b<hauteur-1) and  (carte[a,b+1].visited=False) and (carte[a,b+1].valeur=carte[a,b].valeur) then Explore(a,b+1);
  end;
end;



procedure Inspecte;
var a,b:Integer;

begin
  prix:=0;
  for b:=0 to hauteur-1 do 
  begin
    for a:=0 to largeur-1 do 
    begin
      if carte[a,b].visited=false then
      begin
        airetemp:=0;
        perimtemp:=0;
        Explore(a,b);
        // DisplayMap;
        if (airetemp>0 )and (perimtemp>0) then prix:=prix+(airetemp*perimtemp);
      end;
    end;
  end;
  
end;

begin
  ClrScr;
  Loadfile(nomfichier);
  DisplayMap;
  Inspecte;
  Writeln('Price : '+IntToStr(prix));
end.  