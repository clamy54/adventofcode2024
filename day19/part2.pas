{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt, generics.collections; 

const nomfichier='input.txt';

type
  TCache = specialize TDictionary<string, int64>;


var towel:TStringList;
    pattern:array of string;
    maxsizetowel:int64;
    nbpattern:int64;
    dummy:int64;
    total:int64;
    cache: Tcache;


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
var line:string;
    myFile : TextFile;
    elements:TStringList;

begin
  elements := TStringList.Create; 
  AssignFile(myFile, nom); 
  Reset(myFile);
  ReadLn(myFile, line);
  Split(',', line, elements);
  maxsizetowel:=0;
  if elements.count>0 then
  begin
    for dummy:=0 to elements.count-1 do 
    begin 
      towel.add(trim(elements[dummy]));
      if length(trim(elements[dummy]))>maxsizetowel then maxsizetowel:=length(trim(elements[dummy]));
    end;
  end;
  ReadLn(myFile, line); // one for the money, two for the show ...
  nbpattern:=0;
  repeat
    ReadLn(myFile, line);
    if line<>'' then 
    begin
      inc(nbpattern);
      SetLength(pattern,nbpattern);
      pattern[nbpattern-1]:=trim(line);
    end;
  until eof(myFile);
  Closefile(myFile); 
  elements.Free;
end;


function CheckIfPossible(s:string):int64;
var cpt,total:int64;
    newstr:string;
begin
  if s='' then exit(1);
  if cache.ContainsKey(s) then 
  begin
    exit(cache.GetItem(s));
  End
  else
  begin
    cpt:=1;
    total:=0;
    newstr:='';
    repeat
      newstr:=newstr+s[cpt];
      if (towel.IndexOf(newstr)<>-1) then
      begin
          total:=total+CheckIfPossible(StringReplace(s,newstr,'',[rfIgnoreCase])); 
      end;
      inc(cpt);
    until (cpt>length(s)) or (cpt>maxsizetowel);
    CheckIfPossible:=total;
    Cache.Add(s,CheckIfPossible);
  end;
end;

begin
  total:=0;
  towel:=TStringList.Create;
  cache:=TCache.Create;
  LoadFile(nomfichier); 
  for dummy:=0 to nbpattern-1 do
  begin
    total:=total+CheckIfPossible(pattern[dummy]);
  end;
  cache.Free;
  towel.Free;
  Writeln(inttostr(total)+' designs are possible');
end.

