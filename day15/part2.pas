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
var a,b,c,d:integer;
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
  largeur:=a*2;
  hauteur:=b*2;
  // dimensionnement du tableau
  SetLength(carte, largeur, hauteur);
  // Second passage pour mettre les donnees dans le tableau
  Reset(myFile);
  b:=0;
  repeat
    ReadLn(myFile, line);
    if line<>'' then
    begin   
      d:=0;   
      for a:=1 to Length(line) do 
      begin
        if line[a]='@' then
        begin
          carte[d,b].valeur:='.';
          carte[d+1,b].valeur:='.';
          carte[d,b].visited:=true;
          carte[d+1,b].visited:=False;
          robot.x:=d;
          robot.y:=b;
        end;
        if line[a]='#' then
        begin
          carte[d,b].valeur:='#';
          carte[d+1,b].valeur:='#';
          carte[d,b].visited:=False;
          carte[d+1,b].visited:=False;
        end;
        if line[a]='O' then
        begin
          carte[d,b].valeur:='[';
          carte[d+1,b].valeur:=']';
          carte[d,b].visited:=False;
          carte[d+1,b].visited:=False;
        end;
        if line[a]='.' then
        begin
          carte[d,b].valeur:='.';
          carte[d+1,b].valeur:='.';
          carte[d,b].visited:=False;
          carte[d+1,b].visited:=False;
        end;
        d:=d+2;
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


function moveBoxLeft(x,y:integer):boolean;
begin
  moveBoxLeft:=false;
  if x>0 then 
  begin
   if carte[x-1,y].valeur='.' then 
   begin
     carte[x-1,y].valeur:='[';
     carte[x,y].valeur:=']';
     carte[x+1,y].valeur:='.';
     moveBoxLeft:=true;
   end
   else
   begin
   if carte[x-1,y].valeur=']' then 
   begin
     if moveBoxLeft(x-2,y)=true then
     begin 
      carte[x-1,y].valeur:='[';
      carte[x,y].valeur:=']';
      carte[x+1,y].valeur:='.';
      moveBoxLeft:=true;
     end;
   end
   end;
  end;
end;

function moveBoxRight(x,y:integer):boolean;
begin
  moveBoxRight:=false;
  if x<largeur-1 then 
  begin
   if carte[x+2,y].valeur='.' then 
   begin
     carte[x+1,y].valeur:='[';
     carte[x+2,y].valeur:=']';
     carte[x,y].valeur:='.';
     moveBoxRight:=true;
   end
   else
   begin
   if carte[x+2,y].valeur='[' then 
   begin
     if moveBoxRight(x+2,y)=true then
     begin 
      carte[x+1,y].valeur:='[';
      carte[x+2,y].valeur:=']';
      carte[x,y].valeur:='.';
      moveBoxRight:=true;
     end;
   end
   end;
  end; 
end;

function moveBoxUp(x,y:integer):boolean;
var chaine:string;
    cartedup:array of array of tuile;
    a,b:integer;
begin
  moveBoxUp:=false;
  if y>0 then 
  begin
   chaine:=carte[x,y-1].valeur+carte[x+1,y-1].valeur;
   if chaine='..'  then 
   begin
     carte[x,y-1].valeur:='[';
     carte[x+1,y-1].valeur:=']';
     carte[x,y].valeur:='.';
     carte[x+1,y].valeur:='.';
     moveBoxUp:=true;
   end;
   if chaine='[]'  then 
   begin
     if moveBoxUp(x,y-1)=true then
     begin 
      carte[x,y-1].valeur:='[';
      carte[x+1,y-1].valeur:=']';
      carte[x,y].valeur:='.';
      carte[x+1,y].valeur:='.';
      moveBoxUp:=true;
     end;     
   end;
   if chaine='.['  then 
   begin
     if moveBoxUp(x+1,y-1)=true then
     begin 
      carte[x,y-1].valeur:='[';
      carte[x+1,y-1].valeur:=']';
      carte[x,y].valeur:='.';
      carte[x+1,y].valeur:='.';
      moveBoxUp:=true;
     end;     
   end;
   if chaine='].'  then 
   begin
     if moveBoxUp(x-1,y-1)=true then
     begin 
      carte[x,y-1].valeur:='[';
      carte[x+1,y-1].valeur:=']';
      carte[x,y].valeur:='.';
      carte[x+1,y].valeur:='.';
      moveBoxUp:=true;
     end;     
   end;
   if chaine=']['  then 
   begin
     SetLength(cartedup,largeur,hauteur);
     for b:=0 to hauteur-1 do
      for a:=0 to largeur-1 do
        cartedup[a,b]:=carte[a,b];
     if (moveBoxUp(x-1,y-1)=true) and (moveBoxUp(x+1,y-1)=true)  then
     begin 
      carte[x,y-1].valeur:='[';
      carte[x+1,y-1].valeur:=']';
      carte[x,y].valeur:='.';
      carte[x+1,y].valeur:='.';
      moveBoxUp:=true;
     end
     else
     begin
      for b:=0 to hauteur-1 do
        for a:=0 to largeur-1 do
          carte[a,b]:=cartedup[a,b];
     end;
   end;
  end; 
end;

function moveBoxDown(x,y:integer):boolean;
var chaine:string;
    cartedup:array of array of tuile;
    a,b:integer;
begin
  moveBoxDown:=false;
  if y<hauteur-1 then 
  begin
   chaine:=carte[x,y+1].valeur+carte[x+1,y+1].valeur;
   if chaine='..'  then 
   begin
     carte[x,y+1].valeur:='[';
     carte[x+1,y+1].valeur:=']';
     carte[x,y].valeur:='.';
     carte[x+1,y].valeur:='.';
     moveBoxDown:=true;
   end;
   if chaine='[]'  then 
   begin
     if moveBoxDown(x,y+1)=true then
     begin 
      carte[x,y+1].valeur:='[';
      carte[x+1,y+1].valeur:=']';
      carte[x,y].valeur:='.';
      carte[x+1,y].valeur:='.';
      moveBoxDown:=true;
     end;     
   end;
   if chaine='.['  then 
   begin
     if moveBoxDown(x+1,y+1)=true then
     begin 
      carte[x,y+1].valeur:='[';
      carte[x+1,y+1].valeur:=']';
      carte[x,y].valeur:='.';
      carte[x+1,y].valeur:='.';
      moveBoxDown:=true;
     end;     
   end;
   if chaine='].'  then 
   begin
     if moveBoxDown(x-1,y+1)=true then
     begin 
      carte[x,y+1].valeur:='[';
      carte[x+1,y+1].valeur:=']';
      carte[x,y].valeur:='.';
      carte[x+1,y].valeur:='.';
      moveBoxDown:=true;
     end;     
   end;
   if chaine=']['  then 
   begin
     SetLength(cartedup,largeur,hauteur);
     for b:=0 to hauteur-1 do
      for a:=0 to largeur-1 do
        cartedup[a,b]:=carte[a,b];
     if (moveBoxDown(x-1,y+1)=true) and (moveBoxDown(x+1,y+1)=true)  then
     begin 
      carte[x,y+1].valeur:='[';
      carte[x+1,y+1].valeur:=']';
      carte[x,y].valeur:='.';
      carte[x+1,y].valeur:='.';
      moveBoxDown:=true;
     end
     else
     begin
      for b:=0 to hauteur-1 do
        for a:=0 to largeur-1 do
          carte[a,b]:=cartedup[a,b];
     end;
   end;
  end; 
end;


procedure DoMove(direction:char);   
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
        if carte[(robot.x)-1,robot.y].valeur=']' then
        begin
          if moveBoxLeft((robot.x)-2,robot.y)=true then
          begin
            carte[robot.x,robot.y].valeur:='.';
            dec(robot.x);
            carte[robot.x,robot.y].visited:=true;
          end;
        end;
      end;
    end;
  end;

  if direction='>' then
  begin
    if robot.x<largeur-2 then
    begin
      if carte[(robot.x)+1,robot.y].valeur='.' then
      begin
        inc(robot.x);
        carte[robot.x,robot.y].visited:=true;
      end
      else
      begin
        if carte[(robot.x)+1,robot.y].valeur='[' then
        begin
          if moveBoxRight((robot.x)+1,robot.y)=true then
          begin
            carte[robot.x,robot.y].valeur:='.';
            inc(robot.x);
            carte[robot.x,robot.y].visited:=true;
          end;
        end;
      end;
    end;
  end;

  if direction='^' then
  begin
    if robot.y>0 then
    begin
      if carte[robot.x,robot.y-1].valeur='.' then
      begin
        dec(robot.y);
        carte[robot.x,robot.y].visited:=true;
      end
      else
      begin
        if carte[robot.x,robot.y-1].valeur=']' then
        begin
          if moveBoxUp((robot.x)-1,robot.y-1)=true then
          begin
            carte[robot.x,robot.y].valeur:='.';
            dec(robot.y);
            carte[robot.x,robot.y].visited:=true;
          end;         
        end;
        if carte[robot.x,robot.y-1].valeur='[' then
        begin
          if moveBoxUp(robot.x,robot.y-1)=true then
          begin
            carte[robot.x,robot.y].valeur:='.';
            dec(robot.y);
            carte[robot.x,robot.y].visited:=true;
          end;         
        end;
      end;
    end;
  end;

  if direction='v' then
  begin
    if robot.y<hauteur-1 then
    begin
      if carte[robot.x,robot.y+1].valeur='.' then
      begin
        inc(robot.y);
        carte[robot.x,robot.y].visited:=true;
      end
      else
      begin
        if carte[robot.x,robot.y+1].valeur=']' then
        begin
          if moveBoxDown((robot.x)-1,robot.y+1)=true then
          begin
            carte[robot.x,robot.y].valeur:='.';
            inc(robot.y);
            carte[robot.x,robot.y].visited:=true;
          end;         
        end;
        if carte[robot.x,robot.y+1].valeur='[' then
        begin
          if moveBoxDown(robot.x,robot.y+1)=true then
          begin
            carte[robot.x,robot.y].valeur:='.';
            inc(robot.y);
            carte[robot.x,robot.y].visited:=true;
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
      if carte[a,b].valeur='[' then score:=score+((100*b)+a);
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
      // Writeln('Commande : '+commandes[a][cpt]);
      // DisplayMap;
      // ReadLn();
    end;
  DisplayMap; 
  CalculeScore;
end.