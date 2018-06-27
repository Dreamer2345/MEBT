unit MEBTUTILS;

interface
function itemlist(x:integer):string;
procedure Intro;
function Combine(x,y:integer):integer;
function Tool(x:integer):boolean;
function EnemyName(x:integer):string;


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
begin
		case x of
			0:itemlist:='';
			1:itemlist:='Stone';
			2:itemlist:='Water';
			3:itemlist:='Mythril'; //Iron Substitute
			4:itemlist:='Grmite'; //Coal Substitute
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
			21:itemlist:='B-Seed';
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
			38:itemlist:='W-Floor';
			39:itemlist:='S-Floor';
			40:itemlist:='W-Panel';
			41:itemlist:='Ash';
			42:itemlist:='Bucket';
			43:itemlist:='Bucket-W';
			44:itemlist:='Bucket-L';
			45:itemlist:='DynWater';
			46:itemlist:='DynLava';
			47:itemlist:='Fire';
			48:itemlist:='Flax';
			49:itemlist:='F-Seed';
			50:itemlist:='G-flax';
			51:itemlist:='Flax Plant';
			52:itemlist:='Sand';
			53:itemlist:='Glass';
			54:itemlist:='Window';
			55:itemlist:='Bed';
			100:itemlist:='Spear';
			101:itemlist:='Axe';
			102:itemlist:='Handle';
			103:itemlist:='Pickaxe';
			104:itemlist:='Pebble';
			else itemlist:='err:'+IntToStr(x);
		end;
end;


function EnemyName(x:integer):string;
	begin
		case x of
		0:EnemyName:='Human_Savage';
		1:EnemyName:='Wolf';
		2:EnemyName:='Devil_Dog';
		3:EnemyName:='Ogre';
		4:EnemyName:='Troll';
		5:EnemyName:='Zombie';
		end;
	end;


function Tool(x:integer):boolean;
begin
	Tool := false;
	case x of
	101:Tool := true;
	100:Tool := true;
	end;		
end;

function Combine(x,y:integer):integer;
var i : integer;
begin
	if y < x then
		begin
		i := x;
		x := y;
		y := i;
		end;
	Combine := 0;
	case x of
	1: case y of
	   1:Combine := 26;
	   16:Combine := 15;
	   19:Combine := 17;
	   102:Combine := 101;
	   end;
	19: case y of
		19:Combine := 102;
		36:Combine := 35;
		end;
	11: case y of
		101:Combine := 23;
		23:Combine := 40;
		40:Combine := 24;
		end; 
	16: if y = 40 then
			Combine := 9;
	17: case y of
		23:Combine := 16;
		end;
	23: case y of
		40:Combine := 32;
		end;	
	26: case y of
		101:Combine := 14;
		26:Combine := 22;
		end; 
	37: case y of
		37:Combine := 36;
		end;	
	40: case y of
		40:Combine := 38;
		end;		
	48: case y of
		101:Combine := 37;
		end;
	end;
end;

procedure SETLINE(n,x,y,x1,y1:integer);
begin
Lines[n].x := x;
Lines[n].y := y;
Lines[n].x1 := x1;
Lines[n].y1 := y1;
end;


procedure Intro;
var x,y,x1,y1,r,i,cx,cy,cz,MIDX,MIDY,col:integer;
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
col := 15;
Direct := true;
while not keypressed do
	begin
	if (Direct = true) and (cz <= 40) then	
		inc(cz)
	else
		Direct := false;
	if (Direct = false) and (cz >= 20) then	
		dec(cz)
	else
		Direct := true;
	
	if (cz = 40) then
		col := random(15)+1;
	
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
		
		
		CreateLine(x+MIDX,MIDY-y,x1+MIDX,MIDY-y1,col,'#');
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