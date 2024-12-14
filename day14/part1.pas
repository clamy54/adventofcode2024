{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt; 

const nomfichier='input.txt';
      largeur=101;
      hauteur=103;
      nbsecondes=100;

Type robot=record
      x,y,dx,dy:integer;
     end;

var robots:array of robot;
    nbrobots:integer;
    cpt,numr:integer;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
var a: int64;
    subs:string;

begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   subs:='';
   for a:=1 to length(Input) do
   begin
      if Input[a]=Delimiter then
      begin
        Strings.Add(subs);
        subs:='';
      end
      else
        subs:=subs+Input[a];
   end;
   Strings.Add(subs);
end;

procedure Loadfile(nom:string);
var myFile : TextFile;
    elements,valeurs: TStringList;
    line,tmpstr:string;
    x,y,dx,dy:integer;
begin
  elements := TStringList.Create;
  valeurs := TStringList.Create;
  nbrobots:=0;
  AssignFile(myFile, nom);
  Reset(myFile);
  repeat
    inc(nbrobots);
    ReadLn(myFile, line);
    SetLength(robots, nbrobots);
    Split(' ', line, elements);
    tmpstr:=StringReplace(elements[0],'p=','',[rfReplaceAll, rfIgnoreCase]);
    Split(',', tmpstr, valeurs);
    x:=strtoint(valeurs[0]);
    y:=strtoint(valeurs[1]);
    tmpstr:=StringReplace(elements[1],'v=','',[rfReplaceAll, rfIgnoreCase]);
    Split(',', tmpstr, valeurs);
    dx:=strtoint(valeurs[0]);
    dy:=strtoint(valeurs[1]); 
    robots[nbrobots-1].x:=x;
    robots[nbrobots-1].y:=y;
    robots[nbrobots-1].dx:=dx;
    robots[nbrobots-1].dy:=dy;
    Writeln('Robot #'+inttostr(nbrobots-1)+' : x='+inttostr(x)+' y='+inttostr(y)+' dx='+inttostr(dx)+' y='+inttostr(dy));
  until eof(myFile);
  Closefile(myFile);
  valeurs.Free;
  elements.Free;
end;

procedure AfficheMap;
var a,b,dummy,cpt:integer;
begin
  for b:=0 to hauteur-1 do
  begin
    for a:=0 to largeur-1 do
    begin
      dummy:=0;
      for cpt:=0 to nbrobots-1 do if (robots[cpt].x=a) and (robots[cpt].y=b) then inc (dummy);
      if dummy=0 then write('.');
      if (dummy>0) and (dummy<10) then write(inttostr(dummy));
      if (dummy>10) then write('X');
    end;
  WriteLn();
  end;
  WriteLn();
end;



procedure bougeRobot(num:integer);
var x,y,dx,dy:integer;
begin
  x:=robots[num].x;
  y:=robots[num].y;
  dx:=robots[num].dx;
  dy:=robots[num].dy;
  x:=x+dx;
  y:=y+dy;
  if x<0 then x:=largeur+x;
  if y<0 then y:=hauteur+y;
  if x>(largeur-1) then x:=x-largeur;
  if y>(hauteur-1) then y:=y-hauteur;
  robots[num].x:=x;
  robots[num].y:=y;
end;

procedure CalculeScore;
var qa,qb,qc,qd,a,b,cpt:integer;
begin
  qa:=0;
  qb:=0;
  qc:=0;
  qd:=0;

  for b:=0 to ((hauteur-1) DIV 2)-1 do
    for a:=0 to ((largeur-1) DIV 2)-1 do
    begin
      for cpt:=0 to nbrobots-1 do if (robots[cpt].x=a) and (robots[cpt].y=b) then inc (qa);
    end;
  Writeln('premier quartier : '+inttostr(qa));

  for b:=0 to ((hauteur-1) DIV 2)-1 do
    for a:=((largeur-1) DIV 2)+1 to (largeur-1) do
    begin
      for cpt:=0 to nbrobots-1 do if (robots[cpt].x=a) and (robots[cpt].y=b) then inc (qb);
    end;
  Writeln('second quartier : '+inttostr(qb));

  for b:=((hauteur-1) DIV 2)+1 to (hauteur-1) do
    for a:=0 to ((largeur-1) DIV 2)-1 do
    begin
      for cpt:=0 to nbrobots-1 do if (robots[cpt].x=a) and (robots[cpt].y=b) then inc (qc);
    end;
  Writeln('troisieme quartier : '+inttostr(qc));

  for b:=((hauteur-1) DIV 2)+1 to (hauteur-1) do
    for a:=((largeur-1) DIV 2)+1 to (largeur-1) do
    begin
      for cpt:=0 to nbrobots-1 do if (robots[cpt].x=a) and (robots[cpt].y=b) then inc (qd);
    end;
  Writeln('quatrieme quartier : '+inttostr(qd));
  WriteLn();
  Writeln('Resultat : '+inttostr(qa*qb*qc*qd));
end;

begin
  Loadfile(nomfichier);
  AfficheMap;
  for cpt:=1 to nbsecondes do
  begin
    for numr:=0 to nbrobots-1 do bougeRobot(numr);
  end;
  AfficheMap;
  CalculeScore;
end.