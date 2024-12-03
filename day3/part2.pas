{$mode objfpc}{$H+}
uses Sysutils, Classes; 

const sub='mul(';
      validstr='0123456789,';
      activate='do()';
      desactivate='don''t()';
var
  myFile : TextFile;
  line: string;
  total:integer;
  cpt:Integer;
  activated:Boolean;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;

function get_sum(s:string):integer;
var  somme: integer;
     extracted,cmpstr:string;
     nbcomma,dummy,position,startposition:integer;
     c:char;
     elements: TStringList;


begin
 somme:=0;
 startposition:=1;
 if pos(sub,s)<>0 then
 begin
  repeat
    if pos(activate,s,startposition)=startposition then activated:=true;
    if pos(desactivate,s,startposition)=startposition then activated:=false;
    if pos(sub,s,startposition)=startposition then
    begin
        
        // if position can contain mul(.,.)
        if startposition<(length(s)-(length(sub)+3)) then
        begin
        position:=startposition+4;
        extracted:='';
        repeat
          c:=s[position];
          if c=')' then break else extracted:=extracted+s[position];
          inc(position);
        until position>length(s);
        if length(extracted)>0 then
        begin
          cmpstr:='';
          nbcomma:=0;
          for dummy:=1 to length(extracted) do if pos(extracted[dummy],validstr)>0 then 
          begin
            cmpstr:=cmpstr+extracted[dummy];
            if extracted[dummy]=',' then inc(nbcomma);
          end;
          // if extracted string contains only numbers and one comma
          if (cmpstr=extracted) and (nbcomma=1) and (pos(',',extracted)<>1) and (pos(',',extracted)<>length(extracted))  then 
          begin
            elements := TStringList.Create;
            Split(',', extracted, elements);
            if elements.Count=2 then if activated then 
            begin 
             somme:=somme+StrtoInt(elements[0])*StrtoInt(elements[1]);
            end;
            elements.Free;
          end;
        end;
      end;
    end;
    inc(startposition);
  until (startposition>=length(s));
 end;
 get_sum:=somme;
end;



begin
  activated:=true;
  total:=0;
  cpt:=1;
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  while not Eof(myFile) do
  begin
    ReadLn(myFile, line);
    total:=total+get_sum(line);
    inc(cpt);
  end;
  Writeln('Result : '+inttostr(total));
  Closefile(myFile);
end.