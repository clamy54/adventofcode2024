{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt; 

const nomfichier='input.txt';

type tuile=record
          valeur:char;
          visited:boolean;
          numfigure:Integer;
     end;

var  carte:array of array of tuile;
     largeur,hauteur:Integer;
     prix:Integer;
     airetemp,nbcote:Integer;
     currentnumfigure:Integer;
     debug:Boolean;

procedure DisplayMap;
var a,b:Integer;
Begin
  for b:=0 to hauteur-1 do 
  begin
    for a:=0 to largeur-1 do 
    begin
      if (carte[a,b]).visited=true then
      begin
       if (carte[a,b]).numfigure=666 then TextColor(red) else  TextColor(carte[a,b].numfigure);
      End
      else TextColor(DarkGray);
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
  largeur:=a+2;
  hauteur:=b+2;
  // dimensionnement du tableau
  SetLength(carte, largeur, hauteur);

  for a:=0 to largeur-1 do
  begin
    carte[a,0].valeur:='.';
    carte[a,hauteur-1].valeur:='.';
    carte[a,0].visited:=True;
    carte[a,hauteur-1].visited:=true;
    carte[a,0].numfigure:=666;
    carte[a,hauteur-1].numfigure:=666;
  end;
  for a:=0 to hauteur-1 do
  begin
    carte[0,a].valeur:='.';
    carte[largeur-1,a].valeur:='.';
    carte[0,a].visited:=True;
    carte[largeur-1,a].visited:=true;
    carte[0,a].numfigure:=666;
    carte[largeur-1,a].numfigure:=666;
  end;

  // Second passage pour mettre les donnees dans le tableau
  Reset(myFile);
  b:=1;
  repeat
    ReadLn(myFile, line);
    for a:=1 to Length(line) do 
    begin
      carte[a,b].valeur:=line[a];
      carte[a,b].visited:=False;
    end;
    inc(b);
   until (eof(myFile));
  Closefile(myFile); 
end;

procedure Explore(a,b:Integer);
begin
  if carte[a,b].visited=false then
  begin
     carte[a,b].visited:=true;   
     carte[a,b].numfigure:=currentnumfigure; 
     inc(airetemp);
     if (a>0) and  (carte[a-1,b].visited=False) and (carte[a-1,b].valeur=carte[a,b].valeur) then Explore(a-1,b);
     if (a<largeur-1) and  (carte[a+1,b].visited=False) and (carte[a+1,b].valeur=carte[a,b].valeur)  then Explore(a+1,b);
     if (b>0) and  (carte[a,b-1].visited=False) and (carte[a,b-1].valeur=carte[a,b].valeur) then Explore(a,b-1);
     if (b<hauteur-1) and  (carte[a,b+1].visited=False) and (carte[a,b+1].valeur=carte[a,b].valeur) then Explore(a,b+1);
  end;
end;

function CompteCote(numfig:integer):integer;
var a,b:Integer;

begin
  CompteCote:=0;
  for b:=0 to hauteur-2 do 
  begin
    for a:=0 to largeur-2 do 
    begin
        //  ..
        //  .X
        if (carte[a+1,b+1].numfigure=numfig) and (carte[a,b].numfigure<>numfig) and (carte[a+1,b].numfigure<>numfig) and (carte[a,b+1].numfigure<>numfig) then CompteCote:=CompteCote+1;

        //  ..
        //  x.
        if (carte[a,b+1].numfigure=numfig) and (carte[a+1,b].numfigure<>numfig) and (carte[a+1,b+1].numfigure<>numfig) and (carte[a,b].numfigure<>numfig) then CompteCote:=CompteCote+1;

        //  .X
        //  ..
        if (carte[a+1,b].numfigure=numfig) and (carte[a,b].numfigure<>numfig) and (carte[a,b+1].numfigure<>numfig) and (carte[a+1,b+1].numfigure<>numfig) then CompteCote:=CompteCote+1;

        //  X.
        //  ..
        if (carte[a,b].numfigure=numfig) and (carte[a+1,b].numfigure<>numfig) and (carte[a,b+1].numfigure<>numfig) and (carte[a+1,b+1].numfigure<>numfig) then CompteCote:=CompteCote+1;

        //  X.
        //  .X
        if (carte[a,b].numfigure=numfig) and (carte[a+1,b+1].numfigure=numfig) and (carte[a+1,b].numfigure<>numfig) and (carte[a,b+1].numfigure<>numfig) then CompteCote:=CompteCote+2;

        //  .X
        //  X.
        if (carte[a+1,b].numfigure=numfig) and (carte[a,b+1].numfigure=numfig) and (carte[a,b].numfigure<>numfig) and (carte[a+1,b+1].numfigure<>numfig) then CompteCote:=CompteCote+2;


        //  X.
        //  XX
        if (carte[a,b].numfigure=numfig) and (carte[a+1,b+1].numfigure=numfig) and (carte[a,b+1].numfigure=numfig) and (carte[a+1,b].numfigure<>numfig) then CompteCote:=CompteCote+1;

        //  XX
        //  .X
        if (carte[a,b].numfigure=numfig) and (carte[a+1,b+1].numfigure=numfig) and (carte[a+1,b].numfigure=numfig) and (carte[a,b+1].numfigure<>numfig) then CompteCote:=CompteCote+1;

        //  XX
        //  X.
        if (carte[a,b].numfigure=numfig) and (carte[a+1,b].numfigure=numfig) and (carte[a,b+1].numfigure=numfig) and (carte[a+1,b+1].numfigure<>numfig) then CompteCote:=CompteCote+1;

        //  .X
        //  XX
        if (carte[a,b].numfigure<>numfig) and (carte[a+1,b].numfigure=numfig) and (carte[a,b+1].numfigure=numfig) and (carte[a+1,b+1].numfigure=numfig) then CompteCote:=CompteCote+1;

    end; 
  end;  
end;



procedure Inspecte;
var a,b:Integer;
    
begin
  prix:=0;
  currentnumfigure:=1;
  for b:=0 to hauteur-1 do 
  begin
    for a:=0 to largeur-1 do 
    begin
      if carte[a,b].visited=false then
      begin
        airetemp:=0;
        nbcote:=0;
        Explore(a,b);
        if debug=true then DisplayMap;
        nbcote:=CompteCote(currentnumfigure);     
        inc(currentnumfigure);
        if debug=true then writeln('Terrain '+carte[a,b].valeur+'  Aire : '+IntToStr(airetemp)+'  Nb cote : '+IntToStr(nbcote));
        if debug=true then readln;
        if (airetemp>0 )and (nbcote>0) then prix:=prix+(airetemp*nbcote);
      end;
    end;
  end;
  
end;

begin
  debug:=false;
  if ParamCount>0 then if LowerCase(ParamStr(1))='--debug' then debug:=true;
  ClrScr;
  Loadfile(nomfichier);
  //DisplayMap;
  Inspecte;
  Writeln('Price : '+IntToStr(prix));
end.  