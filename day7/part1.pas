{$mode objfpc}{$H+}
uses Sysutils, Classes; 

Const chiffre='0123456789';
      operateur='+-*/';

var TestOk:boolean;
    score,nbtested:Qword;
    myFile : TextFile;
    line: string;
    elements: TStringList;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
var a: integer;
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

Function isChiffre(C:char):boolean;
begin
  if (Pos(C,chiffre)<>0) then isChiffre:=true else isChiffre:=false;
end;

Function isOperateur(C:char):boolean;
begin
  if (Pos(C,operateur)<>0) then isOperateur:=true else isOperateur:=false;
end;

Function CptOccur(C:Char;S:String):integer;
var t:integer;
begin
  CptOccur:=0;
  for t:=1 to length(s) do if S[t]=C then inc(CptOccur);
end;

Function evalue(S:string):Qword;
var dummy,resultat:Qword;
    trigger:boolean;

  function numLeft(chaine:string; position:Qword):Qword;
  var t: Qword;
      extracted:string;
  begin
    if  position>1 then 
    begin
      extracted:='';
      t:=position;
      repeat
        dec(t);
        if isChiffre(chaine[t])=true then
        begin
          extracted:=chaine[t]+extracted;
        end;
      until (isChiffre(chaine[t])=false) or (t=1);
      if length(extracted)>0 then numLeft:=StrToInt64(extracted) else numLeft:=0;
    end
    else
      numLeft:=0;
  end;

  function numRight(chaine:string; position:Qword):Qword;
  var t: Qword;
      extracted:string;
  begin
    if  position<length(chaine) then 
    begin
      extracted:='';
      t:=position;
      repeat
        inc(t);
        if isChiffre(chaine[t])=true then
        begin
          extracted:=extracted+chaine[t];
        end;
      until (isChiffre(chaine[t])=false) or (t=length(chaine));
      if length(extracted)>0 then numRight:=StrToInt64(extracted) else numRight:=0;
    end
    else
      numRight:=0;
  end;

begin
  resultat:=0;
  trigger:=false;
  for dummy:=1 to length(S) do
  begin
    if isOperateur(S[dummy])= true then
    begin
      if trigger=false then
      begin
        resultat:=numLeft(S,dummy);
        trigger:=true;
      end;
      case S[dummy] of 
        '+': resultat:= resultat+numRight(S,dummy);
        '-': resultat:= resultat-numRight(S,dummy);
        '*': resultat:= resultat*numRight(S,dummy);
        '/': resultat:= resultat DIV numRight(S,dummy);
      end;
    end;
  end;
  evalue:=resultat;
end;

procedure TesteChaine(S:string;res:Qword);
var dummy:Qword;

begin
  dummy:=Pos(' ',S);
  if dummy>0 then
  begin
    S[dummy]:='+';
    TesteChaine(S,res);
    S[dummy]:='*';
    TesteChaine(S,res);
  end
  else
  begin
    if evalue(S)=res then 
    begin 
      TestOk:=true;
    end;
    inc(nbtested);
  end;
end;


begin
  score:=0;
 
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  while not Eof(myFile) do
  begin 
    ReadLn(myFile, line);
    elements := TStringList.Create;
    Split(':', line, elements);
    TestOk:=false;
    if elements.Count=2 then
    begin
     nbtested:=0;
     TesteChaine(Trim(elements[1]),StrToInt64(elements[0]));
     if TestOk=true then
     begin
       score:=score+StrToInt64(elements[0]);
     end;
    end
    else
     writeln('Probleme avec la ligne :'+line);
    elements.Free;
  end;  
  Closefile(myFile);
  Writeln('Score : '+inttostr(score));
end.
