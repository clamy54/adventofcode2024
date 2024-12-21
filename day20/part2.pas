{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt; 

const nomfichier='input.txt';

type  tuile=record
          valeur:char;
          visited:Byte;
      end;

      position=record
          x,y:integer;
      end;

      Tcarte=array of array of tuile;

      tuple=record
        cout,x,y:Integer;
      end;
   

var  carte:array of array of tuile;
     largeur,hauteur:integer;
     depart,sortie:position;
     queue:array of tuple;
     entree:tuple;
     cout,x,y:Integer;
     cache:TStringList;
     visitedpoints:array of tuple;



function GetManhattanDistance(pa,pb:tuple):integer;
begin
  GetManhattanDistance:=abs(pa.x-pb.x)+abs(pa.y-pb.y);
end;

procedure Addqueue(entree:tuple); // add element to queue
begin
  SetLength(queue,Length(queue)+1);
  queue[Length(queue)-1]:=entree;
end;

function PopQueue():tuple; // Fifo
var ind:Integer;
begin
  if Length(queue)>0 then
  begin
    PopQueue.cout:=queue[0].cout;
    PopQueue.x:=queue[0].x;
    PopQueue.y:=queue[0].y;
    for ind:=1 to Length(queue)-1 do queue[ind-1]:=queue[ind];
    SetLength(queue,Length(queue)-1);
  end
  else
  begin
    PopQueue.cout:=-1;
    PopQueue.x:=-1;
    PopQueue.y:=-1;
  end;
end;

function SetCacheEntry(entree:tuple):string;
begin;
  SetCacheEntry:=inttostr(entree.x)+','+inttostr(entree.y);
end;

procedure PushQueue(tcout,tx,ty:integer); // Add element into queue if entry is not cached and entry is a valid point on map
var entreetmp:tuple;

begin
  entreetmp.cout:=tcout;
  entreetmp.x:=tx;
  entreetmp.y:=ty;
  if (tx>0) and (tx<largeur-1) and (ty>0) and (ty<hauteur-1) then 
  begin
    if (carte[tx,ty].valeur<>'#') and (cache.IndexOf(SetCacheEntry(entreetmp))=-1)  then
    begin
      Addqueue(entreetmp);
    end;
  end;  
end;

procedure DisplayMap(cartedup:Tcarte); // Display map
var a,b:Integer;
Begin
  for b:=0 to hauteur-1 do 
  begin
    for a:=0 to largeur-1 do 
    begin
      TextColor(DarkGray);
      if (cartedup[a,b]).visited=1 then
      begin
         TextColor(red);
      End;
      if (cartedup[a,b]).visited=2 then
      begin
         TextColor(Yellow);
      End;
      write(cartedup[a,b].valeur);
    end;
    writeln();
  end;
   writeln();
  TextColor(LightGray);
end;


procedure Loadfile(nom:string);
var a,b:integer;
    line:string;
    myFile : TextFile;
 
begin
  a:=0;
  b:=0;
  // Premier passage pour dimensionner le tableau dynamique
  AssignFile(myFile, nom);
  Reset(myFile);
  repeat
    ReadLn(myFile, line);
    inc(b);
    if Length(line)>a then a:=Length(line);
  until (eof(myFile));
  Closefile(myFile);
  hauteur:=b;
  largeur:=a;

  // dimensionnement du tableau
  SetLength(carte, largeur, hauteur);

  // Second passage pour mettre les donnees dans le tableau
  Reset(myFile);
  b:=0;
  repeat
    ReadLn(myFile, line);
    for a:=0 to Length(line)-1 do 
    begin
      carte[a,b].valeur:=line[a+1];
      carte[a,b].visited:=0;
      if line[a+1]='S' then
      Begin
        depart.x:=a;
        depart.y:=b;
      end;
      if line[a]='E' then
      Begin
        sortie.x:=a;
        sortie.y:=b;
      end;
    end;
    inc(b);
   until (eof(myFile));
  Closefile(myFile); 
end;

function GetNewPath(max:integer):integer;
var econodist,dst,distance,a,b,c:integer;
    pa,pb:tuple;
    cheats:Integer; 
begin
  cheats:=0;
  c:=length(visitedpoints);
  for a:=0 to (c-2) do
  begin
    pa:=visitedpoints[a];  
    for b:=a+1 to (c-1) do
    begin
      pb:=visitedpoints[b];
      if not((pa.x=pb.x) and (pa.y=pb.y)) then
      begin      
        distance:=GetManhattanDistance(pa,pb);
        if  (distance>=2) and (distance<=20) then
        begin
          dst:=b-a;
          econodist:=dst-distance;
          if econodist>=100 then 
          begin
            inc(cheats);
          end;
        end;
      end;
    end;
  end;
  GetNewPath:=cheats;
end;



begin 
  cache:=TStringList.Create;
  SetLength(queue,0);
  Loadfile(nomfichier);
  DisplayMap(carte);
  entree.cout:=0;
  entree.x:=depart.x;
  entree.y:=depart.y;
  Addqueue(entree);
  SetLength(visitedpoints,0);
  Writeln('Searching the lowest cost path to the exit ...');
  while (Length(queue)>0) and not (keypressed) do
  begin
    entree:=PopQueue();
    cout:=entree.cout;
    x:=entree.x;
    y:=entree.y;
    if (cache.IndexOf(SetCacheEntry(entree))=-1) then
    begin
      cache.Add(SetCacheEntry(entree));
      carte[x,y].visited:=1;
      SetLength(visitedpoints,length(visitedpoints)+1);
      if (x=sortie.x) and (y=sortie.y) then
      begin
        Break
      end;
      visitedpoints[length(visitedpoints)-1].x:=x;
      visitedpoints[length(visitedpoints)-1].y:=y;
      PushQueue(cout+1,x,y+1);    // go south     
      PushQueue(cout+1,x+1,y);   // go east
      PushQueue(cout+1,x-1,y);   // go west 
      PushQueue(cout+1,x,y-1);   // go north
    end;
  end;
  Writeln('number of cheats : '+IntToStr(GetNewPath(2)));
  cache.Free;
end.