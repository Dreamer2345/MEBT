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
var I:integer;
begin
	I:=35;
		if not (x > I) then
		case x of
			1:itemlist:='';
			0:itemlist:='Stone';
			2:itemlist:='Mhril';
			3:itemlist:='Grmite';
			4:itemlist:='Prite';
			5:itemlist:='Drnite';
			6:itemlist:='Trap';
			7:itemlist:='Door';
			10:itemlist:='Money';
			11:itemlist:='Hpak';
			12:itemlist:='Chest';
			13:itemlist:='Bed';
			14:itemlist:='Stairs';
			16:itemlist:='log2';
			17:itemlist:='Stalite';
			18:itemlist:='Axe';
			19:itemlist:='Plank';
			20:itemlist:='W-Wall';
			21:itemlist:='S-Wall';
			22:itemlist:='S-Brick';
			23:itemlist:='Spear';
			24:itemlist:='S-Floor';
			25:itemlist:='W-Floor';
			26:itemlist:='Saping';
			27:itemlist:='Appa';
			28:itemlist:='S-Appa';
			29:itemlist:='S-Hpac';
			30:itemlist:='T-Seed';
			31:itemlist:='Log';
			32:itemlist:='Cog';
			33:itemlist:='Hinge';
			34:itemlist:='Kindlin';
			35:itemlist:='F-start';
		end;
		
		if (x > I) then
			itemlist:='err:'+IntToStr(x-I);
		
end;

procedure animate(VersionNum:string);
var s1:array[1..6] of string;
	s:string;
	b,k,a,i,j,d,r,x,y:integer;
	ptx,pty,ptc:array[1..15] of integer;
	done:boolean;
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

r:=5;
k:=1;
d:=1;
for i:=1 to 6 do
	begin
	s:=s1[i];
	j:=length(s);
	if d = 1 then
		begin
		for a:=1 to j do
			begin
			gotoxy(a+(40-round(j/2)),k);
			write(s[a]);
			delay(r);
			end;
		end;
	if d = 0 then
		begin
		for a:=j downto 1 do
			begin
			gotoxy(a+(40-round(j/2)),k);
			write(s[a]);
			delay(r);
			end;
		end;

	if d = 1 then
		d:=0
	else 
		d:=1;
	
	k:=k+1;
	if keypressed then
		r := 0;
	end;


s1[1]:='.-..--. .-..-.  .-. .-..--.  .-. .-..-.  .-. .-..--. ';
s1[2]:='| | ~~  | | ~.-.| | | | ~~   | | | | ~.-.| | | | ~~  ';
s1[3]:='| | _   | |   ~ | | | |  __  | | | |   ~ | | | | _   ';
s1[4]:='| |`-`  | |     | | | | `. | | | | |     | | | |`-`  ';
s1[5]:='| | __  | |     | | | | _| | | | | |     | | | | __  ';
s1[6]:='`-``--` `-`     `-` `-``---` `-` `-`     `-` `-``--` ';

d:=1;
for i:=1 to 6 do
	begin
	s:=s1[i];
	j:=length(s);
	if d = 1 then
		begin
		for a:=1 to j do
			begin
			gotoxy(a+(40-round(j/2)),k);
			write(s[a]);
			delay(r);
			end;
		end;
	if d = 0 then
		begin
		for a:=j downto 1 do
			begin
			gotoxy(a+(40-round(j/2)),k);
			write(s[a]);
			delay(r);
			end;
		end;

	if d = 1 then
		d:=0
	else 
		d:=1;
	
	k:=k+1;
	if keypressed then
		r := 0;
	end;


WriteCenter(40,k,'V'+VersionNum);
WriteCenter(40,k+2,'Press Enter '+chr(27)+chr(217));
k:=k+1;

if r = 0 then
	while keypressed do readkey;
	
for i:=1 to 15 do
	begin
	ptx[i]:=40;
	pty[i]:=k+5;
	ptc[i]:=random(15)+1;
	end;
j:=1;	
while not keypressed do
	begin
	for i:=1 to 15 do
	begin
		x:=ptx[i];
		y:=pty[i];
		textcolor(ptc[i]);
		gotoxy(x,y);
		write(' ');
		r:=random(4)+1;
		if r = 1 then
			x:=x+1;
		if r = 2 then
			x:=x-1;
		if r = 3 then
			y:=y+1;
		if r = 4 then
			y:=y-1;
		if y < k+2 then
			y:=k+3;
		if y > 24 then
			y:=23;
		if x > 80 then
			x:=80;
		if x < 1 then
			x:=1;
		gotoxy(x,y);
		write('@');
		ptx[i]:=x;
		pty[i]:=y;
		b:=ptc[i];
		r:=random(2)+1;
		if r = 1 then
			b:=b+1
		else	
			b:=b-1;
		if b <= 0 then
			b:=1;
		if b > 15 then
			b:=15;
		ptc[i]:=b;
	end;
	textcolor(15);
	for a:=1 to 80 do
		begin
		gotoxy(a,k);
		case d of
		0:write('/');
		5:write('-');
		10:write('\');
		15:write('|');
		end;
		end;
	delay(100);
	d:=d+1;
	if d = 18 then
		d:=0;
	end;
textcolor(15);
for a:=1 to 80 do
	begin
	gotoxy(a,k);
	write('-');
	end;
done := false;
repeat 	
delay(50);
for i:=1 to 15 do
	begin
	x:=ptx[i];
	y:=pty[i];
	textcolor(ptc[i]);
	gotoxy(x,y);
	write(' ');
	if y < k+5 then
		y:=y+1;
	if y > k+5 then
		y:=y-1;
	if x > 40 then
		x:=x-1;
	if x < 40 then
		x:=x+1;
	gotoxy(x,y);
	write('@');
	ptx[i]:=x;
	pty[i]:=y;
	b:=ptc[i];
	r:=random(2)+1;
	if r = 1 then
		b:=b+1
	else	
		b:=b-1;
	if b <= 0 then
		b:=1;
	if b > 15 then
		b:=15;
	ptc[i]:=b;
	end;
r:=0;
for i:=1 to 15 do
	begin
	x:=ptx[i];
	y:=pty[i];
	if (y = k+5) and (x = 40)then
		r:=r+1
	else
		r:=0;
	end;
if (r = 15) then
	done:=true;
until done = true;
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
