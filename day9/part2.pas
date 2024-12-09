{$mode objfpc}{$H+}
uses Sysutils, Classes; 

const nomfichier='input.txt';

type bloc=record
          id:int64;
          libre:boolean;
     end;

var
  myFile : TextFile;
  diskmap: array of bloc;


procedure Loadfile(nom:string);
var a,b:integer;
    line:string;
    trigger:boolean;
    position:int64;
    id:int64;

begin
  SetLength(diskmap,0);
  AssignFile(myFile, nom);
  Reset(myFile);
  ReadLn(myFile, line);
  Closefile(myFile);
  trigger:=false;
  id:=0;
  position:=0;
  for a:=1 to Length(line) do
    begin
      SetLength(diskmap,length(diskmap)+StrToInt(line[a]));
      if trigger=false then
      begin
        for b:=1 to StrToInt(line[a]) do
          begin
            diskmap[position].id:=id;
            inc(position);
          end;
          inc(id);
      end
      else
      begin
        begin
        for b:=1 to StrToInt(line[a]) do
          begin
            diskmap[position].libre:=true;
            inc(position);
          end;          
        end;
      end;
      trigger:=NOT trigger;
    end;   
end;

procedure DisplayDiskmap;
var a:Int64;
begin
  for a:=0 to length(diskmap)-1 do
    begin
      if diskmap[a].libre=true then Write('.') else Write(IntToStr(diskmap[a].id));
    end;
  WriteLn;
end;

procedure Defrag;
var a,b,c:int64;
    remplacementok:Boolean;
    lenfile,longueurtrou:Integer;
begin
  a:=length(diskmap)-1;
  repeat
    if diskmap[a].libre=false then 
    begin
       lenfile:=0;
       for c:=a downto 0 do
       begin
         if (diskmap[c].libre=true) or (diskmap[c].id<>diskmap[a].id) then break else inc(lenfile);
       end;
       // writeln('Longueur fichier : '+IntToStr(lenfile));
       remplacementok:=False;
       b:=0;
       repeat
         if diskmap[b].libre=True then 
          begin
            longueurtrou:=0;
            for c:=b to (a-lenfile) do
            begin
              if (diskmap[c].libre=true) then inc(longueurtrou) else break;
            end;
            // writeln('Longueur trou : '+IntToStr(longueurtrou));
            if longueurtrou>=lenfile then 
            begin
              for c:=b to (b+lenfile-1) do 
              begin
                diskmap[c].libre:=false;
                diskmap[c].id:=diskmap[a].id;
              end;
              for c:=a downto (a-lenfile+1) do
                begin
                  diskmap[c].libre:=true;
                end;
              // DisplayDiskmap;
              remplacementok:=True;
            end else b:=b+longueurtrou;
          end else inc(b);
        until (b>= (a-lenfile)) or (remplacementok=True);
      a:=a-lenfile;
    end else dec(a);
  until (a<0);
end;

function CalculeChecksum:int64;
var a:int64;
begin
  CalculeChecksum:=0;
  for a:=0 to length(diskmap)-1 do
  begin
    if diskmap[a].libre=false then 
    begin
      CalculeChecksum:=CalculeChecksum+a*diskmap[a].id;
    end;
  end;  
end;

begin
  Loadfile(nomfichier);
  // DisplayDiskmap;
  Defrag;
  Writeln('Checksum : '+intToStr(CalculeChecksum));
end.

