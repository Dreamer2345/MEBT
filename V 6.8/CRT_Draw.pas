unit CRT_Draw;

interface
const MINX = 1;
	  MINY = 1;
	  MAXX = 80;
	  MAXY = 22;

type
	Tground = record
	gt:integer;
	fg:boolean;
	end;			  
	 
procedure WriteCenter(x,y:integer;st:string);
procedure animate(VersionNum:string);
function IntToStr (I : longint) : String;
function itemlist(x:integer):string;
procedure loadbar(d,df,cd:integer;stri:string;DEBUG:boolean);
	
implementation
uses crt;  				  

procedure WriteCenter(x,y:integer;st:string);
var l:integer;
begin
l := length(st);
gotoxy(x-round(l/2),y);
write(st);
end;

function IntToStr (I : longint) : String;
var S : String;
begin
 str (I,S);
 IntToStr:=S;
end;

function itemlist(x:integer):string;
begin
		case x of
		1:itemlist:='';
		0:itemlist:='Stone';
		2:itemlist:='mhril';
		3:itemlist:='grmite';
		4:itemlist:='prite';
		5:itemlist:='drnite';
		6:itemlist:='Trap';
		7:itemlist:='Door';
		10:itemlist:='Money';
		11:itemlist:='Hpak';
		12:itemlist:='chest';
		13:itemlist:='bed';
		14:itemlist:='Stairs';
		16:itemlist:='log';
		17:itemlist:='Stalite';
		18:itemlist:='Axe';
		19:itemlist:='Plank';
		end;
end;

procedure animate(VersionNum:string);
var s1:array[1..6] of string;
	s:string;
	b,k,a,i,j:integer;
begin
cursoroff;
randomize;
textbackground(0);
clrscr;
textcolor(15);

s1[1]:='.-.-. .-.-. .-..--. .-..-.   .-..-.   .-. .-..-..-. .-..-.';
s1[2]:='| |~.-.~| | | | ~~  | | ~.-. | | ~.-. | | | | ~ | | | | ~ ';
s1[3]:='| |  ~  | | | | _   | |  | | | |.-.~  | | | |   | |  \|   ';
s1[4]:='| |     | | | |`-`  | |  | | | | ~.-. | | | |   | |    |\ ';
s1[5]:='| |     | | | | __  | | _`-` | |  | | | | | | _ | |  _ | |';
s1[6]:='`-`     `-` `-``--` `-``-`   `-`  `-` `-` `-``-``-` `-``-`';

k:=1;

for i:=1 to 6 do
	begin
	s:=s1[i];
	j:=length(s);
	for a:=1 to j do
		begin
		gotoxy(a+(40-round(j/2)),k);
		write(s[a]);
		end;
	k:=k+1;
	end;


s1[1]:='.-..--. .-..-.  .-. .-..--.  .-. .-..-.  .-. .-..--. ';
s1[2]:='| | ~~  | | ~.-.| | | | ~~   | | | | ~.-.| | | | ~~  ';
s1[3]:='| | _   | |   ~ | | | |  __  | | | |   ~ | | | | _   ';
s1[4]:='| |`-`  | |     | | | | `. | | | | |     | | | |`-`  ';
s1[5]:='| | __  | |     | | | | _| | | | | |     | | | | __  ';
s1[6]:='`-``--` `-`     `-` `-``---` `-` `-`     `-` `-``--` ';


for i:=1 to 6 do
	begin
	s:=s1[i];
	j:=length(s);
	for a:=1 to j do
		begin
		gotoxy(a+(40-round(j/2)),k);
		write(s[a]);
		end;
	k:=k+1;
	end;


WriteCenter(40,k,'V'+VersionNum);
k:=k+1;

while not keypressed do
	begin
	for a:=1 to 80 do
		begin
		gotoxy(a,k);
		case b of
		1:write('/');
		2:write(chr(15));
		3:write('-');
		4:write(chr(15));
		5:write('\');
		6:write(chr(15));
		7:write('|');
		8:write(chr(15));
		end;
		end;
	delay(100);
	b:=b+1;
	if b > 8 then
		b:=1;
	end;
	

end;

procedure loadbar(d,df,cd:integer;stri:string;DEBUG:boolean);
var k,i,j:integer;
	iss:string;
begin
if DEBUG = false then
begin
	delay(10);
	i:=round(d/df*100);
	if (d <= 2) then
		for j:=1 to 19 do
			begin
			gotoxy(round(j)+30,12);
			write(chr(176));
			k:=length(stri);
			k:=round(k/2);
			gotoxy(40-k,11);
			write(stri);
			end;

	if (d = df) then
		clrscr;
			
	if not (i = cd) then
	begin
		for j:=1 to 20 do
			begin
				if (i > j*5) then
					begin
					gotoxy(round(j)+30,12);
					write(chr(219));
					iss:=IntToStr(i);
					k:=length(iss)+1;
					k:=round(k/2);
					gotoxy(40-k,13);
					write(i,'%');
					end;
			end;
	end;
	cd:=i;
end;

end;
end.
