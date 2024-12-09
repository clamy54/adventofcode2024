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
var a,b:int64;
    remplacementok:Boolean;
begin
  for a:=length(diskmap)-1 downto 0 do
  begin
    if diskmap[a].libre=false then 
    begin
       remplacementok:=False;
       for b:=0 to a do 
       begin    
         if diskmap[b].libre=True then 
         begin
            diskmap[b].libre:=false;
            diskmap[b].id:=diskmap[a].id;
            diskmap[a].libre:=true;
            remplacementok:=True;
            break;
         end;
       end;
       if remplacementok=False then break;
    end;
  end;
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
    end
    else
    begin
      break;
    end;
  end;  
end;

begin
  Loadfile(nomfichier);
  //DisplayDiskmap;
  Defrag;
  Writeln('Checksum : '+intToStr(CalculeChecksum));
end.

