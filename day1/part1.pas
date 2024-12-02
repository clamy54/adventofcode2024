{$mode objfpc}{$H+}
uses Sysutils, Classes; 

var
  myFile : TextFile;
  tab1:array[1..1000] of integer;
  tab2:array[1..1000] of integer;
  s,ch1,ch2:string;
  distance: integer;
  compteur:word;
  dummy:word;
  trig:boolean;


procedure swap( var a, b:integer);
var
  temp : Integer;
begin
  temp := a;
  a := b;
  b := temp;
end;


procedure BubbleSort( var a: array of integer );
var
  n, newn, i:integer;
begin
  n := high( a );
  repeat
    newn := 0;
    for i := 1 to n   do
      begin
        if a[ i - 1 ] > a[ i ] then
          begin
            swap( a[ i - 1 ], a[ i ]);
            newn := i ;
          end;
      end ;
    n := newn;
  until n = 0;
end;

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
  BubbleSort(tab1);
  BubbleSort(tab2);

  distance:=0; 
  for dummy:=1 to 1000 do
    distance:=distance+abs(tab2[dummy]-tab1[dummy]);
  Writeln('Total distance : '+IntToStr(distance));
end.

