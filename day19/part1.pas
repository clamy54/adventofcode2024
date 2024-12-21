{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt, generics.collections; 

const nomfichier='input.txt';

type
  TCache = specialize TDictionary<string, boolean>;


var towel:TStringList;
    pattern:array of string;
    maxsizetowel:integer;
    nbpattern:Integer;
    dummy:Integer;
    total:Integer;
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


function CheckIfPossible(s:string):Boolean;
var cpt,total:Integer;
    newstr:string;
begin
  if s='' then exit(true);
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
          if CheckIfPossible(StringReplace(s,newstr,'',[rfIgnoreCase]))=true then inc(total); 
      end;
      inc(cpt);
    until (cpt>length(s)) or (cpt>maxsizetowel);
    if total>0 then CheckIfPossible:=true else CheckIfPossible:=false;
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
    if CheckIfPossible(pattern[dummy])=true then inc(total);
  end;
  cache.Free;
  towel.Free;
  Writeln(inttostr(total)+' designs are possible');
end.

