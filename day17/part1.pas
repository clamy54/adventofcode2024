{$mode objfpc}{$H+}
uses Sysutils, Classes, Crt, Math, Strutils; 

const opcodestr:array of string=('adv','bxl','bst','jnz','bxc','out','bdv','cdv');

Var a,b,c,sr:integer;
    pc:byte;
    main,output:string;
    opcode:char;
    operande:char;
    operande_value:integer;


function bxl(a,b:integer):integer;
var sa,sb,sout:string;
    cpt,dummy:longint;
    ba,bb:boolean;
begin
  sa:=IntToBin(a,32,0);
  sb:=IntToBin(b,32,0);
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
    bxl:=bxl+(StrtoInt(sout[dummy])*(2**cpt));
    inc(cpt);
  end;
end;

function bst(a:integer):integer;
var dummy,cpt,resultat:integer;
    sresult:string;
begin
  resultat:=a mod 8;
  sresult:=IntToBin(resultat,32,0);
  bst:=0;
  cpt:=0;
  for dummy:=length(sresult) downto length(sresult)-2 do
  begin
    bst:=bst+(StrtoInt(sresult[dummy])*(2**cpt));
    inc(cpt);
  end;
end;

Begin
  a:=25986278;
  b:=0;
  c:=0;
  pc:=1;
  main:='2,4,1,4,7,5,4,1,1,4,5,5,0,3,3,0';
  sr:=0;
  output:='';
  main:=StringReplace(main,',','',[rfReplaceAll, rfIgnoreCase]);
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
    //writeln('A :'+inttostr(a));
    //writeln('B :'+inttostr(b));
    //writeln('C :'+inttostr(c));
    //writeln('PC:'+inttostr(pc));
    //writeln();
    //writeln('Opcode : '+opcode+'('+opcodestr[strtoint(opcode)]+') Operande : '+operande+'('+inttostr(operande_value)+')');
    //readln;

    if opcode='0' then  //adv -> a/2^operand 
    begin
      a:=trunc(a/(2**operande_value));
    end;         

    if opcode='1' then  //bxl -> XOR 
    begin
      b:=bxl(b,strtoint(operande));
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
       if length(output)=0 then output:=IntToStr(bst(operande_value)) else output:=output+','+IntToStr(bst(operande_value));
    end;

    if opcode='6' then  //bdv -> b/2^operand 
    begin
      b:=trunc(a/(2**operande_value));
    end;    

    if opcode='7' then  //cdv -> b/2^operand 
    begin
      c:=trunc(a/(2**operande_value));
    end;    

    if opcode='3' then  //jnz -> jump if not zero 
    begin
      if a<>0 then pc:=strtoint(operande)+1 else pc:=pc+2;
    end
    else
      pc:=pc+2;
    
  until (pc>length(main)) or (sr=1);

  Writeln('Output : '+output);
end.