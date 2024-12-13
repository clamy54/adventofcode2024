{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt; 

const nomfichier='input.txt';

Type machine=record
      ax,ay,bx,by,px,py:int64;
     end;

    typeresultat=record
      nba,nbb:int64;
      solvable:Boolean;
    end;

var machines:array of machine;  
    boucle,longueurtableau:integer;
    cout,couttotal:int64;
    resultat:typeresultat;

function Solve(numeromachine:Integer):typeresultat;
var a,b:Extended;
    ax,ay,bx,by,px,py:int64;
begin
  ax:=machines[numeromachine].ax;
  ay:=machines[numeromachine].ay;
  bx:=machines[numeromachine].bx;
  by:=machines[numeromachine].by;
  px:=machines[numeromachine].px;
  py:=machines[numeromachine].py;

  Solve.solvable:=false;
  Solve.nba:=0;
  Solve.nbb:=0;

  if (((ax*by)-(bx*ay))<>0) and (((ax*by)-(bx*ay))<>0) then
  begin
    // Using Cramer's rule to solve the problem
    a:=((px*by)-(bx*py))/((ax*by)-(bx*ay));
    b:=((ax*py)-(px*ay))/((ax*by)-(bx*ay));
    Solve.nba:=round(a);
    Solve.nbb:=round(b);
    if (Solve.nba>=0) and (Solve.nbb>= 0) and (Solve.nba*ax+Solve.nbb*bx=px) and  (Solve.nba*ay+Solve.nbb*by=py) then 
    begin
      Solve.solvable:=true;
    end;
  end;
end;


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
    boutona,boutonb,prize,lignevide:string;
    elements: TStringList;

begin
  elements := TStringList.Create;
  longueurtableau:=0;
  AssignFile(myFile, nom);
  Reset(myFile);
  repeat
    boutona:='';
    boutonb:='';
    prize:='';
    if not eof(myFile) then ReadLn(myFile, boutona);
    if not eof(myFile) then ReadLn(myFile, boutonb);
    if not eof(myFile) then ReadLn(myFile, prize);
    if not eof(myFile) then ReadLn(myFile, lignevide);
    if (boutona<>'') and (boutonb<>'') and (prize<>'') then
    begin     
      inc(longueurtableau);
      SetLength(machines, longueurtableau);
      boutona:=StringReplace(boutona,'Button A: X+','',[rfReplaceAll, rfIgnoreCase]);
      boutona:=StringReplace(boutona,', Y+',' ',[rfReplaceAll, rfIgnoreCase]);
      boutonb:=StringReplace(boutonb,'Button B: X+','',[rfReplaceAll, rfIgnoreCase]);
      boutonb:=StringReplace(boutonb,', Y+',' ',[rfReplaceAll, rfIgnoreCase]);      
      prize:=StringReplace(prize,'Prize: X=','',[rfReplaceAll, rfIgnoreCase]);
      prize:=StringReplace(prize,', Y=',' ',[rfReplaceAll, rfIgnoreCase]);      
      Split(' ', boutona, elements);
      machines[longueurtableau-1].ax:=StrToInt64(elements[0]);
      machines[longueurtableau-1].ay:=StrToInt64(elements[1]);
      Split(' ', boutonb, elements);
      machines[longueurtableau-1].bx:=StrToInt64(elements[0]);
      machines[longueurtableau-1].by:=StrToInt64(elements[1]);
      Split(' ', prize, elements);
      machines[longueurtableau-1].px:=StrToInt64(elements[0])+10000000000000;
      machines[longueurtableau-1].py:=StrToInt64(elements[1])+10000000000000;
    end;
  until eof(myFile);
  Closefile(myFile);
  elements.Free;
end;

begin
  couttotal:=0;
  Loadfile(nomfichier);
  for boucle:=0 to longueurtableau-1 do 
  begin
    Writeln('Traitement de la machine '+inttostr(boucle));
    resultat:=Solve(boucle);
    if resultat.solvable=false then Writeln('Pas de solution possible') else
    begin
      Writeln('Solution : '+inttostr(resultat.nba)+' - '+inttostr(resultat.nbb));
      cout:=resultat.nba*3+resultat.nbb;
      Writeln('Cout : '+inttostr(cout));
      couttotal:=couttotal+cout;
      Writeln();
    end;
  end;
  WriteLn('Cout total : '+IntToStr(couttotal));
end.
