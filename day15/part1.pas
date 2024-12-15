{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt; 

const nomfichier='input.txt';

type tuile=record
          valeur:char;
          visited:boolean;
     end;

     droid=record
        x,y:integer;
     end;


var  carte:array of array of tuile;
     commandes: array of string;
     nbcommandes,largeur,hauteur:Integer;
     robot:droid;
     a,cpt:integer;     


procedure Loadfile(nom:string);
var a,b,c:integer;
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
    if line<>'' then
    begin
      inc(b);
      if Length(line)>a then a:=Length(line);
    end;
  until (line='');
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
    if line<>'' then
    begin   
      for a:=1 to Length(line) do 
      begin
        if line[a]<>'@' then
        begin
          carte[a-1,b].valeur:=line[a];
          carte[a-1,b].visited:=False;
        end
        else
        begin
          carte[a-1,b].valeur:='.';
          carte[a-1,b].visited:=true;
          robot.x:=a-1;
          robot.y:=b;
        end;
      end;
      inc(b);
    end;
  until (line='');
  c:=0;
  repeat
    ReadLn(myFile, line);
    if line<>'' then
    begin
      inc(c);
      SetLength(commandes,c);
      commandes[c-1]:=line;
    end;
  until eof(myFile);
  nbcommandes:=c;
  Closefile(myFile); 
end;

procedure DisplayMap;
var a,b:Integer;
Begin
  for b:=0 to hauteur-1 do 
  begin
    for a:=0 to largeur-1 do 
    begin
      if (carte[a,b]).visited=true then TextColor(red) else TextColor(White);
      if (a=robot.x) and (b=robot.y) then write('@') else write(carte[a,b].valeur);
    end;
    writeln();
  end;
   writeln();
  TextColor(LightGray);
end;


procedure DoMove(direction:char);
var dummy:integer;
begin
  if direction='<' then
  begin
    if robot.x>0 then
    begin
      if carte[(robot.x)-1,robot.y].valeur='.' then
      begin
        dec(robot.x);
        carte[robot.x,robot.y].visited:=true;
      end
      else
      begin
        if carte[(robot.x)-1,robot.y].valeur='O' then
        begin
          dummy:=robot.x;
          repeat
            dec(dummy);
          until (carte[dummy,robot.y].valeur='.') or (carte[dummy,robot.y].valeur='#');
          if (carte[dummy,robot.y].valeur='.') then
          begin
            carte[dummy,robot.y].valeur:='O';
            dec(robot.x);
            carte[robot.x,robot.y].visited:=true;
            carte[robot.x,robot.y].valeur:='.';
          end;
        end;
      end;
    end;
  end;

  if direction='>' then
  begin
    if robot.x<largeur-1 then
    begin
      if carte[(robot.x)+1,robot.y].valeur='.' then
      begin
        inc(robot.x);
        carte[robot.x,robot.y].visited:=true;
      end
      else
      begin
        if carte[(robot.x)+1,robot.y].valeur='O' then
        begin
          dummy:=robot.x;
          repeat
            inc(dummy);
          until (carte[dummy,robot.y].valeur='.') or (carte[dummy,robot.y].valeur='#');
          if (carte[dummy,robot.y].valeur='.') then
          begin
            carte[dummy,robot.y].valeur:='O';
            inc(robot.x);
            carte[robot.x,robot.y].visited:=true;
            carte[robot.x,robot.y].valeur:='.';
          end;
        end;
      end;
    end;
  end;

  if direction='^' then
  begin
    if robot.y>0 then
    begin
      if carte[robot.x,(robot.y-1)].valeur='.' then
      begin
        dec(robot.y);
        carte[robot.x,robot.y].visited:=true;
      end
      else
      begin
        if carte[robot.x,(robot.y-1)].valeur='O' then
        begin
          dummy:=robot.y;
          repeat
            dec(dummy);
          until (carte[robot.x,dummy].valeur='.') or (carte[robot.x,dummy].valeur='#');
          if (carte[robot.x,dummy].valeur='.') then
          begin
            carte[robot.x,dummy].valeur:='O';
            dec(robot.y);
            carte[robot.x,robot.y].visited:=true;
            carte[robot.x,robot.y].valeur:='.';
          end;
        end;
      end;
    end;
  end;

  if direction='v' then
  begin
    if robot.y<hauteur-1 then
    begin
      if carte[robot.x,(robot.y+1)].valeur='.' then
      begin
        inc(robot.y);
        carte[robot.x,robot.y].visited:=true;
      end
      else
      begin
        if carte[robot.x,(robot.y+1)].valeur='O' then
        begin
          dummy:=robot.y;
          repeat
            inc(dummy);
          until (carte[robot.x,dummy].valeur='.') or (carte[robot.x,dummy].valeur='#');
          if (carte[robot.x,dummy].valeur='.') then
          begin
            carte[robot.x,dummy].valeur:='O';
            inc(robot.y);
            carte[robot.x,robot.y].visited:=true;
            carte[robot.x,robot.y].valeur:='.';
          end;
        end;
      end;
    end;
  end;
end;


procedure CalculeScore;
var a,b,score:integer;
begin
  score:=0;
  for b:=0 to (hauteur-1) do
    for a:=0 to (largeur-1) do
    begin
      if carte[a,b].valeur='O' then score:=score+((100*b)+a);
    end;
  Writeln('Score : '+inttostr(score));
end;


begin
  Loadfile(nomfichier);
  DisplayMap;
  for a:=0 to nbcommandes-1 do 
    for cpt:=1 to length(commandes[a]) do
    begin
      DoMove(commandes[a][cpt]);
//      Writeln('Commande : '+commandes[a][cpt]);
//      DisplayMap;
//      ReadLn();
    end;
  DisplayMap; 
  CalculeScore;
end.