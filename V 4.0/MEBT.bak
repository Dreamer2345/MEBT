program MEBT;
{.  . .-. .-. .-. .-. .-. .-.}
{|\/| |-  |  )|(   |  | | `-.}
{'  ` `-' `-' ' ' `-' `-' `-'}
{.-. . . .-. .-. . . .-.   }
{|-  |\| |..  |  |\| |-    }
{`-' ' ` `-' `-' ' ` `-'   }
{.-.   .-.     .-.   .-.      .-----.  }
{| |   | |     | | _ | |      _~~~~~_  }
{| |   | |     `-'`-'| |     | |\  | | }
{| |   | |           | |     | | \ | | }
{`-' _ `-'           | |  _   ~___\_~  }
{   `-'              `-' `-'  `-----'  }
{welcome to the MEDRIROS ENGINE BETA TEST}
{Version 4.0}
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
{*BTW there are bugs if found please tell me in the .txt file provided }
{Code by Thomas.B}
uses Dos,crt,math;

const MAXX = 80;
	  MAXY = 22;
	  MINX = 1;
	  MINY = 1;
	  MAXE = 20;

var map,c:array[MINX..MAXX,MINY..MAXY] of integer;
	enm,ent,enx,eny:array[1..MAXE] of integer;
	chesx,chesy:array[1..50] of integer;
	chesinv:array[1..50,1..5] of integer;
	psx,psy,fps,realtime,pretimer,timer,k1,n,ph1,sve,ms,s,h,d,pl,pd,px,py,ph:integer;
	txtfile,str:string;
	inv:array[1..10] of integer;

{can Touch This Script}
procedure block(x,y:integer);
begin
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

		if map[x,y] = 8 then
		begin
			textcolor(8);
			textbackground(0);
			write(map[x,y]);
		end;

		if map[x,y] = 9 then
		begin
			textcolor(12);
			textbackground(14);
			write(chr(35));
		end;

		if map[x,y] = 10 then
		begin
			textcolor(2);
			textbackground(5);
			write(chr(36));
		end;

		if map[x,y] = 12 then
		begin
			textcolor(14);
			textbackground(1);
			write('C');
		end;

		if map[x,y] = 13 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(7));
		end;

		if map[x,y] = 14 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(196));
		end;

		if map[x,y] = 15 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(179));
		end;

		if map[x,y] = 16 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(217));
		end;

		if map[x,y] = 17 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(191));
		end;
		
		if map[x,y] = 18 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(218));
		end;
		
		if map[x,y] = 19 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(192));
		end;
		
		if map[x,y] = 20 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(193));
		end;
		
		if map[x,y] = 21 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(194));
		end;
		
		if map[x,y] = 22 then
		begin
			textcolor(12);
			textbackground(1);
			write(chr(197));
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
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure invmenu;
var e1,a,b,i,j,E,m1,m:integer;
begin


gotoxy(30,10);
textbackground(8);
textcolor(8);
for i:=30 to 50 do
	for j:=5 to 16 do
		begin
		gotoxy(i,j);
		write(chr(0));
		end;
	for i := 1 to 10 do
				begin
				gotoxy(30,4+i);
				textcolor(8);
				write(i,':',inv[i]);
				end;
	gotoxy(30,16);
	textcolor(14);
	write('LVL:',pl);

E:=0;

repeat
if keypressed then
	begin
	str:=readkey;
	m1:=m;
	case str of
		#72:m:=m-1;
		#80:m:=m+1;
		'e':E:=1;
		#27:E:=1;
		#13:begin
		a:=m;
		e1:=0;
		repeat
		str:=readkey;
		m1:=m;
		case str of
			#72:m:=m-1;
			#80:m:=m+1;
			'e':e1:=1;
			#27:e1:=1;
			#13:e1:=1;
		end;
		if (m > 10) then
		m:=1;
		if (m < 1) then
			m:=10;
		if (m1 > 10) then
			m1:=1;
		if (m1 < 1) then
			m1:=10;

		if not (m = m1) then
			begin
					gotoxy(30,4+m1);
					textcolor(8);
					write(m1,':',inv[m1]);
					gotoxy(30,4+m);
					textcolor(2);
					write(m,':',inv[m]);
			end;

		until e1 = 1;
		b:=m;
		if not (a = b) then
			begin
				i:=inv[a];
				j:=inv[b];
				inv[a]:=j;
				inv[b]:=i;
			end;

		gotoxy(30,10);
			textbackground(8);
				textcolor(8);
		for i:=30 to 50 do
			for j:=5 to 16 do
				begin
				gotoxy(i,j);
				write(chr(0));
				end;
			for i := 1 to 10 do
						begin
						gotoxy(30,4+i);
						textcolor(8);
						write(i,':',inv[i]);
						end;
		gotoxy(30,16);
		textcolor(14);
		write('LVL:',pl);


		end;
	end;

    if (m > 10) then
		m:=1;
	if (m < 1) then
		m:=10;
	if (m1 > 10) then
		m1:=1;
	if (m1 < 1) then
		m1:=10;

	if not (m = m1) then
		begin
				gotoxy(30,4+m1);
				textcolor(8);
				write(m1,':',inv[m1]);
				gotoxy(30,4+m);
				textcolor(2);
				write(m,':',inv[m]);
		end;
	end;
	str:='#';
until E = 1;

for i:=30 to 50 do
	for j:=5 to 16 do
		block(i,j);

textbackground(1);
textcolor(1);
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure chest();
var e1,m1,m,E,a,b,l,c,k,i,j,x,y:integer;
	s,s1:string;
begin

case pd of
	1:begin x:=px-1; y:=py; end;
	2:begin x:=px+1; y:=py; end;
	3:begin	x:=px; y:=py-1; end;
	4:begin	x:=px; y:=py+1; end;
end;


k:=0;
for i:=1 to 50 do
	if (chesx[i] = x) and (chesy[i] = y) and (k = 0) then
		begin
		k:=1;
		c:=i;
		end;

if k = 1 then
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
	for i:= 1 to 5 do
	begin
		gotoxy(30,9+i);
		write(i,':',chesinv[c,i]);
	end;

	gotoxy(30,15);
	write('pick-up');
m:=1;
E:=0;

repeat
if keypressed then
	begin
	str:=readkey;
	m1:=m;
	case str of
		#72:m:=m-1;
		#80:m:=m+1;
		#27:E:=1;
		'd':E:=1;
		#13:begin
			if m < 6 then
				begin
					a:=0;
					if (chesinv[c,m] = 1) and (a = 0) then
						begin
						k:=0;
						for i:=1 to 10 do
							if not (inv[i] = 1) and (k = 0) then
								begin
								k:=1;
								chesinv[c,m] := inv[i];
								inv[i]:=1;
								end;
						a:=1;
						end;

					if not (chesinv[c,m] = 1) and (a = 0) then
						begin
						k:=0;
						for i:=1 to 10 do
							if (inv[i] = 1) and (k = 0) then
								begin
								k:=1;
								inv[i]:=chesinv[c,m];
								chesinv[c,m]:=1;
								end;
						a:=1;
						end;

					gotoxy(30,10);
					textbackground(8);
					textcolor(8);
						for i:=30 to 50 do
							for j:=10 to 15 do
								begin
								gotoxy(i,j);
								write(chr(0));
								end;
						for i := 1 to 5 do
							begin
								gotoxy(30,9+i);
								write(i,':',chesinv[c,i]);
							end;

							gotoxy(30,15);
							write('pick-up');

						end;


		if m = 6 then
			begin
			k:=0;
			for i := 1 to 5 do
				if not (chesinv[c,i] = 1)then
					k:=1;
			if (k = 0) then
				begin
					for i:=1 to 10 do
						if (inv[i] = 1) and (k = 0) then
							begin
							k:=1;
							inv[i]:=12;
							map[chesx[c],chesy[c]]:=1;
							chesx[c]:=0;
							chesy[c]:=0;
							block(x,y);
							E:=1;
							end;
				end;
			end;

	end;
	end;

	if m < 1 then
		m:=6;
	if m > 6 then
		m:=1;

	if not (m = m1) then
			begin
				if m < 6 then
					begin
					gotoxy(30,9+m1);
					textcolor(8);
					if m1 < 6 then
						write(m1,':',chesinv[c,m1])
					else
						write('pick-up');
					gotoxy(30,9+m);
					textcolor(2);
					write(m,':',chesinv[c,m]);
					end;
				if m = 6 then
					begin
					gotoxy(30,9+m1);
					textcolor(8);
					write(m1,':',chesinv[c,m1]);
					gotoxy(30,9+m);
					textcolor(2);
					write('pick-up');
					end
			end;

	end;
	str:='#';
until E = 1;

for i:=30 to 50 do
	for j:=10 to 16 do
		block(i,j);

textbackground(1);
textcolor(1);
end;

end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure chesplace(l:integer);
var s:string;
	i,j,k:integer;
begin
map[px,py]:=inv[l];
k:=0;
	for i:=1 to 50 do
		if (chesx[i] = 0) and (chesy[i] = 0) and (k = 0) then
			begin
			chesx[i]:=px;
			chesy[i]:=py;
			for j:=1 to 5 do
				chesinv[i,j]:=1;
			k:=1;
			end;

end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure make();
var k,s,bl,a,d,x,y,r,r1,i,j:integer;
begin
clrscr;
cursoroff;
randomize;
bl := 0;
pl := 0;
ph := 100;
ms:=1;

for i:=1 to 50 do
	begin
	chesx[i]:=0;
	chesy[i]:=0;
	end;
for i:=1 to 50 do
	for j:=1 to 5 do
                chesinv[i,j]:=1;

for i:=1 to MAXE do
ent[i] := 0;

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
r1 := random(20)+3;
for i:=MINX+1 to MAXX-1 do
	 for j:=MINY+1 to MAXY-1 do
		begin
		if r1 >= 0 then
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
			r := random(32);
			if (a <= 3) and (a >= 2) and (r = 1) then
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
		block(i,j);
		end;
px := 1;
py := 1;
d := 0;
for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		if (d = 0) and (map[i,j] = 1) then
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
				
				if a = 8 then
					begin
						textcolor(9);
						gotoxy(i,j);
						write(chr(2));
						px := i;
						py := j;
						psx := i;
						psy := j;
						d := 1;
					end;
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

			if b = 24 then
				begin
				inv[i]:=24;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 23 then
				begin
				inv[i]:=23;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 22 then
				begin
				inv[i]:=22;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 21 then
				begin
				inv[i]:=21;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 20 then
				begin
				inv[i]:=20;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 19 then
				begin
				inv[i]:=19;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 18 then
				begin
				inv[i]:=18;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 17 then
				begin
				inv[i]:=17;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 16 then
				begin
				inv[i]:=16;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 15 then
				begin
				inv[i]:=15;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;


			if b = 14 then
				begin
				inv[i]:=14;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;


			if b = 13 then
				begin
				inv[i]:=13;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 10 then
				begin
				inv[i]:=10;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;


			if b = 7 then
				begin

				inv[i]:=7;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;

			if b = 6 then
				begin
				inv[i]:=6;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;



			if b = 12 then
				begin
					chest();
				end;

		end;

		if (b = 0) or (b <= 5)  and not (b = 1) then
			begin
			if (b = 0) or (b = 2) and (pl >= 20) or (b = 3) and (pl >= 30) or(b = 4) and (pl >= 40) or (b = 5) and (pl >= 50) then
				begin
				inv[i]:=b;
				pl:=pl+1;
					case pd of
						1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
						2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
						3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
						4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
				end;
			end;
		end;
	end;
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
							if inv[i] = 12 then
								chesplace(i)
								else
									begin
										map[px,py]:=inv[i];
										inv[i]:=1;
										k:=1;
									end;
						if inv[i] = 11 then
							inv[i]:=1;
						if inv[i] = 12 then
							begin
							inv[i]:=1;
							k:=1;
							end;
						end;

				if k = 0 then
					if inv[i] > 1 then
						begin
						if inv[i] = 11 then
							ph:=ph + 10
						else
							if inv[i] = 12 then
								chesplace(i)
								else
									begin
										map[px,py]:=inv[i];
										inv[i]:=1;
										k:=1;
									end;
						if inv[i] = 11 then
							inv[i]:=1;
						if inv[i] = 12 then
							begin
							inv[i]:=1;
							k:=1;
							end;
						end;
				end;
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
if (error = 0) and (a < 10) or (a > 0) then
begin
gotoxy(1,MAXY+2);
write('ingredient 2:');
readln(ch1);
val(ch1,b,error);
delline;
if (error = 0) and (b < 10) or (b > 0) then
begin

if inv[a] = 0 then
	if inv[b] = 0 then
		begin
		inv[b]:=1;
		inv[a]:=6;
		sve:=1;
		end;

if inv[a] = 3 then
	if inv[b] = 2 then
		begin
		inv[b]:=1;
		inv[a]:=7;
		sve:=1;
		end;

if inv[a] = 0 then
	if inv[b] = 3 then
		begin
		inv[b]:=1;
		inv[a]:=11;
		sve:=1;
		end;

if inv[a] = 0 then
	if inv[b] = 4 then
		begin
		inv[b]:=1;
		inv[a]:=12;
		sve:=1;
		end;

if inv[a] = 12 then
	if inv[b] = 5 then
		begin
		inv[b]:=1;
		inv[a]:=13;
		sve:=1;
		end;

if inv[a] = 13 then
	if inv[b] = 5 then
		begin
		inv[b]:=1;
		inv[a]:=14;
		sve:=1;
		end;

if inv[a] = 14 then
	if inv[b] = 13 then
		begin
		inv[b]:=1;
		inv[a]:=15;
		sve:=1;
		end;

if inv[a] = 15 then
	if inv[b] = 14 then
		begin
		inv[b]:=1;
		inv[a]:=16;
		sve:=1;
		end;

if inv[a] = 2 then
	if inv[b] = 5 then
		begin
		inv[b]:=1;
		inv[a]:=10;
		sve:=1;
		end;

if inv[a] = 16 then
	if inv[b] = 15 then
		begin
		inv[b]:=1;
		inv[a]:=17;
		sve:=1;
		end;

if inv[a] = 17 then
	if inv[b] = 16 then
		begin
		inv[b]:=1;
		inv[a]:=18;
		sve:=1;
		end;

if inv[a] = 18 then
	if inv[b] = 17 then
		begin
		inv[b]:=1;
		inv[a]:=19;
		sve:=1;
		end;

if inv[a] = 19 then
	if inv[b] = 18 then
		begin
		inv[b]:=1;
		inv[a]:=20;
		sve:=1;
		end;

if inv[a] = 20 then
	if inv[b] = 19 then
		begin
		inv[b]:=1;
		inv[a]:=21;
		sve:=1;
		end;

if inv[a] = 21 then
	if inv[b] = 20 then
		begin
		inv[b]:=1;
		inv[a]:=22;
		sve:=1;
		end;

if inv[a] = 22 then
	if inv[b] = 21 then
		begin
		inv[b]:=1;
		inv[a]:=23;
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
textbackground(0);
delline;
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure frame;
var
  Hour,Min,Sec,HSec : word;
begin
	GetTime(Hour,Min,Sec,HSec);
		if not (realtime = sec) then
			begin
				fps:=timer-pretimer;
				gotoxy(65,MAXY+1);
				textcolor(15);
				textbackground(0);
				write('FPS:',fps,' ');
				pretimer:=timer;
				realtime:=sec;
				if timer >= 1000 then
					begin	
						timer:=0;
						pretimer:=0;
					end;
			end;
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure time();
begin
if ms >= 30 then
begin
s:=s+1;
ms:=1;
end;
if s >= 60 then
begin
h:=h+1;
s:=1;
end;
if h >= 24 then
begin
d:=d+1;
h:=1;
end;
gotoxy(40,MAXY+1);
textcolor(15);
write(d,':',h,':',s,' ');
ms:=ms+1;

end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure load();
var F:textfile;
	error,i,j,a:integer;
	str:string;
begin
	txtfile:='';
	write('World to load:');
	readln(txtfile);
		if not (txtfile = '') then
			begin
			
				assign(F,txtfile+'.txt');
				{$i-}
				reset(F);
				{$i+}
				if IOResult<>0 then
					begin
						write('Error opening file:',txtfile+'.txt');
						write(' Creating new world');
						readln;
						make();
						exit;
					end;
				
				if IOResult = 0 then
					begin
						clrscr;

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
						psx:=a;
						
						readln(F,str);
						val(str,a,error);
						psy:=a;
						
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

						for i:=1 to 50 do
							begin
								readln(F,str);
								val(str,a,error);
								if error = 0 then
									chesx[i]:=a
								else begin
								halt(5);
								end;
							end;

						for i:=1 to 50 do
							begin
								readln(F,str);
								val(str,a,error);
								if error = 0 then
									chesy[i]:=a
								else begin
								halt(5);
								end;
							end;

						for i:=1 to 50 do
							for j:=1 to 5 do
								begin
									readln(F,str);
									val(str,a,error);
									if error = 0 then
										chesinv[i,j]:=a
									else begin
									halt(5);
									end;
								end;
						close(F);
						
						textbackground(0);
						clrscr;

						for i:=1 to 80 do
							for j:=1 to 22 do
								begin
								block(i,j);
								end;

						textcolor(9);
						gotoxy(px,py);
						write(chr(2));
					end;
			end;
		if (txtfile = '') then
			begin
			textbackground(0);
			clrscr;
			make;
			end;
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
	writeln(F,psx);
	writeln(F,psy);
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

	for i:=1 to 50 do
	begin
		writeln(F,chesx[i]);
	end;

	for i:=1 to 50 do
	begin
		writeln(F,chesy[i]);
	end;

	for i:=1 to 50 do
		for j:=1 to 5 do
		begin
			writeln(F,chesinv[i,j]);
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

		3:begin {Add debugging info in here}
		h:=16;
		end;
		4:begin for i:=30 to 50 do
					for j:=10 to 16 do
						begin
							gotoxy(i,j);
							write(chr(0));
						end;
			gotoxy(30,10);
			write('D = pick-up');
			gotoxy(30,11);
			write('S = Place');
			gotoxy(30,12);
			write('A = Craft');
			gotoxy(30,13);
			write('E = INV');
			gotoxy(30,14);
			write('Esc = menu');
			gotoxy(30,15);
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
	if (m > 5) then
		m:=1;
	if (m < 1) then
		m:=5;
	if (m1 > 5) then
		m1:=1;
	if (m1 < 1) then
		m1:=5;

	if not (m = m1) then
		begin
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

	end;
	str:='#';



until E = 1;

for i:=30 to 50 do
	for j:=10 to 16 do
		begin
		block(i,j);
end;
end;

{Do Not Touch This Script IT WILL BREAK!!!}
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
                #0:begin
                ch:=readkey;
                case ch of
                 #75 : begin if not (pd = 1) and not (map[x-1,y] = 1) then begin pd := 1; if (map[x-1,y] = 1)  then px := px-1 else if (map[x-1,y] = 7) then px := px-1; end; end;
                 #77 : begin if not (pd = 2) and not (map[x+1,y] = 1) then begin pd := 2; if (map[x+1,y] = 1)  then px := px+1 else if (map[x+1,y] = 7) then px := px+1; end; end;
                 #72 : begin if not (pd = 3) and not (map[x,y-1] = 1) then begin pd := 3; if (map[x,y-1] = 1)  then py := py-1 else if (map[x,y-1] = 7) then py := py-1; end; end;
                 #80 : begin if not (pd = 4) and not (map[x,y+1] = 1) then begin pd := 4; if (map[x,y+1] = 1)  then py := py+1 else if (map[x,y+1] = 7) then py := py+1; end; end;
                end;
                end;
			'd' : begin
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
			's' : drop();
			'a' : craft();
			#27 : menu();
			'e' : invmenu();

		end;

		block(x,y);
		textcolor(9);
		textbackground(1);
		gotoxy(px,py);
		write(chr(2));
		delay(25);
		end;

		textbackground(0);
		gotoxy(1,MAXY+1);
		for i := 1 to 5 do
				begin
				textcolor(8);
				write(i);
				textcolor(15);
				write(':',inv[i]);
				if not (i = 5) then
				write(':');
				if (i = 5) then
				write(' ');
				end;
		time();

		begin
		if ph > 100 then
			ph:=100;
		gotoxy(55,MAXY+1);
		textcolor(15);
		write('H:',ph,'   ');
		
		if ph < 0 then
			begin
			px:=psx;
			py:=psy;
			ph:=100;
			pl:=pl-10;
			if pl < 0 then
				pl:=0;
			end;
			
		end;
	end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure enemy();
var r1,r,x,y,i,j,k:integer;
	d,d1,a,b:real;
begin

if h >= 16 then
if n = 0 then
begin
k1:=1;
for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		if map[i,j] = 9 then
			begin
			eny[k1]:=j;
			enx[k1]:=i;
			ent[k1]:=1;
			k1:=k1+1;
			n:=1;
			end;
end;

if (h >= 7) and (h < 16)then
	for i:=1 to MAXE do
		begin
			if ent[i] = 1 then
				begin
					ent[i] := 0;
					gotoxy(enx[i],eny[i]);
					textcolor(1);
					textbackground(1);
					write(chr(0));
				end;
			n:=0;
		end;
for i:=1 to MAXE do
	if ent[i] = 1 then
		begin		
			if enm[i] >= 50 then
				begin
					x:=enx[i];
					y:=eny[i];
					
					r := random(6);
					d := sqr(x - px);
					d1 := sqr(y - py);
					a := sqrt(d+d1);
					
					if a < 5 then
						r := 5;
						
						case r of
						1:if map[x-1,y] = 1 then x:=x-1;
						2:if map[x+1,y] = 1 then x:=x+1;
						3:if map[x,y-1] = 1 then y:=y-1;
						4:if map[x,y+1] = 1 then y:=y+1;
						5:begin
							r := random(8);
							r1:= random(16);
							k1:=0;
							
							if (px < x) or (r = 1) then
								if (map[x-1,y] = 1) and (k1 = 0) then
									begin
									x:=x-1;
									k1:=1;
									end;
							
							if (px > x) or (r = 2) then
								if (map[x+1,y] = 1) and (k1 = 0) then
									begin
									x:=x+1;
									k1:=1;
									end;
								
							if (py < y) or (r = 3) then
								if (map[x,y-1] = 1) and (k1 = 0) then
									begin
									y:=y-1;
									k1:=1;
									end;
							
							if (py > y) or (r = 4) then
								if (map[x,y+1] = 1) and (k1 = 0) then
									begin
									y:=y+1;
									k1:=1;
									end;
						  end;
						end;

					k1:=0;

					if (px = x) and (py = y) and (k1 = 0) then
						begin
						ph:=ph-random(10)+1;
						k1:=1;
						end;
						
					textbackground(1);
					textcolor(1);

					if (x >= enx[i]) and (y >= eny[i]) then
						block(enx[i],eny[i]);
					if (x <= enx[i]) and (y <= eny[i]) then
						block(enx[i],eny[i]);
					
					
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

procedure animate;
var s1:array[1..6] of string;
	s:string;
	b,k,a,i,j:integer;
begin
textbackground(1);
clrscr;

for i:=1 to MAXY+3 do
		begin
		gotoxy(59,i);
		write(chr(186));
		end;

for i:=1 to MAXX do
		begin
		gotoxy(i,20);
		write(chr(205));
		end;

gotoxy(59,20);
write(chr(206));

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
		gotoxy(a,k);
		textbackground(1);
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
		gotoxy(a,k);
		textbackground(1);
		write(s[a]);
		end;
	k:=k+1;
	end;

s1[1]:='.-.   .-.     .-.   .-.      .-----. ';
s1[2]:='| |   | |     | | _ | |      _~~~~~_ ';
s1[3]:='| |   | |     `-``-`| |     | |\  | |';
s1[4]:='| |   | |           | |     | | \ | |';
s1[5]:='`-` _ `-`           | |  _   ~___\_~ ';
s1[6]:='   `-`              `-` `-`  `-----` ';

for i:=1 to 6 do
	begin
	s:=s1[i];
	j:=length(s);
	for a:=1 to j do
		begin
		gotoxy(a,k);
		textbackground(1);
		write(s[a]);
		end;
	k:=k+1;
	end;

while not keypressed do
	begin
	for a:=1 to 58 do
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
	delay(200);



	b:=b+1;
	if b > 8 then
		b:=1;
	end;
readkey;
writeln();
writeln();
end;

{Do Not Touch This Script IT WILL BREAK!!!}
begin
pretimer:=0;
timer:=0;
clrscr;
animate;
writeln('Load file? y/n');
ph1:=ph;
readln(str);
if str = 'y' then
	load()
else
	begin
		textbackground(0);
		clrscr;
		make();
	end;
repeat
frame;
timer:=timer+1;
cursoroff;
update();
enemy();
until false;
readln;
end.
