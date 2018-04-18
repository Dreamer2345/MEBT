program MEBT;
{Version 7.2}

uses Dos,crt,math,sysutils,CRT_Draw;

const MAXX = 80;
	  MAXY = 22;
	  MINX = 1;
	  MINY = 1;
	  MAXE = 25;
	  MAXZ = 25;
	  MINZ = 1;
	  VersionNum = '7.2';

type
	Tground = record
	grasstype:integer;
	forground:boolean;
	end;		
	Tenemy = record
	enb,enm,ent,enx,eny,enbl,enty,enh:integer;
	typesrt:string;
	end;	
	Tplayer = record
	npsx,npsy,npsz,psx,psy,pl,pd,px,py,ph,pz:integer;
	inv:array[1..10] of integer;
	end;	
	Tchest = record
	chesx,chesy,chesz:array[1..50] of integer;
	chesinv:array[1..50,1..5] of integer;
	end;
	
var dama,v,map,c:array[MINX..MAXX,MINY..MAXY,MINZ..MAXZ] of integer;
	gmap:array[MINX..MAXX,MINY..MAXY,MINZ..MAXZ] of Tground;
	enemyarr:array[1..MAXE] of Tenemy;
	play:Tplayer;
	ches:Tchest;
	cd,fps,realtime,pretimer,timer,ec1,n,ph1,sve,ms,s,h,d,dely,count:integer;
	txtfile:string;
	BEDS,DEBUG,LAYER,PLAYING,CONF:boolean;
	
procedure block(x,y:integer);
var c1:boolean;
	ch,ty:integer;
begin
		gotoxy(x,y);
		if (map[x,y,play.pz] = 1) then
		begin
		textbackground(0);
		ty:=gmap[x,y,play.pz].grasstype;
		c1:=gmap[x,y,play.pz].forground;
		if (c1 = true) and (play.pz = 1) then
			textcolor(10)
		else if (play.pz = 1) then
				textcolor(2);
				
		if (c1 = true) and (play.pz = 2) then
			textcolor(2)
		else if (play.pz = 2) then
				textcolor(6);	
			
		if (c1 = true) and (play.pz = 3) then
			textcolor(6)
		else if (play.pz = 3) then
				textcolor(7);	
				
		if (c1 = true) and (play.pz > 3) then
			textcolor(7)
		else if (play.pz > 3) then
				textcolor(8);	
		
		case ty of
		1:ch:=34;
		2:ch:=44;
		3:ch:=39;
		4:ch:=46;
		end;
		write(chr(ch));
		end;
		
		if map[x,y,play.pz] = 0 then
			begin
			textcolor(8);
			textbackground(0);
			if v[x,y,play.pz] = 0 then
				write(chr(177))
			else write(chr(219));	
				
			end;
			
		if (map[x,y,play.pz] < 6) and (map[x,y,play.pz] > 1) then
			begin
			textbackground(0);
			textcolor(map[x,y,play.pz]);
			if v[x,y,play.pz] = 0 then
				write(chr(178))
			else write(chr(177));	
			end;

		if map[x,y,play.pz] = 6 then
		begin
			textcolor(14);
			textbackground(6);
			write(chr(127));
		end;

		if map[x,y,play.pz] = 7 then
		begin
			textcolor(7);
			textbackground(0);
			write(chr(186));
		end;

		if map[x,y,play.pz] = 8 then
		begin
			textcolor(8);
			textbackground(0);
				if (map[x+1,y,play.pz] = 8) and (map[x-1,y,play.pz] = 8) and not (map[x,y+1,play.pz] = 8) and not (map[x,y-1,play.pz] = 8) then
							write(chr(205))
						else if (map[x,y+1,play.pz] = 8) and (map[x,y-1,play.pz] = 8) and not (map[x+1,y,play.pz] = 8) and not (map[x-1,y,play.pz] = 8)then
								write(chr(186)) {^v}
							else if (map[x+1,y,play.pz] = 8) and (map[x-1,y,play.pz] = 8) and (map[x,y+1,play.pz] = 8) and not (map[x,y-1,play.pz] = 8) then
									write(chr(203))
								else if (map[x+1,y,play.pz] = 8) and (map[x-1,y,play.pz] = 8) and (map[x,y-1,play.pz] = 8) and not (map[x,y+1,play.pz] = 8) then
										write(chr(202))
									else if (map[x+1,y,play.pz] = 8) and not (map[x-1,y,play.pz] = 8) and (map[x,y+1,play.pz] = 8) and (map[x,y-1,play.pz] = 8) then
											write(chr(204))
										else if not (map[x+1,y,play.pz] = 8) and (map[x-1,y,play.pz] = 8) and (map[x,y-1,play.pz] = 8) and (map[x,y+1,play.pz] = 8) then
												write(chr(185))
											else if (map[x+1,y,play.pz] = 8) and (map[x+1,y,play.pz] = 8) and (map[x,y+1,play.pz] = 8) and (map[x,y-1,play.pz] = 8) then
													write(chr(206))
												else write(chr(48));
		end;

		if map[x,y,play.pz] = 9 then
		begin
			textcolor(12);
			textbackground(14);
			write(chr(35));
		end;

		if map[x,y,play.pz] = 10 then
		begin
			textcolor(2);
			textbackground(5);
			write(chr(36));
		end;

		if map[x,y,play.pz] = 12 then
		begin
			textcolor(14);
			textbackground(0);
			write(chr(184));
		end;

		if map[x,y,play.pz] = 13 then
		begin
			textcolor(6);
			textbackground(0);
			write(chr(203));
		end;

		if map[x,y,play.pz] = 14 then
		begin
			textcolor(7);
			textbackground(0);
			write(chr(31));
		end;

		if map[x,y,play.pz] = 15 then
		begin
			textcolor(7);
			textbackground(0);
			write(chr(30));
		end;

		if map[x,y,play.pz] = 16 then
		begin
			textcolor(6);
			textbackground(0);
			write(chr(79));
		end;

		if map[x,y,play.pz] = 31 then
		begin
			textcolor(6);
			textbackground(0);
			write(chr(79));
		end;
		
		if map[x,y,play.pz] = 17 then
		begin
			if v[x,y,play.pz] = 0 then
				textcolor(7)
			else textcolor(8);	
			textbackground(0);
			write(chr(127));
		end;
		
		if map[x,y,play.pz] = 19 then
		begin
			textcolor(6);
			textbackground(0);
			write(chr(220));
		end;
		
		if map[x,y,play.pz] = 20 then
		begin
			textcolor(6);
			textbackground(0);
					if (map[x+1,y,play.pz] = 20) and (map[x-1,y,play.pz] = 20) and not (map[x,y+1,play.pz] = 20) and not (map[x,y-1,play.pz] = 20) then
							write(chr(205))
						else if (map[x,y+1,play.pz] = 20) and (map[x,y-1,play.pz] = 20) and not (map[x+1,y,play.pz] = 20) and not (map[x-1,y,play.pz] = 20)then
								write(chr(186)) {^v}
							else if (map[x+1,y,play.pz] = 20) and (map[x-1,y,play.pz] = 20) and (map[x,y+1,play.pz] = 20) and not (map[x,y-1,play.pz] = 20) then
									write(chr(203))
								else if (map[x+1,y,play.pz] = 20) and (map[x-1,y,play.pz] = 20) and (map[x,y-1,play.pz] = 20) and not (map[x,y+1,play.pz] = 20) then
										write(chr(202))
									else if (map[x+1,y,play.pz] = 20) and not (map[x-1,y,play.pz] = 20) and (map[x,y+1,play.pz] = 20) and (map[x,y-1,play.pz] = 20) then
											write(chr(204))
										else if not (map[x+1,y,play.pz] = 20) and (map[x-1,y,play.pz] = 20) and (map[x,y-1,play.pz] = 20) and (map[x,y+1,play.pz] = 20) then
												write(chr(185))
											else if (map[x+1,y,play.pz] = 20) and (map[x+1,y,play.pz] = 20) and (map[x,y+1,play.pz] = 20) and (map[x,y-1,play.pz] = 20) then
													write(chr(206))
												else write(chr(48));
								
		end;
				
		if map[x,y,play.pz] = 21 then
		begin
			textcolor(8);
			textbackground(0);
					if (map[x+1,y,play.pz] = 21) and (map[x-1,y,play.pz] = 21) and not (map[x,y+1,play.pz] = 21) and not (map[x,y-1,play.pz] = 21) then
							write(chr(205))
						else if (map[x,y+1,play.pz] = 21) and (map[x,y-1,play.pz] = 21) and not (map[x+1,y,play.pz] = 21) and not (map[x-1,y,play.pz] = 21)then
								write(chr(186)) {^v}
							else if (map[x+1,y,play.pz] = 21) and (map[x-1,y,play.pz] = 21) and (map[x,y+1,play.pz] = 21) and not (map[x,y-1,play.pz] = 21) then
									write(chr(203))
								else if (map[x+1,y,play.pz] = 21) and (map[x-1,y,play.pz] = 21) and (map[x,y-1,play.pz] = 21) and not (map[x,y+1,play.pz] = 21) then
										write(chr(202))
									else if (map[x+1,y,play.pz] = 21) and not (map[x-1,y,play.pz] = 21) and (map[x,y+1,play.pz] = 21) and (map[x,y-1,play.pz] = 21) then
											write(chr(204))
										else if not (map[x+1,y,play.pz] = 21) and (map[x-1,y,play.pz] = 21) and (map[x,y-1,play.pz] = 21) and (map[x,y+1,play.pz] = 21) then
												write(chr(185))
											else if (map[x+1,y,play.pz] = 21) and (map[x+1,y,play.pz] = 21) and (map[x,y+1,play.pz] = 21) and (map[x,y-1,play.pz] = 21) then
													write(chr(206))
												else write(chr(48));
								
		end;
		
		if map[x,y,play.pz] = 22 then
		begin
			textcolor(8);
			textbackground(0);
			write(chr(220));
		end;
		
		if map[x,y,play.pz] = 24 then
		begin
			c1:=gmap[x,y,play.pz].forground;
			if (c1 = true) then
				textcolor(7)
			else 
				textcolor(8);
				
			if v[x,y,play.pz] = 0 then
				write(chr(177))
			else write(chr(178));	
		end;
		
		if map[x,y,play.pz] = 25 then
		begin
			textcolor(6);	
			if v[x,y,play.pz] = 0 then
				write(chr(176))
			else write(chr(178));	
		end;
		
		if map[x,y,play.pz] = 26 then
		begin
			c1:=gmap[x,y,play.pz].forground;
			if (c1 = true) and (play.pz = 1) then
				textcolor(10)
			else if (play.pz = 1) then
					textcolor(2);
					
			if (c1 = true) and (play.pz = 2) then
				textcolor(2)
			else if (play.pz = 2) then
					textcolor(6);	
				
			if (c1 = true) and (play.pz = 3) then
				textcolor(6)
			else if (play.pz = 3) then
					textcolor(7);	
					
			if (c1 = true) and (play.pz > 3) then
				textcolor(7)
			else if (play.pz > 3) then
					textcolor(8);	
				
			textbackground(0);
			write(chr(5));
		end;
		
		if map[x,y,play.pz] = 27 then
		begin
			textcolor(4);
			textbackground(0);
			write(chr(155));
		end;
		
		
		if map[x,y,play.pz] = 30 then
		begin
			textcolor(7);
			textbackground(0);
			write(chr(157));
		end;
		
		if map[x,y,play.pz] = 32 then
		begin
			textcolor(8);
			textbackground(0);
			write(chr(15));
		end;
		
		if map[x,y,play.pz] = 33 then
		begin
			textcolor(8);
			textbackground(0);
			write(chr(123));
		end;

end;	

procedure redraw(Spec:boolean;k,l,k1,l1:integer);
var i,j:integer;
begin
if spec = true then
for i:=k to k1 do
	for j:=l to l1 do
		begin
		if (i <= MAXX-1) and (i >= MINX+1) and (j <= MAXY-1) and (j >= MINY+1) then
			begin
			if (map[i+1,j,play.pz] = 1) or (map[i-1,j,play.pz] = 1) or (map[i,j+1,play.pz] = 1) or (map[i,j-1,play.pz] = 1) or (map[i,j,play.pz] = 1) and not (map[i,j,play.pz] = 0) then
				block(i,j)
			else 
				begin
					gotoxy(i,j);
					textcolor(8);
					textbackground(0);
					if not (map[i,j,play.pz] = 0) then
					if (v[i,j,play.pz] = 0) then
						write(chr(176))
					else write(chr(219));
					if (map[i,j,play.pz] = 0) then
						begin
						textcolor(0);
						write(chr(219));
						end;
				end;
			end;
		end;
		
if spec = false then
for i:=play.px+2 downto play.px-2 do
	for j:=play.py+2 downto play.py-2 do
		begin
		if (i <= MAXX-1) and (i >= MINX+1) and (j <= MAXY-1) and (j >= MINY+1) then
			begin
			if (map[i+1,j,play.pz] = 1) or (map[i-1,j,play.pz] = 1) or (map[i,j+1,play.pz] = 1) or (map[i,j-1,play.pz] = 1) or (map[i,j,play.pz] = 1) and not (map[i,j,play.pz] = 0) then
				block(i,j)
			else
				begin
					gotoxy(i,j);
					textcolor(8);
					textbackground(0);
					if not (map[i,j,play.pz] = 0) then
					if (v[i,j,play.pz] = 0) then
						write(chr(176))
					else write(chr(219));	
					if (map[i,j,play.pz] = 0) then
						begin
						textcolor(0);
						write(chr(219));
						end;
				end;
			end;
		end;
		
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure Terr;
var i,j,l,r:integer;
begin
for l:=MINZ to MAXZ do
	for i:=MINX+1 to MAXX-1 do
		for j:= MINY+1 to MAXY-1 do
			if map[i,j,l] = 26 then
				begin
				r:=random(4)+1;
				if r = 1 then
					begin
					map[i,j,l]:=16;
					if l = play.pz then
						redraw(true,i,j,i,j);
					end;
				end;
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure bed(x:boolean;k:integer);
var E,m,m1,i,j,r:integer;
	st:string;
begin
if x = false then
	begin
	BEDS:=true;
	play.npsx:=play.px;
	play.npsy:=play.py;
	play.npsz:=play.pz;
	end;
	
if x = true then
	begin
	E:=0;
	m:=1;
	for i:=29 to 51 do
		for j:=9 to 16 do
			begin
			gotoxy(i,j);
			write(chr(0));
			end;
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
		st:=readkey;
		m1:=m;
		case st of
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
						
					if (h >= 16) or (h < 7) then
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
					play.inv[k]:=13;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
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

	
		st:='#';
	until E = 1;
	redraw(true,29,9,51,16);	
	end;

end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure invmenu;
var e1,a,b,i,j,E,m1,m:integer;
	ch:char;
	st:string;
begin


gotoxy(30,10);
textbackground(8);
textcolor(8);
for i:=29 to 51 do
	for j:=4 to 17 do
		begin
		gotoxy(i,j);
		write(chr(42));
		end;
for i:=30 to 50 do
	for j:=5 to 16 do
		begin
		gotoxy(i,j);
		write(chr(0));
		end;
		
for i := 1 to 10 do
			begin
			gotoxy(30,4+i);
			if i = 1 then
			textcolor(2)
			else textcolor(8);
			
			st := CRT_Draw.itemlist(play.inv[i]);
			write(i,':',st);
			end;
	gotoxy(30,16);
	textcolor(14);
	write('LVL:',play.pl);

E:=0;
m:=1;
repeat
	ch:=readkey;
	m1:=m;
	case ch of
			#72:m:=m-1;
			#80:m:=m+1;
			#27:E:=1;
			'e':E:=1;
			#13:begin
			a:=m;
			e1:=0;
			repeat
			ch:=readkey;
			m1:=m;
			case ch of
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
						st := CRT_Draw.itemlist(play.inv[m1]);
						write(m1,':',st);
						gotoxy(30,4+m);
						textcolor(2);
						st := CRT_Draw.itemlist(play.inv[m]);
						write(m,':',st);
				end;

			until e1 = 1;
			b:=m;
			if not (a = b) then
				begin
					i:=play.inv[a];
					j:=play.inv[b];
					play.inv[a]:=j;
					play.inv[b]:=i;
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
							st := CRT_Draw.itemlist(play.inv[i]);
							write(i,':',st);
							end;
			gotoxy(30,16);
			textcolor(14);
			write('LVL:',play.pl);
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
						st := CRT_Draw.itemlist(play.inv[m1]);
						write(m1,':',st);
						gotoxy(30,4+m);
						textcolor(2);
						st := CRT_Draw.itemlist(play.inv[m]);
						write(m,':',st);
				end;
until E = 1;

redraw(true,29,4,51,17);
textbackground(1);
textcolor(1);
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure chest();
var e1,m1,m,E,a,b,l,c,k,k1,i,j,x,y:integer;
	s,s1,st:string;
begin

case play.pd of
	1:begin x:=play.px-1; y:=play.py; end;
	2:begin x:=play.px+1; y:=play.py; end;
	3:begin	x:=play.px; y:=play.py-1; end;
	4:begin	x:=play.px; y:=play.py+1; end;
end;


k1:=0;
for i:=1 to 50 do
	if (ches.chesx[i] = x) and (ches.chesy[i] = y) and (ches.chesz[i] = play.pz) and (k1 = 0) then
		begin
		k1:=1;
		c:=i;
		end;

if k1 = 1 then
	begin
gotoxy(30,10);
textbackground(8);
textcolor(8);
for i:=29 to 51 do
	for j:=9 to 16 do
		begin
		gotoxy(i,j);
		write('*');
		end;
for i:=30 to 50 do
	for j:=10 to 15 do
		begin
		gotoxy(i,j);
		write(chr(0));
		end;
	for i:= 1 to 5 do
	begin
		gotoxy(30,9+i);
		st := CRT_Draw.itemlist(ches.chesinv[c,i]);
		write(i,':',st);
	end;

	gotoxy(30,15);
	write('pick-up');
m:=3;
E:=0;

repeat
if keypressed then
	begin
	st:=readkey;
	m1:=m;
	case st of
		#72:m:=m-1;
		#80:m:=m+1;
		#27:E:=1;
		'e':E:=1;
		#13:begin
			if m < 6 then
				begin
					a:=0;
					if (ches.chesinv[c,m] = 1) and (a = 0) then
						begin
						k:=0;
						for i:=1 to 10 do
							if not (play.inv[i] = 1) and (k = 0) then
								begin
								k:=1;
								ches.chesinv[c,m] := play.inv[i];
								play.inv[i]:=1;
								end;
						a:=1;
						end;

					if not (ches.chesinv[c,m] = 1) and (a = 0) then
						begin
						k:=0;
						for i:=1 to 10 do
							if (play.inv[i] = 1) and (k = 0) then
								begin
								k:=1;
								play.inv[i]:=ches.chesinv[c,m];
								ches.chesinv[c,m]:=1;
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
									st := CRT_Draw.itemlist(ches.chesinv[c,i]);
									write(i,':',st);
							end;

							gotoxy(30,15);
							write('pick-up');

						end;


		if m = 6 then
			begin
			k:=0;
			for i := 1 to 5 do
				if not (ches.chesinv[c,i] = 1)then
					k:=1;
			if (k = 0) then
				begin
					for i:=1 to 10 do
						if (play.inv[i] = 1) and (k = 0) then
							begin
							k:=1;
							play.inv[i]:=12;
							map[ches.chesx[c],ches.chesy[c],play.pz]:=1;
							ches.chesx[c]:=0;
							ches.chesy[c]:=0;
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
						begin
							st := CRT_Draw.itemlist(ches.chesinv[c,m1]);
							write(m1,':',st);
						end;
					if not (m1 < 6) then
						write('pick-up');
						
						gotoxy(30,9+m);
						textcolor(2);
						st := CRT_Draw.itemlist(ches.chesinv[c,m]);
						write(m,':',st);
					end;
				if m = 6 then
					begin
					gotoxy(30,9+m1);
					textcolor(8);
					st := CRT_Draw.itemlist(ches.chesinv[c,m1]);
					write(m1,':',st);
					gotoxy(30,9+m);
					textcolor(2);
					write('pick-up');
					end;
			end;

	end;
	st:='#';
until E = 1;

redraw(true,29,9,51,16);
textbackground(1);
textcolor(1);
end;

end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure chesplace(l:integer);
var s:string;
	i,j,k:integer;
begin
map[play.px,play.py,play.pz]:=play.inv[l];
k:=0;
	for i:=1 to 50 do
		if (ches.chesx[i] = 0) and (ches.chesy[i] = 0) and (k = 0) then
			begin
			ches.chesx[i]:=play.px;
			ches.chesy[i]:=play.py;
			ches.chesz[i]:=play.pz;
			for j:=1 to 5 do
				ches.chesinv[i,j]:=1;
			k:=1;
			end;

end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure make();
var b,e,k,s,bl,a,d,x,y,r,r1,i,j:integer;
begin
textbackground(0);
clrscr;
randomize;
bl := 0;
play.pl := 0;
play.ph := 100;
ms:=1;


for i:=1 to 50 do
	begin
	ches.chesx[i]:=0;
	ches.chesy[i]:=0;
	end;
for i:=1 to 50 do
	for j:=1 to 5 do
                ches.chesinv[i,j]:=1;

for i:=1 to MAXE do
enemyarr[i].ent := 0;

for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		c[i,j,play.pz]:=8;

for i:=MINX+1 to MAXX-1 do
	for j:=MINY+1 to MAXY-1 do
		map[i,j,play.pz]:=0;

for i := 1 to 10 do
	play.inv[i]:=1;




for j:=1 to MAXZ do
	begin
	CRT_Draw.loadbar(j,MAXZ,cd,'Generating random Tunnels',DEBUG);
	x:=round(MAXX/2);
	y:=round(MAXY/2);
	d:=1;
	for i:=1 to 5999 do
		begin
		
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

		if map[x,y,j] = 0 then
			map[x,y,j] := 1;
		
		d:=r;
		end;				
	end;


	
for i:=2 to MAXX-1 do
	for j:=2 to MAXY-1 do
		for d:=1 to MAXZ do
			c[i,j,d]:=map[i,j,d];
e:=0;
repeat
	begin
	for d:=1 to MAXZ do
		for i:=2 to MAXX-1 do
			for j:=2 to MAXY-1 do
				begin
				a:=0;
				e:=0;
				
				if (map[i-1,j,d] = 0) then
					a := a+1;
				if (map[i+1,j,d] = 0) then
					a := a+1;	
				if (map[i,j-1,d] = 0) then
					a := a+1;
				if (map[i,j+1,d] = 0) then
					a := a+1;
				if (map[i+1,j+1,d] = 0) then
					a := a+1;
				if (map[i+1,j-1,d] = 0) then
					a := a+1;
				if (map[i-1,j+1,d] = 0) then
					a := a+1;
				if (map[i-1,j-1,d] = 0) then
					a := a+1;
					
				if a > 4 then
				begin
				c[i,j,d]:=0;
				end;
				if a <= 3 then
				begin
				c[i,j,d]:=1;	
				end;
				
			end;
		for d:=1 to MAXZ do
			for i:=1 to MAXX do
				for j:=1 to MAXY do
					begin
					if map[i,j,d] = c[i,j,d] then
						e:=1;
					if not (map[i,j,d] = c[i,j,d]) then
						e:=0;	
					end;	
		for d:=1 to MAXZ do			
			for i:=2 to MAXX-1 do
				for j:=2 to MAXY-1 do
					map[i,j,d]:=c[i,j,d];
	end;	
until e = 1;

for d:=1 to MAXZ do	
begin
		CRT_Draw.loadbar(d,MAXZ,cd,'Adding ores',DEBUG);
for i:=MINX+1 to MAXX-1 do
	 for j:=MINY+1 to MAXY-1 do
		begin
		r := random(10);
		if map[i,j,d] = 0 then
			case r of
			1:if d >= 1 then map[i,j,d]:=2;
			2:if d >= 3 then map[i,j,d]:=3;
			3:if d >= 6 then map[i,j,d]:=4;
			4:if d >= 14 then map[i,j,d]:=5;
			end;
		end;
end;	
s:=0;
for d:=1 to MAXZ do	
begin
	r1 := random(20)+3;
		CRT_Draw.loadbar(d,MAXZ,cd,'Finding spawner locations',DEBUG);
		
for i:=MINX+1 to MAXX-1 do
	 for j:=MINY+1 to MAXY-1 do
		begin
		if r1 >= 0 then
			begin
			a:=0;
			if map[i-1,j,d] = 1 then
				a := a+1;
			if map[i+1,j,d] = 1 then
				a := a+1;
			if map[i,j-1,d] = 1 then
				a := a+1;
			if map[i,j+1,d] = 1 then
				a := a+1;
			if map[i+1,j+1,d] = 1 then
				a := a+1;
			if map[i+1,j-1,d] = 1 then
				a := a+1;
			if map[i-1,j+1,d] = 1 then
				a := a+1;
			if map[i-1,j-1,d] = 1 then
				a := a+1;
			r := random(32);
			if (a <= 5) and (a >= 2) and (r = 1) then
					begin
						map[i,j,d]:=9;
						r1:=r1-1;
						s := s + 1;
					end;
			end;
		end;
end;


for i:=2 to MAXX-1 do
	for j:=2 to MAXY-1 do
		begin
		a:=0;
		b:=0;		
				if map[i-1,j,1] = 1 then
					a := a+1;
				if map[i+1,j,1] = 1 then
					a := a+1;
				if map[i,j-1,1] = 1 then
					a := a+1;
				if map[i,j+1,1] = 1 then
					a := a+1;
				if map[i+1,j+1,1] = 1 then
					a := a+1;
				if map[i+1,j-1,1] = 1 then
					a := a+1;
				if map[i-1,j+1,1] = 1 then
					a := a+1;
				if map[i-1,j-1,1] = 1 then
					a := a+1;
				if map[i-1,j,1] = 16 then
					b := b+1;
				if map[i+1,j,1] = 16 then
					b := b+1;
				if map[i,j-1,1] = 16 then
					b := b+1;
				if map[i,j+1,1] = 16 then
					b := b+1;
				if map[i+1,j+1,1] = 16 then
					b := b+1;
				if map[i+1,j-1,1] = 16 then
					b := b+1;
				if map[i-1,j+1,1] = 16 then
					b := b+1;
				if map[i-1,j-1,1] = 16 then
					b := b+1;
				if (a >= 7)  and (b = 0) then
					begin
					r:=random(20)+1;
					if r = 1 then
						map[i,j,1]:=16;
					end;
		end;
for d:=3 to MAXZ do	
begin
for i:=MINX+1 to MAXX-1 do
	 for j:=MINY+1 to MAXY-1 do
		begin
		a:=0;
		b:=0;		
				if map[i-1,j,d] = 1 then
					a := a+1;
				if map[i+1,j,d] = 1 then
					a := a+1;
				if map[i,j-1,d] = 1 then
					a := a+1;
				if map[i,j+1,d] = 1 then
					a := a+1;
				if map[i+1,j+1,d] = 1 then
					a := a+1;
				if map[i+1,j-1,d] = 1 then
					a := a+1;
				if map[i-1,j+1,d] = 1 then
					a := a+1;
				if map[i-1,j-1,d] = 1 then
					a := a+1;
				if map[i-1,j,d] = 17 then
					b := b+1;
				if map[i+1,j,d] = 17 then
					b := b+1;
				if map[i,j-1,d] = 17 then
					b := b+1;
				if map[i,j+1,d] = 17 then
					b := b+1;
				if map[i+1,j+1,d] = 17 then
					b := b+1;
				if map[i+1,j-1,d] = 17 then
					b := b+1;
				if map[i-1,j+1,d] = 17 then
					b := b+1;
				if map[i-1,j-1,d] = 17 then
					b := b+1;
				if (a >= 7)  and (b = 0) then
					begin
					r:=random(40)+1;
					if r = 1 then
						map[i,j,d]:=17;
					end;
		end;
end;
		
redraw(true,MINX,MINY,MAXX,MAXY);		
play.px := 1;
play.py := 1;
d := 0;
for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		if (d = 0) and (map[i,j,play.pz] = 1) then
			begin
				a:=0;
				
				if map[i-1,j,play.pz] = 1 then
					a := a+1;
				if map[i+1,j,play.pz] = 1 then
					a := a+1;
				if map[i,j-1,play.pz] = 1 then
					a := a+1;
				if map[i,j+1,play.pz] = 1 then
					a := a+1;
				if map[i+1,j+1,play.pz] = 1 then
					a := a+1;
				if map[i+1,j-1,play.pz] = 1 then
					a := a+1;
				if map[i-1,j+1,play.pz] = 1 then
					a := a+1;
				if map[i-1,j-1,play.pz] = 1 then
					a := a+1;
				
				if a = 8 then
					begin
						textcolor(9);
						gotoxy(i,j);
						write(chr(1));
						play.px := i;
						play.py := j;
						play.psx := i;
						play.psy := j;
						d := 1;
					end;
			end;
for d:=1 to MAXZ do				
	for i:=1 to MAXX do
		for j:=1 to MAXY do
			if (i = 1) or (i = MAXX) or (j = 1) or (j = MAXY) then
				map[i,j,d]:=8;
				
for i:=1 to MAXX do
	for j:=1 to MAXY do
		if (i = 1) or (i = MAXX) or (j = 1) or (j = MAXY) then
			begin
			textcolor(8);
			gotoxy(i,j);
			write(chr(206));
			end;
		
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure tree();
var x,y,i,j,r,k:integer;
begin
	x:=play.px;
	y:=play.py;
	case play.pd of
	1:x:=x-1;
	2:x:=x+1;
	3:y:=y-1;
	4:y:=y+1;
	end;
	k:=random(5)+2;
	for i:=x-2 to x+2 do
		for j:=y-2 to y+2 do
			if (i <= MAXX-1) and (i >= MINX+1) and (j <= MAXY-1) and (j >= MINY+1) then
			begin
			r:=random(6)+1;
			if (r = 1) and (map[i,j,play.pz] = 1) and (k > 0) then
				begin
				k:=k-1;
				map[i,j,play.pz]:=31;
				end;
			end;

	map[x,y,play.pz]:=30;
	redraw(true,x-2,y-2,x+2,y+2)
end;

{can Touch This Script}
procedure invt(b:integer);
var k,i:integer;
	st:string;
begin
k:=0;
for i := 1 to 10 do
	begin
	if k = 0 then
		if play.inv[i] = 1 then
		begin
		k:=1;
		sve:=1;
		if (play.pl >= 10) then
		begin
			if b = 31 then
				begin
				play.inv[i]:=31;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;
			if b = 30 then
				begin
				play.inv[i]:=30;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;
			if b = 33 then
				begin
				play.inv[i]:=33;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;
			if b = 32 then
				begin
				play.inv[i]:=32;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;	
			if b = 25 then
				begin
				play.inv[i]:=25;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;	
			if b = 24 then
				begin
				play.inv[i]:=24;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;	
			if b = 22 then
				begin
				play.inv[i]:=22;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;
			if b = 21 then
				begin
				play.inv[i]:=21;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;
			if b = 20 then
				begin
				play.inv[i]:=20;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;
		
		
			if b = 19 then
				begin
				play.inv[i]:=19;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;
		
		
			if b = 17 then
				begin
				play.inv[i]:=17;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;

			if b = 16 then
				begin
				play.inv[i]:=31;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				tree;
				end;

			if (b = 14) and not (play.pz = MAXZ) then
				begin
				play.inv[i]:=14;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; map[play.px-1,play.py,play.pz+1] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; map[play.px+1,play.py,play.pz+1] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; map[play.px,play.py-1,play.pz+1] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; map[play.px,play.py+1,play.pz+1] := 1; block(play.px,play.py+1); end;
					end;
				end;

			if b = 10 then
				begin
				play.inv[i]:=10;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;

			if b = 7 then
				begin

				play.inv[i]:=7;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;

			if b = 6 then
				begin
				play.inv[i]:=6;
					case play.pd of
					1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
					2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
					3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
					4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
					end;
				end;

		end;

		if play.pl >= 10 then
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
			if (b = 0) or (b = 2) and (play.pl >= 20) or (b = 3) and (play.pl >= 30) or(b = 4) and (play.pl >= 40) or (b = 5) and (play.pl >= 50) then
				begin
				play.inv[i]:=b;
				play.pl:=play.pl+1;
					case play.pd of
						1:begin gotoxy(play.px-1,play.py); map[play.px-1,play.py,play.pz] := 1; block(play.px-1,play.py); end;
						2:begin gotoxy(play.px+1,play.py); map[play.px+1,play.py,play.pz] := 1; block(play.px+1,play.py); end;
						3:begin	gotoxy(play.px,play.py-1); map[play.px,play.py-1,play.pz] := 1; block(play.px,play.py-1); end;
						4:begin	gotoxy(play.px,play.py+1); map[play.px,play.py+1,play.pz] := 1; block(play.px,play.py+1); end;
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
		if map[play.px,play.py,play.pz] = 1 then
			for i := 1 to 10 do
				begin
				if k = 0 then
					if play.inv[i] <> 1 then
						begin
						if play.inv[i] = 11 then
							play.ph:=play.ph + 10
						else
							if play.inv[i] = 12 then
								chesplace(i)
								else  if (play.inv[i] = 13) then
										bed(false,i)
										else
											if not (play.inv[i] = 14) and not (play.inv[i] = 18) and not (play.inv[i] = 30) then
											begin
												map[play.px,play.py,play.pz]:=play.inv[i];
												play.inv[i]:=1;								
											end;
						if play.inv[i] = 11 then
							begin
							play.inv[i]:=1;
							end;
						if play.inv[i] = 12 then
							begin
							play.inv[i]:=1;
							end;
						if (play.inv[i] = 13) then
							begin
							map[play.px,play.py,play.pz]:=13;
							play.inv[i]:=1;	
							end;
						if (play.inv[i] = 14) and not (play.pz = MAXZ) and (map[play.px,play.py,play.pz+1] = 1) then
							begin
							map[play.px,play.py,play.pz]:=14;
							map[play.px,play.py,play.pz+1]:=15;
							play.inv[i]:=1;	
							end;
						if play.inv[i] = 30 then
							begin
							play.inv[i]:=1;
							map[play.px,play.py,play.pz]:=26;
							end;
						k:=1;
						if (play.inv[i] = 18) then
							k:=0;
						end;
				end;
end;

{can Touch This Script}
procedure craft();
var error,a,b,i:integer;
	ch,ch1:char;
	st:string;
begin
if (play.pl >= 10)  then
begin
textcolor(15);
textbackground(0);
gotoxy(1,MAXY+2);
write('ingredient 1:');
readln(ch);
val(ch,a,error);
gotoxy(1,MAXY+2);
delline;
if (error = 0) and (play.pl >= 10)  then
begin
gotoxy(1,MAXY+2);
write('ingredient 2:');
readln(ch1);
val(ch1,b,error);
gotoxy(1,MAXY+2);
delline;
if (error = 0) and (play.pl >= 10) and not (a = b) then
begin

if (play.inv[a] = 3) and (play.inv[b] = 2) or (play.inv[a] = 2) and (play.inv[b] = 3) then
		begin
		play.inv[b]:=1;
		play.inv[a]:=6;
		sve:=1;
		end;

if play.inv[a] = 0 then
	if play.inv[b] = 0 then
		begin
		play.inv[b]:=1;
		play.inv[a]:=22;
		sve:=1;
		end;

if play.inv[a] = 22 then
	if play.inv[b] = 22 then
		begin
		play.inv[b]:=1;
		play.inv[a]:=21;
		sve:=1;
		end;
		
if (play.inv[a] = 2) and (play.inv[b] = 0) or (play.inv[a] = 0) and (play.inv[b] = 2) then
		begin
		play.inv[b]:=1;
		play.inv[a]:=11;
		sve:=1;
		end;

if (play.inv[a] = 19) and (play.inv[b] = 22) or (play.inv[a] = 22) and (play.inv[b] = 19) then
		begin
		play.inv[b]:=1;
		play.inv[a]:=32;
		sve:=1;
		end;		
		
if (play.inv[a] = 32) and (play.inv[b] = 0) or (play.inv[a] = 0) and (play.inv[b] = 32) then
		begin
		play.inv[b]:=1;
		play.inv[a]:=33;
		sve:=1;
		end;

if (play.inv[a] = 32) and (play.inv[b] = 19) or (play.inv[a] = 19) and (play.inv[b] = 32) then
		begin
		play.inv[b]:=1;
		play.inv[a]:=12;
		sve:=1;
		end;

if (play.inv[a] = 19) and (play.inv[b] = 31) or (play.inv[a] = 31) and (play.inv[b] = 19) then
		begin
		play.inv[b]:=1;
		play.inv[a]:=13;
		sve:=1;
		end;
		
if (play.inv[a] = 7) and (play.inv[b] = 0) or (play.inv[a] = 0) and (play.inv[b] = 7) then
		begin
		play.inv[b]:=1;
		play.inv[a]:=14;
		sve:=1;
		end;

if (play.inv[a] = 5) and (play.inv[b] = 0) or (play.inv[a] = 0) and (play.inv[b] = 5) then
		begin
		play.inv[b]:=1;
		play.inv[a]:=10;
		sve:=1;
		end;

if (play.inv[a] = 31) and (play.inv[b] = 0) or (play.inv[a] = 0) and (play.inv[b] = 31) then
		begin
		play.inv[b]:=1;
		play.inv[a]:=18;
		sve:=1;
		end;	

if (play.inv[a] = 31) and (play.inv[b] = 18) or (play.inv[a] = 18) and (play.inv[b] = 31) then		
		begin
		play.inv[b]:=19;
		play.inv[a]:=18;
		sve:=1;
		end;	

if (play.inv[a] = 19) and (play.inv[b] = 33) or (play.inv[a] = 33) and (play.inv[b] = 19) then		
		begin
		play.inv[b]:=7;
		play.inv[a]:=1;
		sve:=1;
		end;		
		
if (play.inv[a] = 19) then
	if (play.inv[b] = 19) then		
		begin
		play.inv[b]:=20;
		play.inv[a]:=1;
		sve:=1;
		end;	
		

gotoxy(1,MAXY+2);
textcolor(16);
textbackground(16);
write('                             ');
		textbackground(0);
		gotoxy(1,MAXY+1);
		for i := 1 to 4 do
				begin
				textcolor(8);
				write(i);
				textcolor(15);
				st := CRT_Draw.itemlist(play.inv[i]);
				write(':'+st);
				if not (i = 4) then
				write(':');
				if (i = 4) then
				write('       ');
				end;

end;
end;
gotoxy(1,MAXY+2);
textbackground(0);
delline;
end;
if (play.pl < 10)  then
begin
gotoxy(1,MAXY+2);
write('You have to be LVL 10 or higher to craft');
delay(500);
delline;
end;
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
				write('FPS:',fps,'  ');
				
				pretimer:=timer;
				realtime:=sec;
				if timer >= 1000 then
					begin	
						timer:=0;
						pretimer:=0;
					end;
			end;
			
	if count = 10 then
		begin
		count := 0;
			if fps > 34 then
				dely:=dely+1;
			if fps < 26 then
				dely:=dely-1;
		end;
	count:=count+1;	
	if dely > 1 then
		delay(dely);
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure time();
begin
if ms = 10 then
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
Terr;
d:=d+1;
h:=1;
end;
gotoxy(40,MAXY+1);
textcolor(15);
write(d,':',h,':',s,'  ');
ms:=ms+1;

end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure load();
var F:textfile;
	error,i,j,a,k:integer;
	st:string;
begin
	if (txtfile = '') then
	begin
	clrscr;
	gotoxy(20,10);
	Write('World to load');
	gotoxy(20,11);
	readln(txtfile);
	end;
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
						readln(F,st);
						val(st,a,error);
						play.ph:=a;

						readln(F,st);
						val(st,a,error);
						play.px:=a;

						readln(F,st);
						val(st,a,error);
						play.py:=a;
						
						readln(F,st);
						val(st,a,error);
						play.pz:=a;

						readln(F,st);
						val(st,a,error);
						play.pl:=a;

						readln(F,st);
						val(st,a,error);
						play.psx:=a;
						
						readln(F,st);
						val(st,a,error);
						play.psy:=a;
						
						readln(F,st);
						val(st,a,error);
						d:=a;

						readln(F,st);
						val(st,a,error);
						h:=a;

						readln(F,st);
						val(st,a,error);
						s:=a;
						
						readln(F,st);
						val(st,a,error);
						play.npsx:=a;
						
						readln(F,st);
						val(st,a,error);
						play.npsy:=a;
						
						readln(F,st);
						val(st,a,error);
						play.npsz:=a;
						
						
						readln(F,st);
						if st = 'TRUE' then
							BEDS:=true;
						if st = 'FALSE' then
							BEDS:=false;

						for i:=1 to 10 do
							begin
							readln(F,st);
							val(st,a,error);
							play.inv[i]:=a;
							end;

						for i:=1 to 80 do
							for j:=1 to 22 do
								for k:=1 to MAXZ do
								begin
								readln(F,st);
								val(st,a,error);
								if error = 0 then
									map[i,j,k]:=a
								else begin
								halt(5);
								end;
								end;

						for i:=1 to 50 do
							begin
								readln(F,st);
								val(st,a,error);
								if error = 0 then
									ches.chesx[i]:=a
								else begin
								halt(5);
								end;
							end;

						for i:=1 to 50 do
							begin
								readln(F,st);
								val(st,a,error);
								if error = 0 then
									ches.chesy[i]:=a
								else begin
								halt(5);
								end;
							end;
							
						for i:=1 to 50 do
							begin
								readln(F,st);
								val(st,a,error);
								if error = 0 then
									ches.chesz[i]:=a
								else begin
								halt(5);
								end;
							end;

						for i:=1 to 50 do
							for j:=1 to 5 do
								begin
									readln(F,st);
									val(st,a,error);
									if error = 0 then
										ches.chesinv[i,j]:=a
									else begin
									halt(5);
									end;
								end;
						close(F);
						textbackground(0);
						clrscr;

						redraw(true,MINX,MINY,MAXX,MAXY);
						for i:=1 to MAXX do
							for j:=1 to MAXY do
								if (i = 1) or (i = MAXX) or (j = 1) or (j = MAXY) then
									begin
									textcolor(8);
									gotoxy(i,j);
									write(chr(206));
									end;
						textcolor(9);
						gotoxy(play.px,play.py);
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
	error,i,j,a,k:integer;
	ch:char;
	st:string;
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
		readln(st);
		txtfile:=st;	
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
		write('Item List');
		gotoxy(30,13);
		write('Help');
		gotoxy(30,14);
		write('Save');

		assign(F,txtfile+'.txt');
		rewrite(F);
		writeln(F,'');
		close(F);
		end;
	
	assign(F,txtfile+'.txt');
	rewrite(F);
	writeln(F,play.ph);
	writeln(F,play.px);
	writeln(F,play.py);
	writeln(F,play.pz);
	writeln(F,play.pl);
	writeln(F,play.psx);
	writeln(F,play.psy);
	writeln(F,d);
	writeln(F,h);
	writeln(F,s);
	writeln(F,play.npsx);
	writeln(F,play.npsy);
	writeln(F,play.npsz);
	writeln(F,BEDS);
	for i:=1 to 10 do
		writeln(F,play.inv[i]);

	for i:=1 to 80 do
		for j:=1 to 22 do
			for k:=1 to MAXZ do
			begin
			writeln(F,map[i,j,k]);
			end;

	for i:=1 to 50 do
	begin
		writeln(F,ches.chesx[i]);
	end;

	for i:=1 to 50 do
	begin
		writeln(F,ches.chesy[i]);
	end;
	
	for i:=1 to 50 do
	begin
		writeln(F,ches.chesz[i]);
	end;

	for i:=1 to 50 do
		for j:=1 to 5 do
		begin
			writeln(F,ches.chesinv[i,j]);
		end;
	close(F);
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure Menu();
var E,m,m1,i,j:integer;
	st:string;
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
textcolor(2);
gotoxy(30,10);
write('Exit');
textcolor(8);
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
	st:=readkey;
	begin
	m1:=m;
	case st of
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
			readln(st);
			if (st = 'y') then
				begin
				PLAYING := FALSE;
				exit;
				end;
			if not (st = 'y') then	
			begin
				save();
				PLAYING := FALSE;
				exit;
				end;
			end;
		if sve = 0 then
			begin
			PLAYING := FALSE;
			exit;
			end;
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
	st:='#';



until (E = 1) or (PLAYING = FALSE);

redraw(true,29,9,51,16);
end;

procedure test;
var i,j:integer;
begin
for i:=0 to MAXX-1 do
	begin
	map[i+1,play.py-1,play.pz]:=i;
	map[i+1,play.py,play.pz]:=1;
	end;
redraw(TRUE,1,play.py,MAXX,play.py-1);
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure update();
var ch,ch1:char;
	i,x,y,k,d:integer;
	st:string;
	begin
	if keypressed() then
		begin
		x := play.px;
		y := play.py;
		sve:=1;
		ch:=readkey;
		case ch of	{if you want a door add it in here as one \/}
			#0: begin ch1:=readkey;
				case ch1 of
				#75 : begin  play.pd := 1; if (map[x-1,y,play.pz] = 1)  then play.px := play.px-1 else
						if (map[x-1,y,play.pz] = 7) then play.px := play.px-1 else if (map[x-1,y,play.pz] = 14) or  (map[x-1,y,play.pz] = 15) then play.px := play.px-1; redraw(false,1,1,1,1); end;
				#77 : begin  play.pd := 2; if (map[x+1,y,play.pz] = 1)  then play.px := play.px+1 else
						if (map[x+1,y,play.pz] = 7) then play.px := play.px+1 else if (map[x+1,y,play.pz] = 14) or  (map[x+1,y,play.pz] = 15) then play.px := play.px+1; redraw(false,1,1,1,1); end;
				#72 : begin  play.pd := 3; if (map[x,y-1,play.pz] = 1)  then play.py := play.py-1 else
						if (map[x,y-1,play.pz] = 7) then play.py := play.py-1 else if (map[x,y-1,play.pz] = 14) or  (map[x,y-1,play.pz] = 15) then play.py := play.py-1; redraw(false,1,1,1,1); end;
				#80 : begin  play.pd := 4; if (map[x,y+1,play.pz] = 1)  then play.py := play.py+1 else
						if (map[x,y+1,play.pz] = 7) then play.py := play.py+1 else if (map[x,y+1,play.pz] = 14) or  (map[x,y+1,play.pz] = 15) then play.py := play.py+1; redraw(false,1,1,1,1); end;
				end;
				end;
			'd' : begin
				case play.pd of
					1:begin
					k:=map[x-1,y,play.pz];
					invt(k);
					end;
					2:begin
					k:=map[x+1,y,play.pz];
					invt(k);
					end;
					3:begin
					k:=map[x,y-1,play.pz];
					invt(k);
					end;
					4:begin
					k:=map[x,y+1,play.pz];
					invt(k);
					end;
					end;
				redraw(false,1,1,1,1);
			end;
			's' : begin drop(); redraw(false,1,1,1,1); end;
			'a' : craft();
			#27 : menu();
			'e' : invmenu();
			'+' : if DEBUG = true then h:=h+1;
			'-' : if DEBUG = true then h:=h-1;
			't' : if DEBUG = true then test;
			'k' : begin 
					ch:=readkey;
					if ch = 'i' then
						begin
						ch:=readkey;
							if ch = 'l' then
								begin
									ch:=readkey;
									if ch = 'l' then
										begin
										DEBUG:=TRUE;
										end;
								end;
						end;
				  end;

		end;
		d:=0;
		if (map[play.px,play.py,play.pz] = 14) then
			begin
			play.pz:=play.pz+1;
			redraw(true,MINX,MINY,MAXX,MAXY);
			LAYER:=True;
			d:=1;
			end;
		if (d = 0) and (map[play.px,play.py,play.pz] = 15) then
			begin
			play.pz:=play.pz-1;
			redraw(true,MINX,MINY,MAXX,MAXY);
			LAYER:=True;
			end;
		block(x,y);
		textcolor(9);
		textbackground(0);
		gotoxy(play.px,play.py);
		write(chr(1));
		end;

		textbackground(0);
		gotoxy(1,MAXY+1);
		for i := 1 to 4 do
				begin
				textcolor(8);
				write(i);
				textcolor(15);
				st := CRT_Draw.itemlist(play.inv[i]);
				write(':'+st);
				if not (i = 4) then
				write(':');
				if (i = 4) then
				write('       ');
				end;
		time();

		begin
		if play.ph > 100 then
			play.ph:=100;
		gotoxy(55,MAXY+1);
		textcolor(15);
		write('H:',play.ph,'   ');
		
		if play.ph < 0 then
			begin
			if BEDS = true then
				begin
				play.px:=play.npsx;
				play.py:=play.npsy;
				play.pz :=play.npsz;
				end;
			if BEDS = false then
				begin
				play.px:=play.psx;
				play.py:=play.psy;
				play.pz := 1;
				end;
			play.ph:=100;
			play.pl:=play.pl-10;
			if play.pl < 0 then
				play.pl:=0;
			textcolor(9);
			textbackground(0);
			gotoxy(play.px,play.py);
			write(chr(1));
			end;
			
		end;
	end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure enemy();
var r3,r2,r1,r,x,y,i,j,k:integer;
	d,d1,a,b:real;
begin

if LAYER = True then
	begin
	LAYER:=FALSE;
	for i:=1 to MAXE do
		begin
			if (enemyarr[i].ent = 1) then
				begin
					enemyarr[i].enb :=0;
					enemyarr[i].enh :=0;
					enemyarr[i].ent := 0;
					redraw(true,enemyarr[i].enx-1,enemyarr[i].eny-1,enemyarr[i].enx+1,enemyarr[i].eny+1);
				end;
			n:=0;
		end;
		if h >= 16 then
		if n = 0 then
		begin
		ec1:=1;
		for i:=MINX to MAXX do
			for j:=MINY to MAXY do
				if (map[i,j,play.pz] = 9) and (ec1+1 < MAXE) then
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
	end;


if h >= 16 then
if n = 0 then
begin
ec1:=1;
for i:=MINX to MAXX do
	for j:=MINY to MAXY do
		if (map[i,j,play.pz] = 9) and (ec1+1 < MAXE) then
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

if (h >= 7) and (h < 16)then
	for i:=1 to MAXE do
		begin
			if (enemyarr[i].ent = 1) then
				begin
					enemyarr[i].enb :=0;
					enemyarr[i].enh :=0;
					enemyarr[i].ent := 0;
					redraw(true,enemyarr[i].enx-1,enemyarr[i].eny-1,enemyarr[i].enx+1,enemyarr[i].eny+1);
				end;
			n:=0;
		end;
		
for i:=1 to MAXE do
	if (enemyarr[i].ent = 1) and (enemyarr[i].enh > 0) then
		begin		
			if enemyarr[i].enm >= 10 then
				begin
					x:=enemyarr[i].enx;
					y:=enemyarr[i].eny;
					
					
					d := sqr(x - play.px);
					d1 := sqr(y - play.py);
					a := sqrt(d+d1);
					if a <= 5 then
						r:=5;
					if a > 5 then	
						r := random(5);
						
					if a > 5 then
						enemyarr[i].enb:=0;
						
					case r of
						1:begin if map[x-1,y,play.pz] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
								if map[x-1,y,play.pz] = 1 then
									x:=x-1;
									end;
						2:begin if map[x+1,y,play.pz] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
								if map[x+1,y,play.pz] = 1 then
									x:=x+1;
									end;
						3:begin if map[x,y-1,play.pz] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
								if map[x,y-1,play.pz] = 1 then
									y:=y-1;
									end;
						4:begin if map[x,y+1,play.pz] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
								if map[x,y+1,play.pz] = 1 then
									y:=y+1;
									end;
						5:begin
							if a <= 5 then
							begin
							r1 := random(5);
							ec1:=0;	
							if (play.px < x) or (r1 = 1) then
								if (map[x-1,y,play.pz] = 1) and (ec1 = 0) then
									begin
									if map[x-1,y,play.pz] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
									x:=x-1;
									ec1:=1;
									end;
							
							if (play.px > x) or (r1 = 2) then
								if (map[x+1,y,play.pz] = 1) and (ec1 = 0) then
									begin
									if map[x+1,y,play.pz] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
									x:=x+1;
									ec1:=1;
									end;
								
							if (play.py < y) or (r1 = 3) then
								if (map[x,y-1,play.pz] = 1) and (ec1 = 0) then
									begin
									if map[x,y-1,play.pz] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
									y:=y-1;
									ec1:=1;
									end;
							
							if (play.py > y) or (r1 = 4) then
								if (map[x,y+1,play.pz] = 1) and (ec1 = 0) then
									begin
									if map[x,y+1,play.pz] = 6 then
									begin
									enemyarr[i].ent := 0;
									redraw(true,enemyarr[i].enx-1,enemyarr[i].enx-1,enemyarr[i].enx+1,enemyarr[i].enx+1);
									end;
									y:=y+1;
									ec1:=1;
									end;
							
							if (map[x-1,y,play.pz] = 0) or  (map[x+1,y,play.pz] = 0) or (map[x,y-1,play.pz] = 0) or (map[x,y+1,play.pz] = 0) or (map[x-1,y,play.pz] = 7) or  (map[x+1,y,play.pz] = 7) or (map[x,y-1,play.pz] = 7) or (map[x,y+1,play.pz] = 7) then
								begin
								enemyarr[i].enb:=enemyarr[i].enb+1;
								if enemyarr[i].enb > 10 then
									begin
										case r1 of
										1:if (map[x-1,y,play.pz] = 0) or (map[x-1,y,play.pz] = 7) then map[x-1,y,play.pz]:=1;
										2:if (map[x+1,y,play.pz] = 0) or (map[x+1,y,play.pz] = 7) then map[x+1,y,play.pz]:=1;
										3:if (map[x,y-1,play.pz] = 0) or (map[x,y-1,play.pz] = 7) then map[x,y-1,play.pz]:=1;
										4:if (map[x,y+1,play.pz] = 0) or (map[x,y+1,play.pz] = 7) then map[x,y+1,play.pz]:=1;
										end;
										enemyarr[i].enb:=0;
									end;
								
								end;
							end;
						  end;
						end;
					ec1:=0;
					if (play.px = x) and (play.py = y) and (ec1 = 0) then
						begin
						r3:=random(5);
						if r3 = 1 then
						case enemyarr[i].enty of
							1:begin play.ph:=play.ph-(random(10)+1);  enemyarr[i].enh:=enemyarr[i].enh-1;   end;
							2:begin play.ph:=play.ph-(random(10)+5); enemyarr[i].enh:=enemyarr[i].enh-1;   end;
							3:begin play.ph:=play.ph-(random(5)+1);  enemyarr[i].enh:=enemyarr[i].enh-1;  end;
							4:begin play.ph:=play.ph-(random(30)+1);  enemyarr[i].enh:=enemyarr[i].enh-1;  end;
							5:begin play.ph:=play.ph-(random(40)+20); enemyarr[i].enh:=enemyarr[i].enh-1;   end;
						end;
						ec1:=1;
						end;
					if (enemyarr[i].enh <= 0) then
						begin
							enemyarr[i].enb :=0;
							enemyarr[i].ent := 0;
							redraw(true,enemyarr[i].enx-1,enemyarr[i].eny-1,enemyarr[i].enx+1,enemyarr[i].eny+1);
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
					redraw(true,enemyarr[i].enx-1,enemyarr[i].eny-1,enemyarr[i].enx+1,enemyarr[i].eny+1);
			enemyarr[i].enm:=enemyarr[i].enm+1;
			end;
		end;
		

{Do Not Touch This Script IT WILL BREAK!!!}
procedure start;
var i,j,k,l,a,error:integer;
	F:textfile;
	st:string;
begin	
dely:=29;			
play.pz:=1;
for l:=1 to MAXZ do
for i:=1 to MAXX do
	for j:=1 to MAXY do
		begin
		gmap[i,j,l].grasstype:=random(4)+1;
			
		k:=random(2)-1;
		if k = 0 then
			gmap[i,j,l].forground:=False
		else
			gmap[i,j,l].forground:=True;	
		end;
for l:=1 to MAXZ do
for i:=1 to MAXX do
	for j:=1 to MAXY do
		begin
		k:=random(2)-1;
		if k = 0 then
			v[i,j,l]:=1
		else
			v[i,j,l]:=0;	
		end;
for l:=1 to MAXZ do
for i:=1 to MAXX do
	for j:=1 to MAXY do
		dama[i,j,l]:=0;
		dama[i,j,l]:=0;

LAYER:=FALSE;
pretimer:=0;
timer:=0;
clrscr;
txtfile:='';
CRT_Draw.animate(VersionNum);		
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
clrscr;
textcolor(2);
WriteCenter(40,10,'Start New Game');
textcolor(15);
WriteCenter(40,11,'Load Existing');
WriteCenter(40,12,'Continue');
WriteCenter(40,13,'Quit');
m := 1;
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
	   4:begin ph1:=4; Done:=true; end;
	   end;
   end;



	if (m > 4) then
		m:=1;
	if (m < 1) then
		m:=4;
	if (m1 > 4) then
		m1:=1;
	if (m1 < 1) then
		m1:=4;
		
if not (m = m1) then
		begin

					textcolor(15);
					case m1 of
						1:WriteCenter(40,9+m1,'Start New Game');
						2:WriteCenter(40,9+m1,'Load Existing');
						3:WriteCenter(40,9+m1,'Continue');
						4:WriteCenter(40,9+m1,'Quit');
					end;


					textcolor(2);
					case m of
						1:WriteCenter(40,9+m,'Start New Game');
						2:WriteCenter(40,9+m,'Load Existing');
						3:WriteCenter(40,9+m,'Continue');
						4:WriteCenter(40,9+m,'Quit');
					end;
		end;
until Done;

textcolor(15);
textbackground(0);
clrscr;
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure Cont();
var st:string;
	F :Textfile;
begin
				CONF:=TRUE;
				WriteCenter(41,9,'Opening Config File');
				assign(F,'Config.txt');
				{$i-}
				reset(F);
				close(F);
				{$i+}
				if IOResult<>0 then
					begin	
								writeln('Error Opening File');
								assign(F,'Config.txt');
								rewrite(F);
								writeln(F,'FALSE');
								writeln(F,'');
								close(F);
								CONF:=FALSE;
								exit;
					end;
				delay(1000);
				if IOResult = 0 then
					begin
						WriteCenter(40,10,'No Error Opening File');
						assign(F,'Config.txt');
						reset(F);
						readln(F,st);
						if st = 'TRUE' then
							DEBUG:=true;
						if st = 'FALSE' then
							DEBUG:=false;
						readln(F,st);
						if st = '' then
							txtfile:=''
						else
							txtfile:=st;
						close(F);
						delay(1000);
						
						if not (txtfile = '') then
							begin
							WriteCenter(40,11,'File Found To continue from!');
							readkey;
							end;
						
						if not (txtfile = '') then
							load()
						else
							begin
							WriteCenter(40,11,'No File To continue from!');
							delay(1000);
							WriteCenter(40,12,'Starting new Game');
							readkey;
							CONF:=FALSE;
							end;
					end;
				
end;

{Do Not Touch This Script IT WILL BREAK!!!}
procedure cleanup();
var st:string;
	F :Textfile;
begin
	clrscr;
	if not (txtfile = '') then
		begin
			assign(F,'Config.txt');
				{$i-}
				reset(F);
				close(F);
				{$i+}
				
				if IOResult<>0 then
					begin
								assign(F,'Config.txt');
								rewrite(F);
								writeln(F,'FALSE');
								writeln(F,'');
								close(F);
								halt;
					end;
				if IOResult = 0 then
					begin
					assign(F,'Config.txt');
					rewrite(F);
					writeln(F,'FALSE');
					writeln(F,txtfile);
					close(F);
					end;
		end;
end;


{Do Not Touch This Script IT WILL BREAK!!!}
begin
PLAYING := TRUE;
CONF:=TRUE;
start;
MainMenu;


case ph1 of
1:make();
2:load();
3:Cont();
4:halt();
end;

if CONF = FALSE then
	make();
	
repeat
frame;
timer:=timer+1;
update();
enemy();
until PLAYING = false;
cleanup;
end.
