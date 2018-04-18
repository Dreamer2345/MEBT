unit MEBTUTILS;

interface
function itemlist(x:integer):string;
procedure Intro;

implementation
uses CansDraw,sysutils,keyboard,math;

const 
	FOV = 40;

type
	ln = record
	x,y,x1,y1,c:integer;
	end;

var
	Lines : array[1..15] of ln;

function itemlist(x:integer):string;
var I:integer;
begin
	I:=101;
		if not (x > I) then
		case x of
			0:itemlist:='';
			1:itemlist:='Stone';
			2:itemlist:='Water';
			3:itemlist:='Mythril';
			4:itemlist:='Grmite';
			5:itemlist:='Primite';
			6:itemlist:='Drnite';
			7:itemlist:='Tree';
			8:itemlist:='Boulder';
			9:itemlist:='W-Door';
			10:itemlist:='Lava';
			11:itemlist:='Log';
			12:itemlist:='Sapling';
			13:itemlist:='C-Table';
			14:itemlist:='S-Wall';
			15:itemlist:='S-Door';
			16:itemlist:='Hinge';
			17:itemlist:='Bolt';
			18:itemlist:='Cog';
			19:itemlist:='Stick';
			20:itemlist:='Bush';
			21:itemlist:='Seed';
			22:itemlist:='Furnace';
			23:itemlist:='Plank';
			24:itemlist:='W-Wall';
			25:itemlist:='Hpak'; /// No texture
			26:itemlist:='S-Brick';
			27:itemlist:='S-Hpak'; /// No texture
			28:itemlist:='Appa';
			29:itemlist:='S-Appa'; 
			30:itemlist:='G-Sapling';
			31:itemlist:='G-Bush';
			32:itemlist:='Stairs';
			33:itemlist:='Stairs-U';
			34:itemlist:='Chest';
			35:itemlist:='Torch';
			36:itemlist:='Cloth';
			37:itemlist:='Fiber';
			38..99:itemlist:='err:'+IntToStr(x);
			100:itemlist:='Spear';
			101:itemlist:='Axe';
			
		end;
		
		if (x > I) then
			itemlist:='err:'+IntToStr(x-I);
		
end;

procedure SETLINE(n,x,y,x1,y1:integer);
begin
Lines[n].x := x;
Lines[n].y := y;
Lines[n].x1 := x1;
Lines[n].y1 := y1;
end;


procedure Intro;
var x,y,x1,y1,r,i,cx,cy,cz,MIDX,MIDY:integer;
	f,f1:real;
	Direct:boolean;
begin


SETLINE(1,-10,5,-10,0);
SETLINE(2,-10,5,-8,0);
SETLINE(3,-8,0,-6,5);
SETLINE(4,-6,5,-6,0);

SETLINE(5,-4,5,-4,0);
SETLINE(6,-4,3,-2,3);
SETLINE(7,-4,5,-1,5);
SETLINE(8,-4,0,-1,0);

SETLINE(9,1,5,1,0);
SETLINE(10,1,5,5,4);
SETLINE(11,5,4,3,3);
SETLINE(12,3,3,5,2);
SETLINE(13,5,2,1,0);

SETLINE(14,7,5,12,5);
SETLINE(15,10,5,10,0);

InitKeyboard;
MIDX := round(ScreenW/2);
MIDY := round(ScreenH/2);
r := 0;
cx := 0;
cy := 2;
cz := 20;
Direct := true;
while not keypressed do
	begin
	if (Direct = true) and (cz < 40) then	
		inc(cz)
	else
		Direct := false;
	
	if (Direct = false) and (cz > 21) then	
		dec(cz)
	else
		Direct := true;
	
	
	for i:=1 to 15 do
		begin
		x := Lines[i].x-cx;
		y := Lines[i].y-cy;
		x1 := Lines[i].x1-cx;
		y1 := Lines[i].y1-cy;

		

			
	
		Rotate2D(x,y,r);
		Rotate2D(x1,y1,r);

		
		if cz <> 0 then
			f := FOV/cz
		else
			f := FOV;		

		

		
		x := round(x * f);
		y := round(y * f);
		x1 := round(x1 * f);
		y1 := round(y1 * f);
		
		
		CreateLine(x+MIDX,MIDY-y,x1+MIDX,MIDY-y1,15,'#');
		end;
	Writecenter(40,35,15,'[Press any key to begin]');
	update(true);
	sleep(10);
	for i:=1 to 15 do
		begin
		x := Lines[i].x-cx;
		y := Lines[i].y-cy;
		x1 := Lines[i].x1-cx;
		y1 := Lines[i].y1-cy;

		

			
	
		Rotate2D(x,y,r);
		Rotate2D(x1,y1,r);

		
		if cz <> 0 then
			f := FOV/cz
		else
			f := FOV;		

		

		
		x := round(x * f);
		y := round(y * f);
		x1 := round(x1 * f);
		y1 := round(y1 * f);
		
		
		CreateLine(x+MIDX,MIDY-y,x1+MIDX,MIDY-y1,0,chr(1));
		end;

	CreateLine(1,35,80,35,0,chr(1));
	
	
	inc(r);
	if r > 359 then
		begin
		r := 0;
		end;





	end;
	
	
	GetKeyEvent;
	
end;










end.