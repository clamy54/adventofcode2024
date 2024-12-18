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
        cout,x,y,dx,dy:Integer;
      end;
   

var  carte:array of array of tuile;
     largeur,hauteur:integer;
     depart,sortie:position;
     queue:array of tuple;
     entree:tuple;
     cout,x,y,dx,dy:Integer;
     cache:TStringList;
    

procedure Addqueue(entree:tuple); // add element to queue
begin
  SetLength(queue,Length(queue)+1);
  queue[Length(queue)-1]:=entree;
end;

function PopQueue():tuple; // pop the lowest cost value in queue
var dummy:integer;
    ind,va:Integer;
begin
  if Length(queue)>0 then
  begin
    ind:=0;
    va:=queue[ind].cout;
    for dummy:=0 to  Length(queue)-1 do 
    begin
      if queue[dummy].cout<va then 
      begin
        va:=queue[dummy].cout;
        ind:=dummy;
      end;    
    end;
    PopQueue.cout:=queue[ind].cout;
    PopQueue.x:=queue[ind].x;
    PopQueue.y:=queue[ind].y;
    PopQueue.dx:=queue[ind].dx;
    PopQueue.dy:=queue[ind].dy;
    for dummy:=ind+1 to  Length(queue)-1 do 
    begin
      queue[dummy-1]:=queue[dummy]; 
    end;
    SetLength(queue,Length(queue)-1);
  end
  else
  begin
    PopQueue.cout:=-1;
    PopQueue.x:=-1;
    PopQueue.y:=-1;
    PopQueue.dx:=-1;
    PopQueue.dy:=-1;
  end;
end;

function SetCacheEntry(entree:tuple):string;
begin;
  SetCacheEntry:=inttostr(entree.x)+','+inttostr(entree.y)+','+inttostr(entree.dx)+','+inttostr(entree.dy);
end;

procedure PushQueue(tcout,tx,ty,tdx,tdy:integer); // Add element into queue if entry is not cached and entry is a valid point on map
var entreetmp:tuple;

begin
  entreetmp.cout:=tcout;
  entreetmp.x:=tx;
  entreetmp.y:=ty;
  entreetmp.dx:=tdx;
  entreetmp.dy:=tdy;
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
    for a:=1 to Length(line) do 
    begin
      carte[a-1,b].valeur:=line[a];
      carte[a-1,b].visited:=0;
      if line[a]='S' then
      Begin
        depart.x:=a-1;
        depart.y:=b;
      end;
      if line[a]='E' then
      Begin
        sortie.x:=a-1;
        sortie.y:=b;
      end;
    end;
    inc(b);
   until (eof(myFile));
  Closefile(myFile); 
end;




begin 
  cache:=TStringList.Create;
  cache.sorted:=true;
  SetLength(queue,0);
  Loadfile(nomfichier);
  entree.cout:=0;
  entree.x:=depart.x;
  entree.y:=depart.y;
  entree.dx:=1;  //go to east first
  entree.dy:=0;
  Addqueue(entree);
  cache.Add(SetCacheEntry(entree));
  Writeln('Searching the lowest cost path to the exit ...');
  while (Length(queue)>0) and not (keypressed) do
  begin
    entree:=PopQueue();
    cout:=entree.cout;
    x:=entree.x;
    y:=entree.y;
    dx:=entree.dx;
    dy:=entree.dy;
    carte[x,y].visited:=1;
    if (x=sortie.x) and (y=sortie.y) then break;
    if (cache.IndexOf(SetCacheEntry(entree))=-1) then cache.Add(SetCacheEntry(entree));
    PushQueue(cout+1,x+dx,y+dy,dx,dy);   // go straight
    PushQueue(cout+1000,x,y,dy,-dx);    // turn left
    PushQueue(cout+1000,x,y,-dy,dx);   // turn right
  end;
  DisplayMap(carte);
  Writeln('Lowest cost : '+IntToStr(cout));
  cache.Free;
end.