{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt, Math, Strutils; 

const opcodestr:array of string=('adv','bxl','bst','jnz','bxc','out','bdv','cdv');


var prog:string;

Function Int64ToBin(a:int64):string; // Default freepascal IntToBin truncate result after 32bits
var quotient:int64;
    dividende:byte;
begin
  Int64ToBin:='';
  repeat
    quotient:=a DIV 2;
    dividende:=a MOD 2;
    if dividende=0 then Int64ToBin:='0'+Int64ToBin else Int64ToBin:='1'+Int64ToBin; 
    a:=quotient;
  until (quotient=0);
  if Length(Int64ToBin)<60 then
  begin
    repeat
      Int64ToBin:='0'+Int64ToBin;
    until Length(Int64ToBin)=60; // not 63, to permit adding 3 digits
  end;
end;


function AddThreeBits(a:int64):int64;
var sa:string;
    cpt,dummy:longint;

begin
  sa:=Int64ToBin(a);
  sa:=sa+'000';
  cpt:=0;
  AddThreeBits:=0;
  for dummy:=length(sa) downto 1 do
  begin
    AddThreeBits:=AddThreeBits+(StrtoInt64(sa[dummy])*(2**cpt));
    inc(cpt);
  end;
end;

function bxl(a,b:int64):int64;
var sa,sb,sout:string;
    cpt,dummy:int64;
    ba,bb:boolean;
begin
  sa:=Int64ToBin(a);
  sb:=Int64ToBin(b);
  cpt:=0;
  sout:='';
  repeat
    if sa[length(sa)-cpt]='0' then ba:=false else ba:=true;
    if sb[length(sb)-cpt]='0' then bb:=false else bb:=true;
    if ((ba xor bb)=false) then sout:='0'+sout else sout:='1'+sout;
    inc(cpt);
  until (cpt=length(sa)) or (cpt=length(sb)); 
  bxl:=0;
  cpt:=0;
  for dummy:=length(sout) downto 1 do
  begin
    bxl:=bxl+(StrtoInt64(sout[dummy])*(2**cpt));
    inc(cpt);
  end;
end;

function bst(a:int64):int64;
var dummy,cpt,resultat:int64;
    sresult:string;
begin
  resultat:=a mod 8;
   sresult:=Int64ToBin(resultat);
  bst:=0;
  cpt:=0;
  for dummy:=length(sresult) downto length(sresult)-2 do
  begin
    bst:=bst+(StrtoInt64(sresult[dummy])*(2**cpt));
    inc(cpt);
  end;
end;


function run(main:string;pointeur:Integer;registre:int64):int64;
Var b,c,sr:int64;
    a:int64;
    pc:byte;
    resultat,dummy:int64;
    opcode:char;
    operande:char;
    operande_value:int64;
    output:string;

begin
  if (pointeur=0) then exit(registre);

  for dummy:=AddThreeBits(registre) to AddThreeBits(registre)+7 do 
  begin
    a:=dummy;    
    b:=0;
    c:=0;
    pc:=1;
    sr:=0;
    output:='';
    repeat
      opcode:=main[pc];
      operande:=main[pc+1];
      case operande of
        '0': operande_value:=0;
        '1': operande_value:=1;
        '2': operande_value:=2;
        '3': operande_value:=3;
        '4': operande_value:=a;
        '5': operande_value:=b;
        '6': operande_value:=c;
        '7': sr:=1;
      end;
      if opcode='0' then  //adv -> a/2^operand 
      begin
        a:=trunc(a/(2**operande_value));
      end;         

      if opcode='1' then  //bxl -> XOR 
      begin
        b:=bxl(b,strtoint64(operande));
      end;

      if opcode='2' then  //bst -> mod 8 
      begin
        b:=bst(operande_value);
      end;

      if opcode='4' then  //bxc -> XOR with registry c  
      begin
        b:=bxl(b,c);
      end;

      if opcode='5' then  //out  
      begin
        output:=output+IntToStr(bst(operande_value));
      end;

      if opcode='6' then  //bdv -> b/2^operand 
      begin
        b:=trunc(a/(2**operande_value));
      end;    

      if opcode='7' then  //cdv -> a/2^operand 
      begin
        c:=trunc(a/(2**operande_value));
      end;    

      if opcode='3' then  //jnz -> jump if not zero 
      begin
        if a<>0 then pc:=strtoint64(operande)+1 else pc:=pc+2;
      end
      else
        pc:=pc+2;
    until (pc>length(main)) or (sr=1);
    if (output=copy(main,pointeur,Length(main))) then
    begin
        resultat:=run(main,pointeur-1,dummy);
        if (resultat<>-1) then exit(resultat);
    end
    else
    begin
       run:=-1;
    end;
  end;
end;
 
Begin
  prog:='2,4,1,4,7,5,4,1,1,4,5,5,0,3,3,0';

// prog in more comprehensive way ... ;-)
//
// main: MOVE.L A,B
//       LSR.B #3,B
//       EOR.L #%100,B   
//       MOVE.L A,C
//       LSR.B #3,C
//       EOR.L C,B
//       EOR.L #%100,B    
//       LSR.B #3,B
//       
//       MOVE.W  B,(-sp)
//       MOVE.W  #2,(-sp)            
//       TRAP  #1             
//       ADDQ.L #4,sp
//
//       LSR.B #3,A
//       CMP.W #0,A
//       BNE main   
//       
//
//       -> output depends on 3 last digits of a

  prog:=StringReplace(prog,',','',[rfReplaceAll, rfIgnoreCase]);
  Writeln('Output : '+IntToStr(run(prog,Length(prog),0)));
end.