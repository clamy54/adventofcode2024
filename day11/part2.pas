{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt, generics.collections; 

const nomfichier='input.txt';
      nbiterations=75;

// use dynamic programming for solving part2
type
  TCache = specialize TDictionary<string, int64>; //string will contains a 'stone-iteration' string as key  

var line:string;
    boucle:integer;
    cache: Tcache;
    elements: TStringList;
    score:qword;
    a:integer;

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
 
begin
  AssignFile(myFile, nom);
  Reset(myFile);
  ReadLn(myFile, line);
  Closefile(myFile);
end;


function Calcule(pierre:string; nbit:integer):qword;
var chainetmpa,chainetmpb,newstring: string;
    b,valeur:int64;
    entree: string;

begin
    // if iteration=0 then return 1 
    if nbit=0 then exit(1);
    // set the key for cache
    entree:=pierre+'-'+inttostr(nbit);
    // if entry exists in cache then return directly the result
    if cache.ContainsKey(entree) then 
    begin
      // Writeln(entree+' : '+inttostr(cache.GetItem(entree)));
      exit(cache.GetItem(entree));
    end;
    // if stone=0 then then change it to 1 and get result for iteration-1;
    if StrToInt64(pierre)=0 then Calcule:=Calcule('1',nbit-1) else
    begin 
      // if lenght of stone is even then split in two part and get result for the 
      // sum of them for iteration-1;
      if (length(pierre) MOD 2)=0 then
      begin
        chainetmpa:='';
        for b:=1 to (length(pierre) DIV 2) do
          chainetmpa:=chainetmpa+pierre[b];
        chainetmpa:=inttostr(StrToInt64(chainetmpa));
        chainetmpb:='';
        for b:=((length(pierre) DIV 2)+1) to (length(pierre)) do
          chainetmpb:=chainetmpb+pierre[b];
        chainetmpb:=inttostr(StrToInt64(chainetmpb));
        // writeln('split '+pierre+' : '+chainetmpa+' '+chainetmpb);
        Calcule:=Calcule(chainetmpa,nbit-1)+Calcule(chainetmpb,nbit-1);
      end
      else
      begin
        // else 
        Calcule:=Calcule(inttostr(StrToInt64(pierre)*2024),nbit-1);
      end;  
    end;
    // if entry doesnt exists in cache then add it
    Cache.Add(entree,Calcule);
end;

begin
  score:=0;
  cache:=TCache.Create;
  Loadfile(nomfichier);
  Writeln(line);
  elements := TStringList.Create;
  Split(' ', line, elements);
  if elements.Count>0 then
  begin
    for a:=0 to elements.Count-1 do
        begin
          score:=score+Calcule(elements[a],(nbiterations));
          // Writeln('Processing : '+elements[a]+'  -  '+inttostr(Calcule(elements[a],nbiterations)));
        end;
  end;
  Writeln('Result : '+inttostr(score));
  elements.Free;
  cache.Free;
end.