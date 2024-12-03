{$mode objfpc}{$H+}
uses Sysutils, Classes, Regexpr; 

const activate='do()';
      desactivate='don''t()';

var
  myFile : TextFile;
  activated:Boolean;
  somme:integer;
  line:string;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;

procedure Analyse(s:string);
var reg: TRegExpr;
    result:string;
    elements: TStringList;

begin
  reg := TRegExpr.Create('mul\((\d+,\d+)\)|(do\(\))|(don''t\(\))'); 
  if reg.Exec(s) then
  repeat
    result:=reg.Match[0];
    case result of
      activate: activated:=true;
      desactivate: activated:=false;
      else
      begin
        result:=stringReplace(result , 'mul(',  '' ,[rfReplaceAll, rfIgnoreCase]);
        result:=stringReplace(result , ')',  '' ,[rfReplaceAll, rfIgnoreCase]);
        if (activated) then
        begin
          elements := TStringList.Create;
          Split(',', result, elements);
          somme:=somme+StrtoInt(elements[0])*StrtoInt(elements[1]);
          elements.Free;
        end;
      end;
    end;
  until not reg.ExecNext;
  reg.Free;
end;

begin
  activated:=true;
  somme:=0;
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  while not Eof(myFile) do
  begin
    ReadLn(myFile, line);
    Analyse(line);
  end;
  Writeln('Result : '+inttostr(somme));
  Closefile(myFile);  
end.