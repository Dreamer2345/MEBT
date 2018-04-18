program MEBT;
{Version 5.1}

uses Dos,crt,math,sysutils;

const MAXX = 80;
	  MAXY = 22;
	  MINX = 1;
	  MINY = 1;
	  MAXE = 25;
	  VersionNum = '5.1';

type
	Tground = record
	grasstype:integer;
	forground:boolean;
	end;	
	Tenemy = record
	enb,enm,ent,enx,eny,enbl,enty,enh:integer;
	typesrt:string;
	end;
var dama,v,map,c:array[MINX..MAXX,MINY..MAXY] of integer;
	enemyarr:array[1..MAXE] of Tenemy;
	chesx,chesy:array[1..50] of integer;
	chesinv:array[1..50,1..5] of integer;
	npsx,npsy,cd,psx,psy,fps,realtime,pretimer,timer,ec1,n,ph1,sve,ms,s,h,d,pl,pd,px,py,ph:integer;
	txtfile,str:string;
	inv:array[1..10] of integer;
	BEDS,DEBUG:boolean;
	gmap:array[MINX..MAXX,MINY..MAXY] of Tground;
	
	
{can Touch This Script}
procedure block(x,y:integer);
var c1:boolean;
	ch,ty:integer;
begin
		gotoxy(x,y);
		if map[x,y] = 1 then
		begin
		textbackground(0);
		ty:=gmap[x,y].grasstype;
		c1:=gmap[x,y].forground;
		if c1 = true then
			textcolor(10)
		else
			textcolor(2);
			
		case ty of
		1:ch:=34;
		2:ch:=44;
		3:ch:=39;
		4:ch:=46;
		end;
		write(chr(ch));
		end;
		
		if map[x,y] = 0 then
			begin
			textcolor(8);
			textbackground(0);
			if v[x,y] = 0 then
				write(chr(177))
			else write(chr(219));	
				
			end;
			
		if (map[x,y] < 6) and (map[x,y] > 1) then
			begin
			textbackground(0);
			textcolor(map[x,y]);
			if v[x,y] = 0 then
				write(chr(178))
			else write(chr(177));	
			end;

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
			textbackground(0);
			write(chr(184));
		end;

		if map[x,y] = 13 then
		begin
			textcolor(12);
			textbackground(0);
			write(chr(203));
		end;

		if map[x,y] = 14 then
		begin
			textcolor(12);
			textbackground(0);
			write(chr(196));
		end;

		if map[x,y] = 15 then
		begin
			textcolor(12);
			textbackground(0);
			write(chr(179));
		end;

		if map[x,y] = 16 then
		begin
			textcolor(12);
			textbackground(0);
			write(chr(217));
		end;

		if map[x,y] = 17 then
		begin
			textcolor(12);
			textbackground(0);
			write(chr(191));
		end;
		
		if map[x,y] = 18 then
		begin
			textcolor(12);
			textbackground(0);
			write(chr(218));
		end;
		
		if map[x,y] = 19 then
		begin
			textcolor(12);
			textbackground(0);
			write(chr(192));
		end;
		
		if map[x,y] = 20 then
		begin
			textcolor(12);
			textbackground(0);
			write(chr(193));
		end;
		
		if map[x,y] = 21 then
		begin
			textcolor(12);
			textbackground(0);
			write(chr(194));
		end;
		
		if map[x,y] = 22 then
		begin
			textcolor(12);
			textbackground(0);
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
procedure WriteCenter(x,y:integer;str:string);
var l:integer;
begin
l := length(str);
gotoxy(x-round(l/2),y);
write(str);
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure redraw(Spec:boolean;k,l,k1,l1:integer);
var i,j:integer;
begin

if spec = true then
for i:=k to k1 do
	for j:=l to l1 do
		begin
		if (i <= MAXX-1) and (i >= MINX+1) and (j <= MAXY-1) and (j >= MINY+1) then
			begin
			if (map[i+1,j] = 1) or (map[i-1,j] = 1) or (map[i,j+1] = 1) or (map[i,j-1] = 1) or (map[i,j] = 1)  and not (map[i,j] = 0) then
				block(i,j)
			else
				begin
					gotoxy(i,j);
					textcolor(8);
					textbackground(0);
					if not (map[i,j] = 0) then
					if (v[i,j] = 0) then
						write(chr(176))
					else write(chr(219));
					if (map[i,j] = 0) then
						begin
						textcolor(0);
						write(chr(219));
						end;
				end;
			end;
		end;
		
if spec = false then
for i:=px+2 downto px-2 do
	for j:=py+2 downto py-2 do
		begin
		if (i <= MAXX-1) and (i >= MINX+1) and (j <= MAXY-1) and (j >= MINY+1) then
			begin
			if (map[i+1,j] = 1) or (map[i-1,j] = 1) or (map[i,j+1] = 1) or (map[i,j-1] = 1) or (map[i,j] = 1) and not (map[i,j] = 0) then
				block(i,j)
			else
				begin
					gotoxy(i,j);
					textcolor(8);
					textbackground(0);
					if not (map[i,j] = 0) then
					if (v[i,j] = 0) then
						write(chr(176))
					else write(chr(219));	
					if (map[i,j] = 0) then
						begin
						textcolor(0);
						write(chr(219));
						end;
				end;
			end;
		end;
		
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure bed(x:boolean;k:integer);
var E,m,m1,i,j,r:integer;
begin
if x = false then
	begin
	BEDS:=true;
	npsx:=px;
	npsy:=py;
	end;
	
if x = true then
	begin
	E:=0;
	m:=1;
	for i:=30 to 50 do
		for j:=10 to 15 do
			begin
			gotoxy(i,j);
			write(chr(0));
			end;
	textcolor(8);		
	gotoxy(30,10);
	write('Sleep  ');
	gotoxy(30,11);
	write('Pick up');
	repeat
	if keypressed then
		begin
		str:=readkey;
		m1:=m;
		case str of
			#72:m:=1;
			#80:m:=2;
			#27:E:=1;
			'e':E:=1;
			#13:begin
			if m = 1 then
				begin
					r:=0;
					if (h < 16) and (h > 7) then
						begin
						gotoxy(30,12);
						write('You cant');
						gotoxy(30,13);
						write('Sleep now');
						readln;
						for i:=30 to 50 do
							for j:=12 to 15 do
								begin
								gotoxy(i,j);
								write(chr(0));
								end;
						end;
						
					if (h >= 16) or (h <= 7) then
						begin
						d:=d+1;
						h:=7;
						E:=1;
						r:=1;
						end;
				end;
			if m = 2 then
				begin
					BEDS:=false;
					inv[k]:=13;
					case pd of
					1:begin gotoxy(px-1,py); map[px-1,py] := 1; block(px-1,py); end;
					2:begin gotoxy(px+1,py); map[px+1,py] := 1; block(px+1,py); end;
					3:begin	gotoxy(px,py-1); map[px,py-1] := 1; block(px,py-1); end;
					4:begin	gotoxy(px,py+1); map[px,py+1] := 1; block(px,py+1); end;
					end;
					E:=1;
				end;
			end;

			end;
		end;
	
	if m = 1 then
		begin
		textcolor(2);
		gotoxy(30,10);
		write('Sleep  ');
		textcolor(8);
		gotoxy(30,11);
		write('Pick up');
		end;
	
	if m = 2 then
		begin
		textcolor(8);
		gotoxy(30,10);
		write('Sleep  ');
		textcolor(2);
		gotoxy(30,11);
		write('Pick up');
		end;

	
		str:='#';
	until E = 1;
	redraw(true,30,10,50,16);	
	end;

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

redraw(true,30,5,50,16);
textbackground(1);
textcolor(1);
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure chest();
var e1,m1,m,E,a,b,l,c,k,k1,i,j,x,y:integer;
	s,s1:string;
begin

case pd of
	1:begin x:=px-1; y:=py; end;
	2:begin x:=px+1; y:=py; end;
	3:begin	x:=px; y:=py-1; end;
	4:begin	x:=px; y:=py+1; end;
end;


k1:=0;
for i:=1 to 50 do
	if (chesx[i] = x) and (chesy[i] = y) and (k1 = 0) then
		begin
		k1:=1;
		c:=i;
		end;

if k1 = 1 then
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
m:=3;
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
		'e':E:=1;
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

redraw(true,30,10,50,16);
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
procedure loadbar(d,df:integer;stri:string);
var k,i,j:integer;
	iss:string;
begin
if DEBUG = false then
begin
	cursoroff;
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

{Do Not Touch This Script IT WILL BREAK!!!}
procedure make();
var e,k,s,bl,a,d,x,y,r,r1,i,j:integer;
begin
textbackground(0);
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
enemyarr[i].ent := 0;

for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		map[i,j]:=8;

for i:=MINX+1 to MAXX-1 do
	for j:=MINY+1 to MAXY-1 do
		map[i,j]:=0;

for i := 1 to 10 do
	inv[i]:=1;


x:=round(MAXX/2);
y:=round(MAXY/2);
d:=1;
for i:=1 to 5999 do
	begin
	loadbar(i,5999,'Generating random Tunnels');
	r := random(8)+1;
	if (r = d) then
		case d of
		1:y:=y-1;
		2:y:=y+1;
		3:x:=x-1;
		4:x:=x+1;
		end;
	if not (r = d) then		
		case r of
		1:x:=x+1;
		2:x:=x-1;
		3:y:=y+1;
		4:y:=y-1;
		end;
	
	if y <= MINY then
		y:=y+1;
	if y >= MAXY then
		y:=y-1;
	if x <= MINX then
		x:=x+1;
	if x >= MAXX then
		x:=x-1;
	if map[x,y] = 1 then
		map[x,y] := 0;
	
	if map[x,y] = 0 then
		map[x,y] := 1;
	
	d:=r;
end;

for i:=1 to MAXX do
	for j:=1 to MAXY do
		c[i,j]:=map[i,j];
e:=0;
repeat
	begin
	for i:=2 to MAXX-1 do
		for j:=2 to MAXY-1 do
			begin
				a:=0;
				e:=0;
				
				if (map[i-1,j] = 0) then
					a := a+1;
				if (map[i+1,j] = 0) then
					a := a+1;	
				if (map[i,j-1] = 0) then
					a := a+1;
				if (map[i,j+1] = 0) then
					a := a+1;
				if (map[i+1,j+1] = 0) then
					a := a+1;
				if (map[i+1,j-1] = 0) then
					a := a+1;
				if (map[i-1,j+1] = 0) then
					a := a+1;
				if (map[i-1,j-1] = 0) then
					a := a+1;
					
				if a > 5 then
				begin
				c[i,j]:=0;
				end;
				if a <= 3 then
				begin
				c[i,j]:=1;	
				end;
				
			end;
		for i:=1 to MAXX do
			for j:=1 to MAXY do
				begin
				if map[i,j] = c[i,j] then
					e:=1;
				if not (map[i,j] = c[i,j]) then
					e:=0;	
				end;	
		for i:=2 to MAXX-1 do
			for j:=2 to MAXY-1 do
				map[i,j]:=c[i,j];
	end;
until e = 1;

for i:=MINX+1 to MAXX-1 do
	 for j:=MINY+1 to MAXY-1 do
		begin
		loadbar(i,MAXX-1,'Adding ores');
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
		loadbar(i,MAXX-1,'Finding spawner locations');
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
			if (a <= 5) and (a >= 2) and (r = 1) then
					begin
						map[i,j]:=9;
						r1:=r1-1;
						s := s + 1;
					end;
			end;
		end;




		
		
redraw(true,MINX,MINY,MAXX,MAXY);		
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

		end;

		if pl >= 10 then
		begin
		if b = 13 then
				begin
					bed(true,i);
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
								else  if (inv[i] = 13) then
										bed(false,i)
										else
											begin
												map[px,py]:=inv[i];
												inv[i]:=1;
												k:=1;								
											end;
						if inv[i] = 11 then
							begin
							inv[i]:=1;
							k:=1;
							end;
						if inv[i] = 12 then
							begin
							inv[i]:=1;
							k:=1;
							end;
						if (inv[i] = 13) then
							begin
							map[px,py]:=13;
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
								else  if (inv[i] = 13) then
										bed(false,i)
										else
											begin
												map[px,py]:=inv[i];
												inv[i]:=1;
												k:=1;
											end;
						if inv[i] = 11 then
							begin
							inv[i]:=1;
							k:=1;
							end;
						if inv[i] = 12 then
							begin
							inv[i]:=1;
							k:=1;
							end;
						if (inv[i] = 13) then
							begin
							map[px,py]:=13;
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
textcolor(15);
textbackground(0);
gotoxy(1,MAXY+2);
write('ingredient 1:');
readln(ch);
val(ch,a,error);
gotoxy(1,MAXY+2);
delline;
if (error = 0) and (a < 10) or (a > 0) then
begin
gotoxy(1,MAXY+2);
write('ingredient 2:');
readln(ch1);
val(ch1,b,error);
gotoxy(1,MAXY+2);
delline;
if (error = 0) and (b < 10) or (b > 0) and (pl < 10) then
begin

if inv[a] = 3 then
	if inv[b] = 2 then
		begin
		inv[b]:=1;
		inv[a]:=6;
		sve:=1;
		end;

if inv[a] = 0 then
	if inv[b] = 0 then
		begin
		inv[b]:=1;
		inv[a]:=7;
		sve:=1;
		end;

if inv[a] = 0 then
	if inv[b] = 2 then
		begin
		inv[b]:=1;
		inv[a]:=11;
		sve:=1;
		end;

if inv[a] = 0 then
	if inv[b] = 3 then
		begin
		inv[b]:=1;
		inv[a]:=12;
		sve:=1;
		end;

if inv[a] = 7 then
	if inv[b] = 12 then
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
if ms >= 20 then
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
	WriteCenter(40,10,'World to load');
	gotoxy(40,11);
	readln(txtfile);
		if not (txtfile = '') then
			begin
			
				assign(F,txtfile+'.txt');
				{$i-}
				reset(F);
				{$i+}
				if IOResult<>0 then
					begin
						WriteCenter(40,11,'Error opening file:'+txtfile+'.txt');
						WriteCenter(40,12,' Creating new world');
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
						
						readln(F,str);
						val(str,a,error);
						npsx:=a;
						
						readln(F,str);
						val(str,a,error);
						npsy:=a;
						
						readln(F,str);
						if str = 'TRUE' then
							BEDS:=true;
						if str = 'FALSE' then
							BEDS:=false;

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

						redraw(true,MINX,MINY,MAXX,MAXY);

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
					for j:=10 to 15 do
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
		write('Items List');
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
	writeln(F,npsx);
	writeln(F,npsy);
	writeln(F,BEDS);
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
for i:=29 to 51 do
	for j:=9 to 16 do
		begin
		gotoxy(i,j);
		write(chr(42));
		end;
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
write('Item list');
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
		1:begin if DEBUG  = true then h:=16;  E:=1; end;
		2:begin
		if sve = 1 then
			begin
			for i:=30 to 50 do
					for j:=10 to 15 do
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

		3:begin for i:=30 to 50 do
					for j:=10 to 15 do
						begin
							gotoxy(i,j);
							write(chr(0));
						end;
			gotoxy(30,10);
			write('BASIC Items:');
			gotoxy(30,11);
			write('0:stone');
			gotoxy(30,12);
			write('2:mythril');
			gotoxy(30,13);
			write('3:grimite');
			gotoxy(30,14);
			write('4:dranite');
			gotoxy(30,15);
			write('5:primontite');
			
			readkey;

			
			for i:=30 to 50 do
					for j:=10 to 15 do
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
			write('Item List');
			gotoxy(30,13);
			write('Help');
			gotoxy(30,14);
			write('Save');

		end;
		4:begin for i:=30 to 50 do
					for j:=10 to 15 do
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
			
			readkey;

			
			for i:=30 to 50 do
					for j:=10 to 15 do
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
			write('Item List');
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
						3:write('Item List');
						4:write('Help');
						5:write('Save');

					end;

					gotoxy(30,9+m);
					textcolor(2);
					case m of
					1:write('Exit');
					2:write('Quit');
					3:write('Item List');
					4:write('Help');
					5:write('Save');

					end;
		end;

	end;
	str:='#';



until E = 1;

redraw(true,29,9,51,16);
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure update();
var ch,ch1:char;
	i,x,y,k:integer;
	begin
	if keypressed() then
		begin
		sve:=1;
		x := px;
		y := py;
		ch:=readkey;
		case ch of	{if you want a door add it in here as one \/}
			#0: begin ch1:=readkey;
				case ch1 of
				#75 : begin  pd := 1; if (map[x-1,y] = 1)  then px := px-1 else if (map[x-1,y] = 7) then px := px-1; redraw(false,1,1,1,1); end;
				#77 : begin  pd := 2; if (map[x+1,y] = 1)  then px := px+1 else if (map[x+1,y] = 7) then px := px+1; redraw(false,1,1,1,1); end;
				#72 : begin  pd := 3; if (map[x,y-1] = 1)  then py := py-1 else if (map[x,y-1] = 7) then py := py-1; redraw(false,1,1,1,1); end;
				#80 : begin  pd := 4; if (map[x,y+1] = 1)  then py := py+1 else if (map[x,y+1] = 7) then py := py+1; redraw(false,1,1,1,1); end;
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
				redraw(false,1,1,1,1);
			end;
			's' : begin drop(); redraw(false,1,1,1,1); end;
			'a' : craft();
			#27 : menu();
			'e' : invmenu();

		end;
		block(x,y);
		textcolor(9);
		textbackground(0);
		gotoxy(px,py);
		write(chr(2));
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
			if BEDS = true then
				begin
				px:=npsx;
				py:=npsy;
				end;
			if BEDS = false then
				begin
				px:=psx;
				py:=psy;
				end;
			ph:=100;
			pl:=pl-10;
			if pl < 0 then
				pl:=0;
			end;
			
		end;
	end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure enemy();
var r3,r2,r1,r,x,y,i,j,k:integer;
	d,d1,a,b:real;
begin
randomize;
if h >= 16 then
if n = 0 then
begin
ec1:=1;
for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		if map[i,j] = 9 then
			begin
			enemyarr[ec1].enb:=0;
			enemyarr[ec1].eny:=j;
			enemyarr[ec1].enx:=i;
			enemyarr[ec1].ent:=1;
			enemyarr[ec1].enty:=random(5)+1;
			enemyarr[ec1].enh:=enemyarr[ec1].enty*20;
			ec1:=ec1+1;
			n:=1;
			end;
ec1:=ec1-1;
end;

if (h > 7) and (h < 16)then
	for i:=1 to MAXE do
		begin
			if (enemyarr[i].ent = 1) and (n = 1) then
				begin
					enemyarr[i].enb :=0;
					enemyarr[i].ent := 0;
					block(enemyarr[i].enx,enemyarr[i].eny);
				end;
			n:=0;
		end;
		
for i:=1 to MAXE do
	if (enemyarr[i].ent = 1) and (enemyarr[i].enh > 0) then
		begin		
			if enemyarr[i].enm >= 25 then
				begin
					x:=enemyarr[i].enx;
					y:=enemyarr[i].eny;
					
					r := random(5);
					d := sqr(x - px);
					d1 := sqr(y - py);
					a := sqrt(d+d1);
					if a <= 5 then
						r:=5;
						
					if a >= 5 then
						enemyarr[i].enb:=0;
						
					case r of
						1:begin if map[x-1,y] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
								if map[x-1,y] = 1 then
									x:=x-1;
									end;
						2:begin if map[x+1,y] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
								if map[x+1,y] = 1 then
									x:=x+1;
									end;
						3:begin if map[x,y-1] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
								if map[x,y-1] = 1 then
									y:=y-1;
									end;
						4:begin if map[x,y+1] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
								if map[x,y+1] = 1 then
									y:=y+1;
									end;
						5:begin
							if a < 5 then
							begin
							r1 := random(6);
							ec1:=0;	
							if (px < x) or (r1 = 1) then
								if (map[x-1,y] = 1) and (ec1 = 0) then
									begin
									if map[x-1,y] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
									x:=x-1;
									ec1:=1;
									end;
							
							if (px > x) or (r1 = 2) then
								if (map[x+1,y] = 1) and (ec1 = 0) then
									begin
									if map[x+1,y] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
									x:=x+1;
									ec1:=1;
									end;
								
							if (py < y) or (r1 = 3) then
								if (map[x,y-1] = 1) and (ec1 = 0) then
									begin
									if map[x,y-1] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
									y:=y-1;
									ec1:=1;
									end;
							
							if (py > y) or (r1 = 4) then
								if (map[x,y+1] = 1) and (ec1 = 0) then
									begin
									if map[x,y+1] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
									y:=y+1;
									ec1:=1;
									end;
							
							if (map[x-1,y] = 0) or  (map[x+1,y] = 0) or (map[x,y-1] = 0) or (map[x,y+1] = 0) then
								begin
								enemyarr[i].enb:=enemyarr[i].enb+1;
								if enemyarr[i].enb > 10 then
									begin
										case r1 of
										1:if (map[x-1,y] = 0) then map[x-1,y]:=1;
										2:if (map[x+1,y] = 0) then map[x+1,y]:=1;
										3:if (map[x,y-1] = 0) then map[x,y-1]:=1;
										4:if (map[x,y+1] = 0) then map[x,y+1]:=1;
										end;
										enemyarr[i].enb:=0;
									end;
								
								end;
							end;
						  end;
						end;
					ec1:=0;
					if (px = x) and (py = y) and (ec1 = 0) then
						begin
						r3:=random(5);
						if r3 = 1 then
						case enemyarr[i].enty of
							1:begin ph:=ph-(random(10)+1);  enemyarr[i].enh:=enemyarr[i].enh-1;   end;
							2:begin ph:=ph-(random(10)+5); enemyarr[i].enh:=enemyarr[i].enh-1;   end;
							3:begin ph:=ph-(random(5)+1);  enemyarr[i].enh:=enemyarr[i].enh-1;  end;
							4:begin ph:=ph-(random(30)+1);  enemyarr[i].enh:=enemyarr[i].enh-1;  end;
							5:begin ph:=ph-(random(40)+20); enemyarr[i].enh:=enemyarr[i].enh-1;   end;
						end;
						ec1:=1;
						end;

					if (x >= enemyarr[i].enx) and (y >= enemyarr[i].eny) then
						block(enemyarr[i].enx,enemyarr[i].eny);
					if (x <= enemyarr[i].enx) and (y <= enemyarr[i].eny) then
						block(enemyarr[i].enx,enemyarr[i].eny);
					
					
					enemyarr[i].enx:=x;
					enemyarr[i].eny:=y;

					gotoxy(x,y);
					textcolor(4);
					textbackground(0);
					case enemyarr[i].enty of
					1:write('H');
					2:write('W');
					3:write('D');
					4:write('O');
					5:write('T')
					end;
					
					enemyarr[i].enm:=0;
					end;
			if enemyarr[i].ent = 0 then
					redraw(true,enemyarr[i].enx,enemyarr[i].enx,enemyarr[i].enx,enemyarr[i].enx);
			enemyarr[i].enm:=enemyarr[i].enm+1;
			end;
		end;


{Do Not Touch This Script IT WILL BREAK!!!}
procedure animate;
var s1:array[1..6] of string;
	s:string;
	b,k,a,i,j:integer;
begin
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

{Do Not Touch This Script IT WILL BREAK!!!}
procedure start;
var i,j,k:integer;
begin
txtfile:='';
for i:=1 to MAXX do
	for j:=1 to MAXY do
		begin
		gmap[i,j].grasstype:=random(4)+1;
			
		k:=random(2)-1;
		if k = 0 then
			gmap[i,j].forground:=False
		else
			gmap[i,j].forground:=True;	
		end;
for i:=1 to MAXX do
	for j:=1 to MAXY do
		begin
		k:=random(2)-1;
		if k = 0 then
			v[i,j]:=1
		else
			v[i,j]:=0;	
		end;

for i:=1 to MAXX do
	for j:=1 to MAXY do
		dama[i,j]:=0;
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure MainMenu;
var ch:char;
	i,j,m,m1:integer;	
	Done:boolean;
begin
while (readkey = #0) do;
Done := false;
textbackground(0);
textcolor(15);
clrscr;
WriteCenter(40,10,'Start New Game');
WriteCenter(40,11,'Load Existing');
WriteCenter(40,12,'Quit');
repeat
   m1:=m;
   ch:=readkey;
   case ch of
   #72:m:=m-1;
   #80:m:=m+1;
   #13:case m of
	   1:begin ph1:=1; Done:=true; end;
	   2:begin ph1:=2; Done:=true; end;
	   3:begin ph1:=3; Done:=true; end;
	   end;
   end;



	if (m > 3) then
		m:=1;
	if (m < 1) then
		m:=3;
	if (m1 > 3) then
		m1:=1;
	if (m1 < 1) then
		m1:=3;
		
if not (m = m1) then
		begin

					textcolor(15);
					case m1 of
						1:WriteCenter(40,9+m1,'Start New Game');
						2:WriteCenter(40,9+m1,'Load Existing');
						3:WriteCenter(40,9+m1,'Quit');
					end;


					textcolor(2);
					case m of
						1:WriteCenter(40,9+m,'Start New Game');
						2:WriteCenter(40,9+m,'Load Existing');
						3:WriteCenter(40,9+m,'Quit');
					end;
		end;
until Done;

textcolor(15);
textbackground(0);
clrscr;
end;

{Do Not Touch This Script IT WILL BREAK!!!}
begin
start;
DEBUG:=false;
pretimer:=0;
timer:=0;
clrscr;
animate;
MainMenu;

case ph1 of
1:make();
2:load();
3:halt();
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
