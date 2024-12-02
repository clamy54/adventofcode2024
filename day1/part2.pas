{$mode objfpc}{$H+}
uses Sysutils, Classes; 

var
  myFile : TextFile;
  tab1:array[1..1000] of integer;
  tab2:array[1..1000] of integer;
  s,ch1,ch2:string;
  score: integer;
  occur,compteur:word;
  dummy:word;
  trig:boolean;


begin
  // Chargement du fichier de data
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  compteur:=1;
  while not Eof(myFile) do
  begin 
    readln(myFile, s);
    ch1:='';
    ch2:='';
    trig:=false;
    for dummy:=1 to length(s) do
    begin
      if s[dummy]=' ' then trig:=true else
      begin
        if trig=false then ch1:=ch1+s[dummy] else ch2:=ch2+s[dummy];
      end;     
    end;
    tab1[compteur]:=StrToInt(ch1);
    tab2[compteur]:=StrToInt(ch2);
    Inc(compteur);
  end;
  Closefile(myFile);

  score:=0;
  for compteur:=1 to 1000 do
    begin
      occur:=0;
      for dummy:=1 to 1000 do if tab1[compteur]=tab2[dummy] then inc(occur);
      score:=score+tab1[compteur]*occur;
    end;
  Writeln('similarity score : '+IntToStr(score));
end.
