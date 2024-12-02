{$mode objfpc}{$H+}
uses Sysutils, Classes; 

var
  myFile : TextFile;
  tab:array[1..20] of integer;
  dummy,cpt,safe:integer;
  s,st:string;

  

function isSafe(ss:string):Boolean;
var scpt,sdummy:integer;
    sst:string;
    stab:array[1..20] of integer;
    sens,trigger: Boolean;
begin
    for sdummy:=1 to 20 do stab[sdummy]:=0;
    scpt:=1;
    sst:='';
    // On met chaque element de la ligne dans un tableau
    for sdummy:=1 to length(ss) do 
    begin
      if ss[sdummy]=' ' then 
      begin
        if sst<>'' then 
        begin 
          stab[scpt]:=StrtoInt(sst);
          sst:='';
          inc(scpt);
        end;
      end
      else
      begin
        sst:=sst+ss[sdummy];
      end;
    end;
    if sst<>'' then stab[scpt]:=StrtoInt(sst) else dec(scpt);
    trigger:=true;
    sens:=false;
    if stab[1]>stab[2] then sens:=true;
    
    for sdummy:=1 to scpt-1 do
      begin
        if stab[sdummy]=stab[sdummy+1] then trigger:=false; 
        if (sens=true) and  NOT (stab[sdummy]>stab[sdummy+1]) then trigger:=false;
        if (sens=false) and  NOT (stab[sdummy]<stab[sdummy+1]) then trigger:=false;
    end;

    // si la ligne est bien soit strictement croissante soit strictement décroissante
    if trigger=true then
    begin
    for sdummy:=2 to scpt-1 do
      begin
        if not((abs(stab[sdummy]-stab[sdummy-1])>=1) and (abs(stab[sdummy]-stab[sdummy-1])<=3)) then trigger:=false;
        if not((abs(stab[sdummy]-stab[sdummy+1])>=1) and (abs(stab[sdummy]-stab[sdummy+1])<=3)) then trigger:=false;
      end;    
    end;
    isSafe:=trigger;
end;

begin

  safe:=0;
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  while not Eof(myFile) do
  begin 
    for dummy:=1 to 20 do tab[dummy]:=0;
    cpt:=1;
    st:='';
    ReadLn(myFile, s);
    // On met chaque element de la ligne dans un tableau
    for dummy:=1 to length(s) do 
    begin
      if s[dummy]=' ' then 
      begin
        if st<>'' then 
        begin 
          tab[cpt]:=StrtoInt(st);
          st:='';
          inc(cpt);
        end;
      end
      else
      begin
        st:=st+s[dummy];
      end;
    end;
    if st<>'' then tab[cpt]:=StrtoInt(st) else dec(cpt);

    if isSafe(s) then inc(safe);
 
  end;
  writeln(inttostr(safe)+' reports are safe');
  Closefile(myFile);
end.