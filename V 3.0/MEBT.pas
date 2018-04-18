program MEBT;
{.  . .-. .-. .-. .-. .-. .-.}    
{|\/| |-  |  )|(   |  | | `-.}    
{'  ` `-' `-' ' ' `-' `-' `-'}   
{.-. . . .-. .-. . . .-.   }
{|-  |\| |..  |  |\| |-    }
{`-' ' ` `-' `-' ' ` `-'   }
{.-.   .-.     .--..-.      .-----.  }
{| |   | |      ~~ | |      _~~~~~_  }
{| |   | |       _ | |     | |\  | | }
{| |   | |      `-'| |     | | \ | | }
{`-' _ `-'      __ | |  _   ~___\_~  }
{   `-'        `--'`-' `-'  `-----' }
{welcome to the MEDRIROS ENGINE BETA TEST} 
{Version 3.0}
{Things to remember}
{*it will break if you touch the scripts with do not touch}
{*You can edit the scripts that are labelled 'can Touch This Script'}
{*if it says 'can Touch This Script'
there are instructions on how to add new blocks}
{*if it isn't clear enough here is the run down}
{*in the MEDRIROS ENGINE there is a procedure called update
this is where you put your block to be in the world}
{*If you want a door you have to edit the walking script (Not recommended)}
{*To Make a crafting recipe for your block go into the
craft procedure and add the script for your block}
{*to make your block pick-up-able you need to go to the
invt(inventory script) and add it whit the instructions included}
{*If you break it resort back to a later version and
always copy the main script as a backup}
{*BTW there  are bugs if found please tell me in the .txt file provided }
{Code by Thomas.B}
uses crt,math;

const MAXX = 80;
	  MAXY = 22;
	  MINX = 1;
	  MINY = 1;
	  MAXE = 5;
	  
var map,c:array[MINX..MAXX,MINY..MAXY] of integer;
	enm,ent,enx,eny:array[1..MAXE] of integer;
	sve,n,ms,s,h,d,pl,pd,px,py,ph:integer;
	txtfile,str:string;
	inv:array[1..10] of integer;
	MO:array[1..10] of integer;
	F : textfile;
	
{Do Not Touch This Script IT WILL BREAK!!!}	
procedure make();
var k,s,bl,a,d,x,y,r,r1,i,j:integer;
begin
cursoroff;
randomize;
bl := 0;
pl := 0;
ph := 100;

for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		map[i,j]:=8;
		
for i:=MINX+1 to MAXX-1 do
	for j:=MINY+1 to MAXY-1 do
		map[i,j]:=0;

for i := 1 to 10 do
	inv[i]:=1;

		
x:=MINX+10;
y:=MINY+10;
d:=1;		
for i:=1 to 2000 do
	begin
	r := random(5);
	if r = d then
		case d of
		1:y:=y-1;
		2:y:=y+1;
		3:x:=x-1;
		4:x:=x+1;
		end;
			
	case r of
	1:x:=x+1;
	2:x:=x-1;
	3:y:=y+1;
	4:y:=y-1;
	end;
	
	if y < MINY+1 then
		y:=y+1;
	if y > MAXY-1 then
		y:=y-1;
	if x < MINX+1 then
		x:=x+1;
	if x > MAXX-1 then
		x:=x-1;
	
	if map[x,y] = 0 then
	begin
	bl := bl + 1;
	map[x,y]:=1;
	end;
	d := r;	
		
	end;	
for k:=1 to 10 do		
 for i:=MINX+1 to MAXX-1 do
  for j:=MINY+1 to MAXY-1 do
		begin
		a:=0;
		d:=0;
		
		
		if map[i-1,j] = 1 then
			a := a+1;
		if map[i+1,j] = 1 then
			a := a+1;	
		if map[i,j-1] = 1 then
			a := a+1;
		if map[i,j+1] = 1 then
			a := a+1;
		if map[i+1,j+1] = 1 then
			a := a+1;
		if map[i+1,j-1] = 1 then
			a := a+1;
		if map[i-1,j+1] = 1 then
			a := a+1;
		if map[i-1,j-1] = 1 then
			a := a+1;
			
		if a > 5 then
		begin
		c[i,j]:=1;
		bl := bl + 1;
		end;
		if a <= 4 then
		begin
		c[i,j]:=0;	
		bl := bl - 1;
		end;
		end;

for i:=MINX+1 to MAXX-1 do
	 for j:=MINY+1 to MAXY-1 do		
		begin
		map[i,j]:=c[i,j];
		end;

for i:=MINX+1 to MAXX-1 do
	 for j:=MINY+1 to MAXY-1 do		
		begin
		r := random(10);
		if map[i,j] = 0 then
			case r of
			1:map[i,j]:=2;
			2:map[i,j]:=3;
			3:map[i,j]:=4;
			4:map[i,j]:=5;
			end;
		end;
s:=0;		
r1 := random(5)+1;		
for i:=MINX+1 to MAXX-1 do
	 for j:=MINY+1 to MAXY-1 do
		begin
		if r1 > 0 then
			begin
			a:=0;
			if map[i-1,j] = 1 then
				a := a+1;
			if map[i+1,j] = 1 then
				a := a+1;	
			if map[i,j-1] = 1 then
				a := a+1;
			if map[i,j+1] = 1 then
				a := a+1;
			if map[i+1,j+1] = 1 then
				a := a+1;
			if map[i+1,j-1] = 1 then
				a := a+1;
			if map[i-1,j+1] = 1 then
				a := a+1;
			if map[i-1,j-1] = 1 then
				a := a+1;
			r := random(round(bl/300));
			if a <= 6 then
				if a >= 4 then
					if r = 1 then
					begin
						map[i,j]:=9;
						r1:=r1-1;
						s := s + 1;
					end;	
			end;
		end;
		
for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		begin
		gotoxy(i,j);
		
		if map[i,j] = 0 then
			begin
			textcolor(7);
			textbackground(7);
			end;
		if map[i,j] = 9 then
			begin
			textcolor(12);
			textbackground(14);
			write(chr(35));
			end;
		if map[i,j] > 0 then
			if map[i,j] < 9 then
			begin
			textcolor(map[i,j]);
			textbackground(map[i,j]);
			end;
		if map[i,j] < 9 then
			write(map[i,j]);
		end;
px := 1;
py := 1;	
d := 0;
for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		if d = 0 then
		
		if map[i,j] = 1 then
			begin
			textcolor(9);
			gotoxy(i,j);
			write(chr(2));
			px := i;
			py := j;
			d := 1;
			end;	
end;

{can Touch This Script}	
procedure invt(b:integer);
var k,i:integer;
	str:string;
begin
k:=0;
for i := 1 to 10 do
	begin
	if k = 0 then
		if inv[i] = 1 then
		begin
		k:=1;
		sve:=1;
		if pl > 10 then
		begin
		{craft-able items in here}
		{Use this script \/}
			{if b = (item No.) then
				begin
					inv[i]:=(item No.);
					pl:=pl+3;
					case pd of
						1:begin gotoxy(px-1,py);  textcolor(1);
					textbackground(1);	write('1');	map[px-1,py] := 1; end;
						2:begin gotoxy(px+1,py);  textcolor(1);
					textbackground(1);	write('1');	map[px+1,py] := 1; end;
						3:begin	gotoxy(px,py-1);  textcolor(1);
					textbackground(1);	write('1');	map[px,py-1] := 1; end;
						4:begin	gotoxy(px,py+1);  textcolor(1);
					textbackground(1);	write('1');	map[px,py+1] := 1; end;
					end;
				end;}
		{Add it here \/}
		{<-----------------------}
						
		{<-----------------------}	
		
		
		
			if b = 7 then
				begin
			
				inv[i]:=7;
				pl:=pl+3;
			case pd of
			1:begin gotoxy(px-1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px-1,py] := 1; end;
			2:begin gotoxy(px+1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px+1,py] := 1; end;
			3:begin	gotoxy(px,py-1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py-1] := 1; end;
			4:begin	gotoxy(px,py+1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py+1] := 1; end;
			end;
			end;
			if b = 6 then
				begin
			
				inv[i]:=6;
				pl:=pl+3;
			case pd of
			1:begin gotoxy(px-1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px-1,py] := 1; end;
			2:begin gotoxy(px+1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px+1,py] := 1; end;
			3:begin	gotoxy(px,py-1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py-1] := 1; end;
			4:begin	gotoxy(px,py+1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py+1] := 1; end;
			end;
			end
		end;
		if pl <= 10 then
			if b = 0 then
			begin
				inv[i]:=0;
				pl:=pl+1;
			case pd of
			1:begin gotoxy(px-1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px-1,py] := 1; end;
			2:begin gotoxy(px+1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px+1,py] := 1; end;
			3:begin	gotoxy(px,py-1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py-1] := 1; end;
			4:begin	gotoxy(px,py+1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py+1] := 1; end;
			end;
			end;		
		if pl > 10 then
			begin
			if b = 0 then
			begin
				inv[i]:=0;
				pl:=pl+1;
			case pd of
			1:begin gotoxy(px-1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px-1,py] := 1; end;
			2:begin gotoxy(px+1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px+1,py] := 1; end;
			3:begin	gotoxy(px,py-1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py-1] := 1; end;
			4:begin	gotoxy(px,py+1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py+1] := 1; end;
			end;
			end;
			
			if b = 2 then
				begin
				inv[i]:=2;
				pl:=pl+1;
			case pd of
			1:begin gotoxy(px-1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px-1,py] := 1; end;
			2:begin gotoxy(px+1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px+1,py] := 1; end;
			3:begin	gotoxy(px,py-1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py-1] := 1; end;
			4:begin	gotoxy(px,py+1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py+1] := 1; end;
			end;
			end;
		end;	
		if pl > 20 then
			if b = 3 then
				begin
				inv[i]:=3;
				pl:=pl+1;
			case pd of
			1:begin gotoxy(px-1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px-1,py] := 1; end;
			2:begin gotoxy(px+1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px+1,py] := 1; end;
			3:begin	gotoxy(px,py-1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py-1] := 1; end;
			4:begin	gotoxy(px,py+1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py+1] := 1; end;
			end;
			end;
		if pl > 30 then
			if b = 4 then
				begin
				inv[i]:=4;
				pl:=pl+2;
			case pd of
			1:begin gotoxy(px-1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px-1,py] := 1; end;
			2:begin gotoxy(px+1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px+1,py] := 1; end;
			3:begin	gotoxy(px,py-1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py-1] := 1; end;
			4:begin	gotoxy(px,py+1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py+1] := 1; end;
			end;
			end;
		if pl > 40 then
			if b = 5 then
				begin
				inv[i]:=5;
				pl:=pl+3;
			case pd of
			1:begin gotoxy(px-1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px-1,py] := 1; end;
			2:begin gotoxy(px+1,py);  textcolor(1);
		textbackground(1);	write('1');	map[px+1,py] := 1; end;
			3:begin	gotoxy(px,py-1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py-1] := 1; end;
			4:begin	gotoxy(px,py+1);  textcolor(1);
		textbackground(1);	write('1');	map[px,py+1] := 1; end;
			end;
			end;
		end;
	end;

gotoxy(1,MAXY+1);
for i := 1 to 10 do
	begin
	textcolor(9);
	write(inv[i],':');
	end;
write('           ');
textcolor(14);
write(pl);	
write('           ');
end;

{Do Not Touch This Script IT WILL BREAK!!!}	
procedure drop();
var i,k:integer;
begin
k := 0;
		if map[px,py] = 1 then
			for i := 1 to 10 do
				begin
				if k = 0 then
					if inv[i] < 1 then
						begin
						if inv[i] = 11 then
							ph:=ph + 10
						else
							begin
								map[px,py]:=inv[i];
								inv[i]:=1;
								k:=1;
							end;
						if inv[i] = 11 then
							inv[i]:=1;
						end;
						
				if k = 0 then
					if inv[i] > 1 then
						begin
						if inv[i] = 11 then
							ph:=ph + 10
						else
							begin
								map[px,py]:=inv[i];
								inv[i]:=1;
								k:=1;
							end;
						if inv[i] = 11 then
							inv[i]:=1;
						end;
				end;
				textcolor(9);
				gotoxy(1,MAXY+1);
					for i := 1 to 10 do
				write(inv[i],':');
end;

{can Touch This Script}	
procedure craft();
var error,a,b,i:integer;
	ch,ch1:char;
	str:string;	
begin
gotoxy(1,MAXY+2);
write('ingredient 1:');
readln(ch);
val(ch,a,error);
delline;
if error = 0 then
if a < 10 then
if a > 0 then
begin
gotoxy(1,MAXY+2);
write('ingredient 2:');
readln(ch1);
val(ch1,b,error);
delline;
if error = 0 then
if b < 10 then
if b > 0 then
begin


if inv[a] = 2 then
	if inv[b] = 5 then
		begin
		inv[b]:=1;
		inv[a]:=10;
		sve:=1;
		end;

if inv[a] = 0 then
	if inv[b] = 0 then
		begin
		inv[b]:=1;
		inv[a]:=6;
		sve:=1;
		end;
		
if inv[a] = 2 then
	if inv[b] = 2 then
		begin
		inv[b]:=1;
		inv[a]:=7;
		sve:=1;
		end;

if inv[a] = 3 then
	if inv[b] = 2 then
		begin
		inv[b]:=1;
		inv[a]:=11;
		sve:=1;
		end;
		
{add craft-able items in here}
	{whit this script \/}
	{
		if inv[a] = (item 1 in crafting) then
			if inv[b] = (item 2 in crafting) then
				begin
					inv[b]:=1;
					inv[a]:=(new item no 11+);
					sve:=1;
				end;
	}
	{it wont pick up if you don't Add it in the inventory script}
	{<---------------------------}
						
	{<---------------------------}
		
gotoxy(1,MAXY+2);
textcolor(16);
textbackground(16);
write('                             ');
		textbackground(1);
			textcolor(9);
				gotoxy(1,MAXY+1);
					for i := 1 to 10 do
				write(inv[i],':');
				
end;
end;
gotoxy(1,MAXY+2);
delline;
end;

{Do Not Touch This Script IT WILL BREAK!!!}	
procedure time();
begin

ms:=ms+1;
if ms >= 60 then
begin
s:=s+1;
ms:=1;
end;
if s = 60 then
begin
h:=h+1;
s:=1;
end;
if h = 24 then
begin
d:=d+1;
h:=1;
end;
gotoxy(44,MAXY+1);
textcolor(15);
write(d,':',h,':',s,':',ms);


end;

{Do Not Touch This Script IT WILL BREAK!!!}	
procedure load();
var F:textfile;
	error,i,j,a:integer;
	str:string;
begin	
	write('World to load:');
	readln(txtfile);
	assign(F,txtfile+'.txt');
	reset(F);
	
	readln(F,str);
	val(str,a,error);
	ph:=a;
	
	readln(F,str);
	val(str,a,error);
	px:=a;
	
	readln(F,str);
	val(str,a,error);
	py:=a;
	
	readln(F,str);
	val(str,a,error);
	pl:=a;
	
	readln(F,str);
	val(str,a,error);
	d:=a;

	readln(F,str);
	val(str,a,error);
	h:=a;

	readln(F,str);
	val(str,a,error);
	s:=a;
	
	for i:=1 to 10 do
		begin
		readln(F,str);
		val(str,a,error);
		inv[i]:=a;
		end;
	
	for i:=1 to 80 do
		for j:=1 to 22 do
			begin
			readln(F,str);
			val(str,a,error);
			if error = 0 then
				map[i,j]:=a
			else begin
			halt(5);
			end;
			end;
	close(F);
	
	for i:=1 to 80 do
		for j:=1 to 22 do
			begin
			gotoxy(i,j);
			
		if map[i,j] = 0 then
			begin
			textcolor(7);
			textbackground(7);
			end;
		if map[i,j] = 9 then
			begin
			textcolor(12);
			textbackground(14);
			write(chr(35));
			end;
		if map[i,j] > 0 then
			if map[i,j] < 9 then
			begin
			textcolor(map[i,j]);
			textbackground(map[i,j]);
			end;
		if map[i,j] < 9 then
			write(map[i,j]);
			end;
			textcolor(9);
			gotoxy(px,py);
			write(chr(2));
end;

{Do Not Touch This Script IT WILL BREAK!!!}	
procedure save();
var F:textfile;
	error,i,j,a:integer;
	ch:char;
begin
	sve:=0;
	if txtfile = '' then
		begin
		for i:=30 to 50 do
					for j:=10 to 16 do
						begin
							gotoxy(i,j);
							write(chr(0));
						end;
		gotoxy(30,10);
		write('No save file exists');
		gotoxy(30,11);
		write('Create new save name?');
		gotoxy(30,12);
		readln(str);
		txtfile:=str;
		textcolor(8);
		for i:=30 to 50 do
					for j:=10 to 16 do
						begin
							gotoxy(i,j);
							write(chr(0));
						end;
		gotoxy(30,10);
		write('Exit');
		gotoxy(30,11);
		write('Quit');
		gotoxy(30,12);
		write('Debug');
		gotoxy(30,13);
		write('Help');
		gotoxy(30,14);
		write('Save');
		
		assign(F,txtfile+'.txt');
		rewrite(F);
		writeln('');
		close(F);
		end;
		
	assign(F,txtfile+'.txt');
	rewrite(F);
	writeln(F,ph);
	writeln(F,px);
	writeln(F,py);
	writeln(F,pl);
	writeln(F,d);
	writeln(F,h);
	writeln(F,s);
	for i:=1 to 10 do
		writeln(F,inv[i]);
	
	for i:=1 to 80 do
		for j:=1 to 22 do
		begin
		writeln(F,map[i,j]);
		end;
	close(F);
end;


{Do Not Touch This Script IT WILL BREAK!!!}
procedure Menu();
var E,m,m1,i,j:integer;
	str:string;
begin
gotoxy(30,10);
textbackground(8);
textcolor(8);
for i:=30 to 50 do
	for j:=10 to 15 do
		begin
		gotoxy(i,j);
		write(chr(0));
		end;
gotoxy(30,10);
write('Exit');
gotoxy(30,11);
write('Quit');
gotoxy(30,12);
write('Debug');
gotoxy(30,13);
write('Help');
gotoxy(30,14);
write('Save');

m:=1;
E:=0;
repeat


if keypressed then
	str:=readkey;
	begin
	m1:=m;
	case str of
		#72:m:=m-1;
		#80:m:=m+1;
		#27:E:=1;
		#13:case m of 
		1:E:=1;
		2:begin
		if sve = 1 then
			begin
			for i:=30 to 50 do
					for j:=10 to 16 do
						begin
							gotoxy(i,j);
							write(chr(0));
						end;
			gotoxy(30,10);
			writeln('Do you want to quit');
			gotoxy(30,11);
			writeln('without saving? y/n');
			gotoxy(30,12);
			readln(str);
			if str = 'y' then
				halt()
			else
				save();
			end;
			halt();
		end;
		
		3:begin {Add debugging info in here} h:=16; end;
		4:begin for i:=30 to 50 do
					for j:=10 to 16 do
						begin
							gotoxy(i,j);
							write(chr(0));
						end;
			gotoxy(30,10);
			write('B = pick-up');
			gotoxy(30,11);
			write('V = Place');
			gotoxy(30,12);
			write('c = Craft');
			gotoxy(30,13);
			write('Esc = menu');
			gotoxy(30,14);
			write('arrow keys to move');
			readln;
			for i:=30 to 50 do
					for j:=10 to 16 do
						begin
							gotoxy(i,j);
							write(chr(0));
						end;
			textcolor(8);
			gotoxy(30,10);
			write('Exit');
			gotoxy(30,11);
			write('Quit');
			gotoxy(30,12);
			write('Debug');
			gotoxy(30,13);
			write('Help');
			gotoxy(30,14);
			write('Save');
			
		end;
		5:save();
	
	end;
	end;
	if m < 1 then 
		m:=5;
	if m > 5 then
		m:=1;
		
	gotoxy(30,9+m1);
	textcolor(8);
	case m1 of 
		1:write('Exit');
		2:write('Quit');
		3:write('Debug');
		4:write('Help');
		5:write('Save');
		
	end;
	gotoxy(30,9+m);
	textcolor(2);
	case m of 
		1:write('Exit');
		2:write('Quit');
		3:write('Debug');
		4:write('Help');
		5:write('Save');
		
	end;
	end;
	str:='#';
	
	
	
until E = 1;

for i:=30 to 50 do
	for j:=10 to 16 do
		begin
		gotoxy(i,j);
		
		if map[i,j] = 0 then
			begin
			textcolor(7);
			textbackground(7);
			end;
		if map[i,j] = 9 then
			begin
			textcolor(12);
			textbackground(14);
			write(chr(35));
			end;
		if map[i,j] > 0 then
			if map[i,j] < 9 then
			begin
			textcolor(map[i,j]);
			textbackground(map[i,j]);
			end;
		if map[i,j] < 9 then
			write(map[i,j]);
		end;			
end;

{can Touch This Script}	
procedure update();
var ch:char;
	i,x,y,k:integer;
	begin
	if keypressed() then
		begin
		sve:=1;
		x := px;
		y := py;
		ch:=readkey;
		case ch of	{if you want a door add it in here as one \/}
            #75 : begin pd := 1; if map[x-1,y] = 1 then px := px-1 else if map[x-1,y] = 7 then px := px-1; end;
            #77 : begin pd := 2; if map[x+1,y] = 1 then px := px+1 else if map[x+1,y] = 7 then px := px+1; end;
            #72 : begin pd := 3; if map[x,y-1] = 1 then py := py-1 else if map[x,y-1] = 7 then py := py-1; end;
            #80 : begin pd := 4; if map[x,y+1] = 1 then py := py+1 else if map[x,y+1] = 7 then py := py+1; end;
			'b' : begin
				case pd of
					1:begin
					k:=map[x-1,y];
					invt(k);
					end;
					2:begin
					k:=map[x+1,y];
					invt(k);
					end;
					3:begin
					k:=map[x,y-1];
					invt(k);
					end;
					4:begin
					k:=map[x,y+1];
					invt(k);
					end;
				end;
			end;
			'v' : drop();
			'c' : craft();
			#27 : menu();
			
		end;
		if ph > 100 then 
			ph:=100;
		gotoxy(55,MAXY+1);
		write('         ');
		gotoxy(55,MAXY+1);
		textcolor(15);
		write('H:',ph);
		
		gotoxy(x,y);
		textcolor(map[x,y]);
		textbackground(map[x,y]);
		
		if map[x,y] = 0 then
			begin
			textcolor(7);
			textbackground(7);
			end;
		if map[x,y] < 6 then
			write(map[x,y]);
		
		if map[x,y] = 6 then
		begin
			textcolor(14);
			textbackground(6);
			write(chr(127));
		end;
		
		if map[x,y] = 7 then
		begin
			textcolor(2);
			textbackground(6);
			write(chr(15));
		end;
		
		if map[x,y] = 9 then
		begin
			textcolor(7);
			textbackground(5);
			write(chr(35));
		end;
		
		if map[x,y] = 10 then
		begin
			textcolor(2);
			textbackground(5);
			write(chr(36));
		end;
			{Add blocks in here with this script}
			{will have to add if walk-able in the step script}
				{if map[x,y] = itemNO. then
					begin
						textcolor(foreground colour);
						textbackground(background colour);
						write(chr(item decal));
				end;}
			{<-----------------}	
						
						
			{<-----------------}
		
		textcolor(9);
		textbackground(1);
		gotoxy(px,py);
		write(chr(2));
		delay(25);
		end;
	time();
	end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure enemy();
var r,a,b,x,y,i,j,k:integer;	
begin

if h >= 16 then
if n = 0 then
begin
k:=1;
for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		if map[i,j] = 9 then
			begin
			eny[k]:=j;
			enx[k]:=i;
			ent[k]:=1;
			k:=k+1;
			n:=1;
			end;
end;	

if h = 7 then
for i:=1 to MAXE do
begin
ent[i] := 0;
n:=0;
end;

for i:=1 to MAXE do
	if ent[i] = 1 then
		begin
		if enm[i] = 100 then
		begin
		x:=enx[i];
		y:=eny[i];
		r := random(10);
			case r of
			1:if map[x-1,y] = 1 then  x:=x-1;
			2:if map[x+1,y] = 1 then x:=x+1;	
			3:if map[x,y-1] = 1 then y:=y-1;
			4:if map[x,y+1] = 1 then y:=y+1;
			end;
			
		k:=0;
		
		if px = x then
		if py = y then
		    if k = 0 then
			begin
			ph:=ph-3;
			k:=1;
			end;
		
			
		gotoxy(enx[i],eny[i]);
		textcolor(1);
		textbackground(1);
		write(chr(0));
		if map[enx[i],eny[i]] = 9 then
			begin
			textcolor(12);
			textbackground(14);
			write(chr(35));
		end;
		
		
		enx[i]:=x;
		eny[i]:=y;
		
		gotoxy(x,y);
		textcolor(4);
		textbackground(1);
		write(chr(1));
		
		
		enm[i]:=0;
		end;
		enm[i]:=enm[i]+1;
		end;
		
end;

{Do Not Touch This Script IT WILL BREAK!!!}		
begin
clrscr;

writeln('Load file? y/n'); 
readln(str);
if str = 'y' then
	load()
else
make();

repeat
cursoroff;
update();
enemy();
until false;
readln;
end.
