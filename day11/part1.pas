{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt; 

const nomfichier='input.txt';
      nbiterations=25;

var line:string;
    boucle:integer;



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



Function resultat:string;
var elements: TStringList;

begin
  elements := TStringList.Create;
  Split(' ', line, elements);
  resultat:=inttostr(elements.Count);
  elements.Free;
end;



procedure Loadfile(nom:string);
var myFile : TextFile;
 
begin
  AssignFile(myFile, nom);
  Reset(myFile);
  ReadLn(myFile, line);
  Closefile(myFile);
end;


procedure Calcule;
var chainetmp,newstring: string;
    a,b,valeur:int64;
    elements: TStringList;


begin
    newstring:='';
    elements := TStringList.Create;
    Split(' ', line, elements);
    if elements.Count>0 then
    begin
      for a:=0 to elements.Count-1 do
      begin
        valeur:=StrToInt64(elements[a]);
        if valeur=0 then newstring:=newstring+'1 ' else
        begin
          if (length(elements[a]) MOD 2)=0 then
          begin
            chainetmp:='';
            for b:=1 to (length(elements[a]) DIV 2) do
              chainetmp:=chainetmp+elements[a][b];
            newstring:=newstring+inttostr(StrToInt64(chainetmp))+' ';
            chainetmp:='';
            for b:=((length(elements[a]) DIV 2)+1) to (length(elements[a])) do
              chainetmp:=chainetmp+elements[a][b];
            newstring:=newstring+inttostr(StrToInt64(chainetmp))+' ';
          end
          else
          begin
            newstring:=newstring+inttostr(valeur*2024)+' ';
          end;
        end;
      if newstring<>'' then line:=TrimRight(newstring);
      end;
    end;
    elements.Free;
end;

begin
  Loadfile(nomfichier);
  Writeln(line);
  for boucle:=1 to nbiterations do
  begin
    Calcule;
    // Writeln(line);
  end;
  Writeln('Result : '+resultat);
end.