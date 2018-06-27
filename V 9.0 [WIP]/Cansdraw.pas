unit CansDraw;

interface

type
	TVec3 = record
	x,y,z:integer;
	end;
	
	TVec3E = record
	x,y,z:real;
	end;

	Vec2E = record
	x,y:real;
	end;

	TRNode = record
	Pos,Vec:Vec2E;
	Life:integer;
	Hit:Boolean;
	end;
	
	TBlock = record
	ch:array[0..3] of char;
	color:array[0..3] of integer;
	end;
	
	TVec2 = record
	x,y:integer;
	end;
	
	TLine = record
	x,y,x1,y1:integer;
	end;
	
	TLoadZone = record
	x,y,x1,y1:integer;
	fil:string;
	Active:boolean;
	end;
	
	TVec2R = record
	x,y,r:Currency;
	end;

	TBlockC = record
	blk:char;
	col:integer;
	end;
	
var Block:array[0..255] of TBlock;
	{Player:TVec2R;}
	ScreenW,ScreenH : word;




{-=-FUNCTION LIST-=-}
{
 -=SCREEN MANAGEMENT=-
    clrscr
    lockvid/lockupdate
    unlockvid/unlockupdate
    update
	SetVMode
	Frameskip

 -=SCREEN DRAWING=-
	WriteCenter
    TextOut
	SetVid
	createBox
    createCircle
	createBox
	createLine
	createRect
	CreateMBox
    createTriangle
    SetBlock
	loadcharset

 -=Misc Functions=-
	Between
	Equal
	Dist
	Rotate2D
	Swap
	GetVersion
    GetBlock
	ToRadians	 
	PlaySnd
}




	
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Clears Screen buffer}
{ARGS:NIL}
procedure clrscr;
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Loads A char set from memory}
{ARGS:String (File name)}
procedure loadcharset(s:string);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Writes a string to screen with centering}
{ARGS:XPOS,YPOS,COLOUR (0-255),STRING}
procedure WriteCenter(x,y,c:integer;st:string);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Writes text to the screen from the starting x,y cord}
{ARGS:XPOS,YPOS,COLOUR (0-255), STRING}
procedure TextOut(X,Y,C : Word;Const S : String);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Main Buffer Access script}
{ARGS:XPOS,YPOS,COLOUR (0-255),CHAR}
procedure SetVid(X,Y,C:integer;ch:char);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Locks screen updates}
{ARGS:NIL}
procedure lockvid();
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Updates screen}
{ARGS:Boolean (If update full screen or not)}
procedure update(B:boolean); 
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Unlocks screen update}
{ARGS:NIL}
procedure unlockvid();
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Creates a rectangle in the viewing area}
{ARGS:XPOS1,YPOS1,XPOS2,YPOS2,COLOUR (0-255),CHAR,FILL? (Boolean)}
procedure createRect(x,y,x1,y1,c:integer;ch:char;Fill:boolean);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Draws a line on screen}
{ARGS:XPOS1,YPOS1,XPOS2,YPOS2,COLOUR (0-255),CHAR}
procedure createLine(x,y,x1,y1,c:integer;ch:char);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Creates a triangle  on screen}
{ARGS:VECTOR1 (VEC2),VECTOR2 (VEC2),VECTOR3 (VEC2),COLOUR (0-255),CHAR}
procedure createTriangle(V1,V2,V3:TVec2;c:integer;ch:char);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Creates a circle at a x,y pos with specified radius}
{ARGS:XPOS,YPOS,RADIUS,COLOUR (0-255),CHAR,FILL (Boolean)}
procedure createCircle(x,y,r,c:integer;ch:char;Fill:boolean);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Sets a Character to a screen cordinate using the current tile set}
{ARGS:XPOS,YPOS,BLOCK (0-255),TYPE (1-4),VARIATION}
procedure SetBlock(x,y,bl,ty,vr:integer);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Creates a message box on screen in a specified area}
{ARGS:XPOS1,YPOS1,XPOS2,YPOS2,BACKGROUND COLOUR,TEXT COLOUR,TEXT SPEED,????,STRING,AUTOSCROLL (Boolean)}
procedure CreateMBox(x,y,x1,y1,bc,tc,ts:integer;bch:char;const s:string; AUTOSCROLL:boolean);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Checks if a cordinate is in a specified area}
{ARGS:XPOS,YPOS,LOWER-X,LOWER-Y,HIGHER-X,HIGHER-Y}
function Between(x,y,x1,y1,x2,y2:integer):boolean;
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Gets the set Tile varable for a specific block}
{ARGS:BLOCK,TYPE,COLOUR}
function GetBlock(bl,ty,cl:integer):TBlockC;
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Checks if a coordinate is equal to another}
{ARGS:XPOS,YPOS,XPOS1,YPOS1}
function Equal(x,y,x1,y1:integer):boolean;
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Sets the video mode of the screen}
{ARGS:VIDEOMODE (int)}
procedure SetVMode(x:integer);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Checks the Distance between two points}
{ARGS:XPOS,YPOS,XPOS1,YPOS1}
function Dist(x,y,x1,y1:integer):integer;
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Adds frame skipping capability}
{ARGS:IF-FRAME-SKIPING,HOW MANY TO SKIP}
procedure Frameskip(B:Boolean;M:integer);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Returns the current Video functions version in string format}
{ARGS:NIL}
function GetVersion():string;
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Creates a fancy box on screen with different side and corners}
{ARGS:XPOS,YPOS,XPOS1,YPOS1,COLOUR,CORNERS,TOP-BOTTOM,LEFT-RIGHT}
procedure createBox(x,y,x1,y1,c:integer;ch,ch1,ch2:char);
{DEPRICIATED}
procedure LockUpdate;
procedure UnlockUpdate;
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Applies a 2D rotation to a  set of coordinates (0-360)}
{ARGS:XPOS,YPOS,ROTATION}
procedure Rotate2D(var x,y:integer; const r:integer);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Swaps two variables around}
{ARGS:INT2,INT2}
procedure Swap(var x,y:integer);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Turns a 0-360 value into radians}
{ARGS:Int}
function ToRadians(x:integer):real;
{Implementation not Done}
procedure Intersect(const x1,y1, x2,y2:integer; x3,y3:real; x4,y4:integer; var x,y:integer);
{ADDED:03/09/17}
{AUTHOR:Thomas Buckland}	
{FUNCTION:Plays a Wav file in Async mode from the current Directory}
{ARGS:String (File name)}
procedure PlaySnd(const k:string);



implementation
uses video,sysutils,math,keyboard,MMSystem;

const
	VERS = '0.6.1';

var FramS:boolean;
	Mis,Fram:integer;


procedure PlaySnd(const k:string);
	begin
	sndPlaySound(PChar(GetCurrentDir+'\'+k+'.wav'), SND_ASYNC or SND_LOOP);
	end;
	
	
procedure LockUpdate;
	begin
	LockScreenUpdate;
	end;
	
procedure UnlockUpdate;	
	begin
	UnlockScreenUpdate;
	end;
	
function GetVersion():string;
begin
GetVersion := VERS;
end;

procedure Frameskip(B:Boolean;M:integer);
	begin
	FramS := B;
	Mis := M;
	end;


function Dist(x,y,x1,y1:integer):integer;
	begin
	Dist := round(sqrt(sqr(x-x1)+sqr(y-y1)));
	end;	

procedure TextOut(X,Y,C : Word;Const S : String);
var
  W,P,I,M : Word;
begin 
  M := length(S);
  For I:=1 to M do
	SetVid((X-1)+I,Y,C,S[I]);
end;

procedure lockvid();
	begin
	lockScreenUpdate;
	end;
	
procedure unlockvid();
	begin
	UnlockscreenUpdate;
	end;

procedure update(B:boolean);
	begin
	if not FramS then
		UpdateScreen(B)
	else
		if Fram <= Mis then
			inc(Fram)
		else
			begin
			Fram := 0;
			UpdateScreen(B);
			end;
	end;

procedure clrscr;
	begin
	ClearScreen;
	end;	

procedure SetVid(X,Y,C:integer;ch:char);
var P:word;
	begin
	if not (X < 1) and not (Y < 1) and not (X > ScreenW) and not (Y > ScreenH) then
		begin
			P:=((X)+(Y-1)*ScreenWidth);
			VideoBuf^[P-1]:=Ord(ch)+(C shl 8);
		end;
	end;	
	
procedure WriteCenter(x,y,c:integer;st:string);
var l,i,k:integer;	
	begin
	l := length(st);
	k := (x-round(l/2));
	for i:=1 to l do
		SetVid(k+i,y,c,st[i]);
	end;
	
procedure createRect(x,y,x1,y1,c:integer;ch:char;Fill:boolean);
var i,j:integer;	
	begin
	if x > x1 then
		begin
		i := x;
		x := x1;
		x1 := i;
		end;
	if y > y1 then
		begin
		i := y;
		y := y1;
		y1 := i;
		end;
	
	
	for i := x to x1 do
		for j := y to y1 do
			if Fill then
				SetVid(i,j,c,ch)
			else
				if (i = x) or (i = x1) or (j = y) or (j = y1) then
					SetVid(i,j,c,ch);
	end;

procedure createBox(x,y,x1,y1,c:integer;ch,ch1,ch2:char);
var i,j:integer;	
	begin
	if x > x1 then
		begin
		i := x;
		x := x1;
		x1 := i;
		end;
	if y > y1 then
		begin
		i := y;
		y := y1;
		y1 := i;
		end;
	
	
	for i := x to x1 do
		for j := y to y1 do
			begin
				if ((j = y) or (j = y1)) then
					SetVid(i,j,c,ch1);
				if ((i = x) or (i = x1)) then
					SetVid(i,j,c,ch2);
				if ((i = x) or (i = x1)) and ((j = y) or (j = y1)) then
					SetVid(i,j,c,ch);
				if not (((i = x) or (i = x1)) or ((j = y) or (j = y1))) then
					SetVid(i,j,0,' ');
			end;
	end;	
	
procedure Swap(var x,y:integer);
var k:integer;	
	begin
	k := x;
	x := y;
	y := k;
	end;

function ToRadians(x:integer):real;
	begin
	ToRadians:=(x*((PI*2)/360));
	end;	
	
procedure Rotate2D(var x,y:integer; const r:integer);
var k:real;
	x1,y1:integer;
	begin
	k := ToRadians(r);
	x1 := round((x*cos(k))-(y*sin(k)));
	y1 := round((x*sin(k))+(y*cos(k)));
	x := x1;
	y := y1;
	end;

procedure Rotate3D(var P:TVec3; const PR:TVec3);
var x,y,z:integer;
	begin
	x := P.x;
	y := P.y;
	z := P.z;
	Rotate2D(x,y,PR.z);
	Rotate2D(y,z,PR.x);
	Rotate2D(z,x,PR.y);
	P.x := x;
	P.y := y;
	P.z := z;
	end;


function FNcross(x1,y1,x2,y2:real):real;
	begin
	FNcross := x1*y2 - y1*x2;
	end;
	
procedure Intersect(const x1,y1, x2,y2:integer; x3,y3:real; x4,y4:integer; var x,y:integer);
var xx,yy,det:real;
begin
  xx := FNcross(x1,y1, x2,y2);
  yy := FNcross(x3,y3, x4,y4);
  det := FNcross(x1-x2, y1-y2, x3-x4, y3-y4);
  x := round(FNcross(xx, x1-x2, yy, x3-x4) / det);
  y := round(FNcross(xx, y1-y2, yy, y3-y4) / det);
end;
	
	
procedure createLine(x,y,x1,y1,c:integer;ch:char);
var dx,dy,g,i,y2,err:integer;
	B:boolean;
begin
	B := (abs(x1 - x) < abs(y1 - y));
	if B then
		begin
		Swap(x,y);
		Swap(x1,y1);
		end;
	
	if x > x1 then
		begin
		Swap(x,x1);
		Swap(y,y1);
		end;
	
	if y > y1 then
		g := -1
	else
		g := 1;
	
	
	dx := x1 - x;
	dy := abs(y1 - y);
	y2 := y;
	err := 0;
	for i := x to x1 do
		begin
		if B then
			SetVid(y2,i,c,ch)
		else
			SetVid(i,y2,c,ch);
		err := err + dy;	
		if (err*2 >= dx) then
			begin
			y2 := y2 + g;
			err := err - dx;
			end;
		end;
  
end;


	
procedure createTriangle(V1,V2,V3:TVec2;c:integer;ch:char);
var i,j,s:integer;	
	V4,V5,V6:TVec2;
	begin
	createLine(V1.x,V1.y,V2.x,V2.y,c,ch);
	createLine(V3.x,V3.y,V2.x,V2.y,c,ch);
	createLine(V3.x,V3.y,V1.x,V1.y,c,ch);
	end;
	
	
procedure SetBlock(x,y,bl,ty,vr:integer);
	begin
	SetVid(x,y,Block[bl].color[vr],Block[bl].ch[ty]);
	end;

function GetBlock(bl,ty,cl:integer):TBlockC;
var k:TBlockC;
	begin
	k.blk := Block[bl].ch[ty];
	k.col := Block[bl].color[cl];
	GetBlock := k;
	end;
	
procedure loadcharset(s:string);
var F:textfile;
	bl:integer;
	b:byte;
	st:string;
	begin
	assign(F,s+'.txt');
	{$i-}
	reset(F);
	{$i+}
	if IOResult <> 0 then
		begin
			WriteCenter(44,11,15,'ERROR');
			update(true);
			exit;
		end;
	if IOResult = 0 then
			for bl := 0 to 255 do
				begin
				readln(F,st);
				Block[bl].ch[0] := st[1];
				Block[bl].ch[1] := st[2];
				Block[bl].ch[2] := st[3];
				Block[bl].ch[3] := st[4];
				b := ord(st[5]);
				Block[bl].color[1] := Hi(b);
				Block[bl].color[0] := Lo(b);
				b := ord(st[6]);
				Block[bl].color[3] := Hi(b);
				Block[bl].color[2] := Lo(b);
				end;
	Close(F);
	end;

procedure createCircle(x,y,r,c:integer;ch:char;Fill:boolean);
var i,j:longint;
	
	begin
	if Fill then
		begin
		for i := -r to r do
			for j := -r to r do
				if (Dist((x+i),(y+j),x,y) <= r) then
					setvid(i+x,j+y,c,ch);
		end
	else
		begin
			for i := -r to r do
				for j := -r to r do
					if (Dist((x+i),(y+j),x,y) = r) then
						setvid(i+x,j+y,c,ch);
		end;
	end;	

	
function FNcross(x,y,x1,y1:real):Currency;
	begin
	FNcross := x*y1 - y*x1;
	end;

function Intersect(V1,V2,V3,V4:TVec2):TVec2R;	
var x,y,det:Currency;
	x1,y1,x2,y2,x3,y3,x4,y4:Currency;
	O:TVec2R;
	begin
	x1 := V1.x;
	x2 := V2.x;
	x3 := V3.x;
	x4 := V4.x;
	y1 := V1.y;
	y2 := V2.y;
	y3 := V3.y;
	y4 := V4.y;
	x := FNcross(x1,y1, x2,y2);
	y := FNcross(x3,y3, x4,y4);
	det := FNcross(x1-x2, y1-y2, x3-x4, y3-y4);
	O.x := FNcross(x,x1-x2, y, x3-x4) / det;
	O.y := FNcross(y,y1-y2, y, y3-y4) / det;
	Intersect := O;
	end;	
	
function Inverse(V1:TVec2):TVec2;
	begin
	V1.x := ScreenW-V1.x;
	V1.y := ScreenH-V1.y;
	Inverse := V1;
	end;
	
procedure CreateMBox(x,y,x1,y1,bc,tc,ts:integer;bch:char;const s:string; AUTOSCROLL:boolean);
var v,p,k,k1,c,c1,sl,i,j:longint;
	s1:string;
	begin
		createRect(x,y,x1,y1,bc,bch,False);	
		if x > x1 then
			begin
				k := x1;
				x1 := x;
				x := k;
			end;
		if y > y1 then
			begin
				k := y1;
				y1 := y;
				y := k;
			end;
		
		
		x := x +1;
		y := y +1;
		x1 := x1 -1;
		y1 := y1 -1;
		j:=0;
		
		c := Dist(x,0,x1,0);
		c1 := Dist(0,y,0,y1);
		p := length(s);
		k := ceil(p/c);
		k1 := ceil(k/c1);
		sl := 1;


		while not (sl >= p) do
			begin
			s1 := '';
			for i := sl to (sl+c) do
				begin
				if i <= p then
					begin
					s1 := s1 + s[i];
					Textout(x,j+y,tc,s1);
					update(True);
					sleep(ts);
					end;
				end;
			sl := (sl+c)+1;
			if j >= c1 then
				begin
				if not AUTOSCROLL then
					begin
					while not keypressed do
						begin
						SetVid(x1+1,y1+1,8,chr(31));
						update(true);
						sleep(ts);
						SetVid(x1+1,y1+1,15,chr(31));
						update(true);
						sleep(ts);
						end;
					getkeyevent;
					SetVid(x1+1,y1+1,bc,bch);
					end;
				if AUTOSCROLL then
					sleep(ts*2);
				createRect(x,y,x1,y1,0,bch,true);	
				j := 0;
				end
			else
				inc(j);
			end;
		while not keypressed do
			begin
			SetVid(x1+1,y1+1,8,chr(31));
			update(true);
			sleep(ts);
			SetVid(x1+1,y1+1,15,chr(31));
			update(true);
			sleep(ts);
			end;
		getkeyevent;
		createRect(x-1,y-1,x1+1,y1+1,0,bch,true);	
		update(True);
		end;
		
		
function Between(x,y,x1,y1,x2,y2:integer):boolean;
var s:integer;
	begin
	if x2 < x1 then
		begin
		s := x1;
		x1 := x2;
		x2 := s;
		end;
	if y2 < y1 then
		begin
		s := y1;
		y1 := y2;
		y2 := s;
		end;
	if (x >= x1) and (x <= x2) and (y >= y1) and (y <= y2) then
		Between := true
	else
		Between := false;
	end;
	
	
function Equal(x,y,x1,y1:integer):boolean;
	begin
		if (x = x1) and (y = y1) then
		Equal := true
	else
		Equal := false;
	end;
	
procedure SetVMode(x:integer);
var M: TVideoMode;
	begin
	GetVideoModeData(x,M);
	SetVideoMode(M);
	ScreenW := ScreenWidth;
	ScreenH := ScreenHeight;
	Setcursortype(crHidden);
	end;
	
initialization
	InitVideo;
	InitKeyboard;
	SetVMode(3);
	Setcursortype(crHidden);

finalization
	DoneKeyboard;
    DoneVideo;
 
end.