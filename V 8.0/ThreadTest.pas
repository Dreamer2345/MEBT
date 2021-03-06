program ThreadTest;
{$mode objfpc}  
 
uses  
  sysutils {$ifdef unix},cthreads{$endif} ;  
 
const  
  threadcount = 100;  
  stringlen = 10000;  
 
var  
   finished : longint;  
 
threadvar  
   thri : ptrint;  
 
function f(p : pointer) : ptrint;  
 
var  
  s : ansistring;  
 
begin  
  Writeln('thread ',longint(p),' started');  
  thri:=0;  
  while (thri<stringlen) do  
    begin  
    s:=s+'1';  
    inc(thri);  
    end;  
  Writeln('thread ',longint(p),' finished');  
  InterLockedIncrement(finished);  
  f:=0;  
end;  
 
var  
   i : longint;  
 
begin  
   finished:=0;  
   for i:=1 to threadcount do  
     BeginThread(@f,pointer(i));  
   while finished<threadcount do ;  
   Writeln(finished);  
end.  