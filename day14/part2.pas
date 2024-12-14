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

function NoOverlap():boolean;
var a,b,cpt,nbpresent:integer;
begin
  NoOverlap:=true;
   for b:=0 to hauteur-1 do
    for a:=0 to largeur-1 do
    begin
      nbpresent:=0;
      for cpt:=0 to nbrobots-1 do if (robots[cpt].x=a) and (robots[cpt].y=b) then inc(nbpresent);
      if nbpresent>1 then NoOverlap:=false;
    end;
end;

begin
  Loadfile(nomfichier);
  AfficheMap;
  cpt:=0;
  repeat
    inc(cpt);
    for numr:=0 to nbrobots-1 do bougeRobot(numr);
  until (NoOverlap=true) OR (cpt>65535);
  AfficheMap;
  Writeln('Nombre de secondes : '+inttostr(cpt));
end.