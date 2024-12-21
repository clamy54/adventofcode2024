{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt; 

const nomfichier='input.txt';
      maxbytes=1024;

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
     bestpath,cout,x,y:Integer;
     cache:TStringList;
     
    


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


function SetCacheEntry(entree:tuple):string;
begin;
  SetCacheEntry:=inttostr(entree.x)+','+inttostr(entree.y);
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

procedure PushQueue(tcout,tx,ty:integer); // Add element into queue if entry is not already visited and entry is a valid point on map
var entreetmp:tuple;

begin
  entreetmp.cout:=tcout;
  entreetmp.x:=tx;
  entreetmp.y:=ty;
  if (tx>0) and (tx<largeur-1) and (ty>0) and (ty<hauteur-1) then 
  begin
    if (carte[tx,ty].valeur<>'#') and (carte[tx,ty].visited=0) then
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
var a,b,c:integer;
    line:string;
    myFile : TextFile;
    elements:TStringList;
begin
  elements := TStringList.Create; 

  largeur:=70;
  hauteur:=70;

  largeur:=largeur+3;
  hauteur:=hauteur+3;
  // dimensionnement du tableau
  SetLength(carte, largeur, hauteur);

  for b:=0 to hauteur-1 do 
    for a:=0 to largeur-1 do 
    begin
     carte[a,b].valeur:='.';
     carte[a,b].visited:=0;      
    end;

  for a:=0 to largeur-1 do 
  begin
    carte[a,0].valeur:='#';
    carte[a,0].visited:=0;    
    carte[a,hauteur-1].valeur:='#';
    carte[a,hauteur-1].visited:=0;    
    carte[largeur-1,a].valeur:='#';
    carte[largeur-1,a].visited:=0;    
    carte[0,a].valeur:='#';
    carte[0,a].visited:=0;    
  end;

  depart.x:=1;
  depart.y:=1;
  sortie.x:=largeur-2;
  sortie.y:=hauteur-2;
  AssignFile(myFile, nom);
  Reset(myFile);
  for c:=1 to maxbytes do
  begin
    ReadLn(myFile, line);
    Split(',', line, elements);
    if elements.Count=2 then 
    begin
      a:=StrToInt(elements[0]);
      b:=StrToInt(elements[1]);
      carte[a+1,b+1].valeur:='#';
      carte[a+1,b+1].visited:=0; 
    end;
  end;
  Closefile(myFile); 
  elements.Free;
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
  bestpath:=-1;
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
      if (x=sortie.x) and (y=sortie.y) then
      begin
        bestpath:=cout;
        Break
      end;
      PushQueue(cout+1,x,y+1);    // go south
      PushQueue(cout+1,x+1,y);   // go east
      PushQueue(cout+1,x-1,y);   // go west 
      PushQueue(cout+1,x,y-1);   // go north
    end;
  end;
  DisplayMap(carte);
  Writeln('Smallest path to the exit : '+IntToStr(bestpath));
  cache.Free;
end.