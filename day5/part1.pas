{$mode objfpc}{$H+}
uses Sysutils, Classes; 

type contraintes=record
          before,after:integer;
     end;

var myFile : TextFile;
    regles : array of contraintes;
    update : array of Integer;
    line : string;
    dummy,cpt,valeur,compteur:integer;
    elements: TStringList;
    szregles:Integer;
    isOk:Boolean;
    total:Integer;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
   Strings.StrictDelimiter := true;
end;


begin
  elements := TStringList.Create;
  szregles:=0;
  Total:=0;
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  // lecture des regles
  repeat
    ReadLn(myFile, line);
    Split('|', line, elements);
    if elements.Count=2 then 
    begin
      inc(szregles);
      SetLength(regles,szregles);
      regles[szregles-1].before:=StrtoInt(elements[0]);
      regles[szregles-1].after:=StrtoInt(elements[1]);
    end;
  until line='';
  Writeln(IntToStr(szregles)+' regles stockees');
  // lecture des updates
  repeat
    ReadLn(myFile, line);
    Split(',', line, elements);
    if elements.Count>1 then
    begin
      Write(line+'  :  ');
      SetLength(update,elements.Count);
      for compteur:=0 to (elements.Count-1) do update[compteur]:=StrToInt(elements[compteur]);
      isOk:=true;
      for compteur:=0 to (elements.Count-1) do
      begin
        valeur:=update[compteur];
        for dummy:=0 to (szregles-1) do 
        begin
          if regles[dummy].before=valeur then
          begin
            for cpt:=0 to compteur do if update[cpt]=regles[dummy].after then isOk:=false;
          end;   

          if regles[dummy].after=valeur then
          begin
            for cpt:=compteur to (elements.Count-1)  do if update[cpt]=regles[dummy].before then isOk:=false;
          end;   
        end;
      end;
      if isOk then 
      begin
        writeln('Ok');
        total:=total+update[elements.Count DIV 2]; 
      end
      else writeln('Not OK');
    end;
  until Eof(myFile);
  writeln('Total : '+IntToStr(total));
  Closefile(myFile);
  elements.Free;
end.