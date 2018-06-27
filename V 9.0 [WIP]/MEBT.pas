program MEBT;

uses CansDraw,sysutils,keyboard,MEBTUTILS,math;

const
	MAXX = 120;
	MAXY = 120;
	MAXZ = 50;
	MAXE = 15;
	MAXR = 100;
	MAXM = 10;
	DEFLEN = 30;
	SCRW = 40;
	SCRH = 19;
	WS = 15;
	LS = 30;
	GS = 15;
	OG = 3;
	UPTIM = 12000;
	VD = 10;
	
	
type
	Tvoxel = record
	isChest,iswalk,isVis:boolean;
	C:array[1..5] of integer;
	blk,typ,colV:integer;
	end;
	
	TPlayer = record
	x,y,z,d,h,l,xp,spx,spy,spz,Armour,Attack:integer;
	inv:array[1..10] of integer;
	end;
	
	Enemy = ^TEnemy;
	
	TEnemy = record
	x,y,t,h:integer;
	next,prev:Enemy;
	end;
	
	TMessage = record
	S:String;
	A:boolean;
	Delay,Typ:integer
	end;
	
var	MAP:array[0..MAXX,0..MAXY,0..MAXZ] of Tvoxel;
	MDisp:array[0..MAXM] of TMessage;
	player:TPlayer;
	DEBUG,Playing,TORCHLIT,TIMECROSS:boolean;
	ST1,ST,STP,H,XPLU,ENEMYCOUNT,MAXALLOWED:longint;
	GameState:integer;
	SaveFile,ContinueSaveFile:string;
	Head,Tail:Enemy;

	
function InvCheck(block:integer):integer;
var i:integer;
	begin
	InvCheck := 11;
	for i := 1 to 10 do
		begin
		if player.inv[i] = block then
			begin
			InvCheck := i;
			break;
			end;
		end;
	end;

procedure MessageShift;
var tmp,tmp1:TMessage;
	PickedUp:boolean;
	i:integer;
	begin
	for i := MAXM to 0 do
		begin
		if (MDisp[i].A = true) then
			begin
			if (PickedUp = true) then
				begin
				tmp1:=MDisp[i];
				MDisp[i] := tmp;
				tmp := tmp1;
				PickedUp := false;
				end
			else
				begin
				tmp := MDisp[i];
				MDisp[i].A := false;
				PickedUp := true;
				end;
			end;
		end;
	end;	
	
procedure AddMessage(s:string;Delay,Typ:integer);
var i:integer;	
	F:boolean;
	begin
	F := false;
	for i := 0 to MAXM do
		begin
		if MDisp[i].A = false then
			begin
			MDisp[i].A := true;
			MDisp[i].S := s;
			MDisp[i].Delay := Delay;
			MDisp[i].Typ := Typ;
			F := true;
			break;
			end;
		end;
	if (F = false) then
		begin
		MessageShift;
		for i := 0 to MAXM do
			begin
			if MDisp[i].A = false then
				begin
				MDisp[i].A := true;
				MDisp[i].S := s;
				MDisp[i].Delay := Delay;
				MDisp[i].Typ := Typ;
				break;
				end;
			end;
		end;
	end;

procedure ClearMessage;
var i:integer;
	begin
	for i := 0 to MAXM do
		MDisp[i].A := false;
	end;

function MessageCount():integer;
var i,a:integer;	
	begin
	a := 0;
	for i := 0 to MAXM do
		if MDisp[i].A = true then
			inc(a);
	MessageCount := a;
	end;

function MessageLen():integer;
var i,a:integer;	
	begin
	a := DEFLEN;
	for i := 0 to MAXM do
		if MDisp[i].A = true then
			if length(MDisp[i].S) > a then
				a := length(MDisp[i].S);
	MessageLen := a;
	end;
	
procedure BoxHelper(x,y,w,h,c:integer);
	begin
	CreateBox(x,y,x+w,y+h,c,chr(79),chr(205),chr(186));
	end;
	
procedure DisplayMessages;
var MCount,i,cl:integer;
	S:string;
	begin
	MCount := MessageCount();
	if (MCount > 0) then
		begin
		if MessageLen() >= DEFLEN then
			BoxHelper(1,1,MessageLen()+1,MCount+1,8)
		else
			BoxHelper(1,1,DEFLEN,MCount+1,8);
		cl := 0;
		for i:=0 to MAXM do
			begin
			if MDisp[i].A = true then
				begin
				TextOut(2,2+cl,MDisp[i].Typ,MDisp[i].S);
				inc(cl);
				end;
			end;
		end;
	end;
	
procedure PointInit;
	begin
	randomize;
	Head := nil;
	Tail := nil;
	end;
	
procedure InsertMem(x,y,t:integer);
var tmp:Enemy;	
	begin
	inc(ENEMYCOUNT);
	new(tmp);
	tmp^.x := x;
	tmp^.y := y;
	tmp^.t := t;
	tmp^.h := 100;
	tmp^.next := nil;
	tmp^.prev := nil;
	if Head = nil then
		Head := tmp
	else
		if Tail <> nil then
			begin
			Tail^.next := tmp;
			tmp^.prev := Tail;
			end;
	Tail := tmp;
	end;
	
procedure DeleteMem(tmp:Enemy);
var tmp1:Enemy;
	begin
	dec(ENEMYCOUNT);
	if (tmp = Head) and (tmp = Tail) then
		begin
		dispose(tmp);
		Head := nil;
		Tail := nil;
		end
	else if tmp = Head then
		begin
		Head := tmp^.next;
		dispose(tmp);
		end
	else if tmp = Tail then
		begin
		Tail := tmp^.prev;
		Tail^.next := nil;
		dispose(tmp);
		end
	else
		begin
		tmp1 := tmp^.prev;
		tmp1^.next := tmp^.next;
		tmp1 := tmp^.next;
		tmp1^.prev := tmp^.prev;
		dispose(tmp);
		end;
	end;
	
procedure DumpMem;
var tmp,tmp1:Enemy;
	begin
	tmp := Head;
	while tmp <> nil do
		begin
		tmp1 := tmp^.next;
		DeleteMem(tmp);
		tmp := tmp1;
		end;
	ENEMYCOUNT:=0;
	end;		
		
procedure Cleanup;
var F:Textfile;
	st:string;
begin
assign(F,'Config.cfg');
{$i-}	
reset(F);
close(F);
{$i+}
if IOResult = 0 then
	begin
	assign(F,'Config.cfg');
	rewrite(F);
	writeln(F,DEBUG);
	writeln(F,ContinueSaveFile);
	close(F);
	end;
end;		
	
function GetB(x,y:integer):integer;	
begin
if Between(x,y,0,0,MAXX,MAXY) then
	GetB := map[x,y,player.z].blk;
end;	
	
function SetBlock(x,y,z,b:integer):integer;	
begin
map[x,y,z].blk := b;
MAP[x,y,z].isChest := false;
case b of
0:MAP[x,y,z].iswalk := true;
2:MAP[x,y,z].iswalk := true;
9:MAP[x,y,z].iswalk := true;
10:MAP[x,y,z].iswalk := true;
15..20:MAP[x,y,z].iswalk := true;
28..29:MAP[x,y,z].iswalk := true;
30..33:MAP[x,y,z].iswalk := true;
34:begin MAP[x,y,z].isChest := true; end;
41..51:MAP[x,y,z].iswalk := true;

else MAP[x,y,z].iswalk := false;
end;
end;		
	
function SetB(x,y,b:integer):integer;	
begin
SetBlock(player.x+x,player.y+y,player.z,b);
end;
	
function SetZ(x,y,z,b:integer):integer;	
begin
SetBlock(player.x+x,player.y+y,player.z+z,b);
end;
		
procedure INIT;
var i,j,l,r:integer;	
	begin
	randomize;
	InitKeyboard;
	PointInit;
	for i:=0 to MAXX do
		for j:=0 to MAXY do
			for l:=0 to MAXZ do
				begin
				MAP[i,j,l].blk := 99;
				MAP[i,j,l].typ := random(4)+1;
				MAP[i,j,l].colV := random(2);
				MAP[i,j,l].isChest := false;
				MAP[i,j,l].iswalk := false;
				MAP[i,j,l].isVis := false;
				for r:=1 to 5 do
					MAP[i,j,l].C[r] := 0;
				end;
	ST := 0;
	STP := 0;
	Playing := True;
	player.x := 1;
	player.y := 1;
	player.z := 0;
	player.h := 100;
	player.l := 0;
	player.d := 0;
	player.xp := 0;
	player.Attack:=0;
	player.Armour:=0;
	XPLU := 10;
	for i:=1 to 10 do
		player.inv[i] := 0;
	SaveFile := '';
	ContinueSaveFile := '';
	end;

procedure LoadBar(x,y,c,cur,fin:integer;text:string);
var v,i:integer;	
	begin
	v := ceil((cur/fin)*10);
	setVid(x,y,c,'[');
	setVid(x+10,y,c,']');
	textout(x+12,y,c,text);
	for i := 1 to 9 do
		if i < v then
			setVid(x+i,y,c,'#')
		else
			setVid(x+i,y,c,chr(250));
	end;
	
function Sur(x,y,z,b:integer):byte;
var a:byte;	
	begin
	a := 0;
	if Between(x,y,1,1,MAXX-1,MAXY-1) then
		begin
		if MAP[x+1,y,z].blk = b then
			inc(a);
		if MAP[x-1,y,z].blk = b then
			inc(a);
		if MAP[x,y+1,z].blk = b then
			inc(a);
		if MAP[x,y-1,z].blk = b then
			inc(a);
		if MAP[x+1,y+1,z].blk = b then
			inc(a);
		if MAP[x+1,y-1,z].blk = b then
			inc(a);
		if MAP[x-1,y+1,z].blk = b then
			inc(a);
		if MAP[x-1,y-1,z].blk = b then
			inc(a);
		end;

	Sur := a;
	end;

function IsVis(b:integer):boolean;
begin
case b of
0:IsVis := true;
2:IsVis := true;
8:IsVis := true;
10:IsVis := true;
13:IsVis := true;
16:IsVis := true;
17:IsVis := true;
18:IsVis := true;
19:IsVis := true;
20:IsVis := true;
21:IsVis := true;
23:IsVis := true;
28:IsVis := true;
29:IsVis := true;
30:IsVis := true;
31:IsVis := true;
41:IsVis := true;
45:IsVis := true;
46:IsVis := true;
47..51:IsVis := true;
54:IsVis := true;
else IsVis := False;
end;
end;		
	
function Sur4(x,y,z,b:integer):byte;
var a:byte;	
	begin
	a := 0;
	if Between(x,y,1,1,MAXX-1,MAXY-1) then
		begin
		if MAP[x+1,y,z].blk = b then
			inc(a);
		if MAP[x-1,y,z].blk = b then
			inc(a);
		if MAP[x,y+1,z].blk = b then
			inc(a);
		if MAP[x,y-1,z].blk = b then
			inc(a);
		end;

	Sur4 := a;
	end;
	
function Sur4IsVis(x,y,z,b:integer):byte;
var a:byte;	
	begin
	a := 0;
	if Between(x,y,1,1,MAXX-1,MAXY-1) then
		begin
		if IsVis(MAP[x+1,y,z].blk) then
			inc(a);
		if IsVis(MAP[x-1,y,z].blk) then
			inc(a);
		if IsVis(MAP[x,y+1,z].blk) then
			inc(a);
		if IsVis(MAP[x,y-1,z].blk) then
			inc(a);
		end;

	Sur4IsVis := a;
	end;	

procedure VID(x,y,x1,y1:integer);
var ch,col:integer;
	v:boolean;
begin

if map[x,y,player.z].colV = 0 then
	v := true
else
	v := false;


col := 15;
ch := 10;

if (map[x,y,player.z].blk = 99) then
	begin
	ch := 206;
	col := 8;
	end;

if (map[x,y,player.z].blk = 0) then
	begin
	if (player.z = 0) and (v = false) then
		col := 10
	else if (player.z = 0) then
		col := 2	
	else if (player.z = 1) and (v = false) then
		col := 2
	else if (player.z = 1) then
		col := 6	
	else if (player.z = 2) and (v = false) then
		col := 6
	else if (player.z = 2) then
		col := 7		
	else if (player.z = 3) and (v = false) then
		col := 7
	else if (player.z > 3) then
		col := 8;	
	
	case map[x,y,player.z].typ of
	1:ch:=34;
	2:ch:=44;
	3:ch:=39;
	4:ch:=46;
	end;
	end;

if (map[x,y,player.z].blk = 1) then
	begin
	col := 8;
	if v then
		ch := 177
	else ch := 219;	
	end;		

if (map[x,y,player.z].blk = 2) then
	begin
	col := 1;
	if v then
		ch := 126
	else ch := 61;	
	end;		
	
	
if (map[x,y,player.z].blk <= 6) and (map[x,y,player.z].blk >= 3) then
			begin
			col := map[x,y,player.z].blk-1;
			if v then
				ch := 178
			else ch := 177;	
			end;

if (map[x,y,player.z].blk = 7) then
	begin
	ch := 79;
	col := 6;
	end;		

if (map[x,y,player.z].blk = 8) then
	begin
	if v then
		col := 8
	else
		col := 7;

	ch := 9;	
	end;		

if (map[x,y,player.z].blk = 9) then
	begin
	col := 6;
	ch := 186	
	end;
	
if (map[x,y,player.z].blk = 10) then
	begin
	col := 12;
	if v then
		ch := 126
	else ch := 61;	
	end;	
	
if (map[x,y,player.z].blk = 11) then
	begin
	col := 6;
	ch := 9;	
	end;	
	
if (map[x,y,player.z].blk = 12) then
	begin
	col := 15;
	ch := 157;	
	end;
	
if (map[x,y,player.z].blk = 13) then
	begin
	col := 6;
	ch := 203;	
	end;

if (map[x,y,player.z].blk = 14) then
	begin
	col := 8;
	if (Sur4(x,y,player.z,14) = 4) then
		ch := 206
	else if Between(x,y,1,1,MAXX-1,MAXY-1) and (GetB(x+1,y) = 14) and (GetB(x-1,y) = 14) then
		ch := 205
	else if Between(x,y,1,1,MAXX-1,MAXY-1) and (GetB(x,y-1) = 14) and (GetB(x,y+1) = 14) then
		ch := 186
	else
		ch := 79;
	end;

if (map[x,y,player.z].blk = 15) then
	begin
	col := 7;
	ch := 186	
	end;
	
if (map[x,y,player.z].blk = 16) then
	begin
	col := 6;
	ch := 125;	
	end;	
	
if (map[x,y,player.z].blk = 17) then
	begin
	col := 7;
	ch := 222;	
	end;	
	
if (map[x,y,player.z].blk = 18) then
	begin
	col := 7;
	ch := 15;	
	end;		

if (map[x,y,player.z].blk = 19) then
	begin
	col := 6;
	ch := 47;	
	end;	
	
if (map[x,y,player.z].blk = 20) then
	begin
	col := 6;
	ch := 37;	
	end;

if (map[x,y,player.z].blk = 21) then
	begin
	if v then
		col := 10
	else col := 2;	
	ch := 155;	
	end;	

if (map[x,y,player.z].blk = 22) then
	begin
	col := 124;
	ch := 42;	
	end;

if (map[x,y,player.z].blk = 23) then
	begin
	col := 6;
	ch := 220;	
	end;	
	
if (map[x,y,player.z].blk = 24) then
	begin
	col := 6;
	if (Sur4(x,y,player.z,14) = 4) then
		ch := 206
	else if Between(x,y,1,1,MAXX-1,MAXY-1) and (GetB(x+1,y) = 14) and (GetB(x-1,y) = 14) then
		ch := 205
	else if Between(x,y,1,1,MAXX-1,MAXY-1) and (GetB(x,y-1) = 14) and (GetB(x,y+1) = 14) then
		ch := 186
	else
		ch := 79;
	end;

if (map[x,y,player.z].blk = 26) then
	begin
	col := 8;
	ch := 220;	
	end;		
	
if (map[x,y,player.z].blk = 28) then
	begin
	col := 12;
	ch := 155;	
	end;	

if (map[x,y,player.z].blk = 29) then
	begin
	col := 12;
	ch := 155;	
	end;	

if (map[x,y,player.z].blk = 30) then
	begin
	if v then
		col := 2
	else
		col := 10;
	
	if map[x,y,player.z].typ >= 2 then
		ch := 5
	else
		ch := 6;
	end;		
	

if (map[x,y,player.z].blk = 31) then
	begin
	if v then
		col := 2
	else
		col := 10;
	ch := 37;
	end;		

if (map[x,y,player.z].blk = 32) then
	begin
	col := 6;
	ch := 31;
	end;	
	
if (map[x,y,player.z].blk = 33) then
	begin
	col := 6;
	ch := 30;
	end;	

if (map[x,y,player.z].blk = 34) then
	begin
	col := 6;
	ch := 158;
	end;		

if (map[x,y,player.z].blk = 35) then
	begin
	case random(4) of
		0:col := 4;
	    1:col := 12;
		2:col := 14;
		3:col := 15;
	end;
	ch := 215;
	end;		
	
if (map[x,y,player.z].blk = 36) then
	begin
	col := 3;
	ch := 125;
	end;	

if (map[x,y,player.z].blk = 37) then
	begin
	col := 15;
	ch := 126;
	end;		

if (map[x,y,player.z].blk = 38) then
	begin
	col := 96;
	ch := 197;
	end;
	
if (map[x,y,player.z].blk = 39) then
	begin
	col := 128;
	ch := 197;
	end;

if (map[x,y,player.z].blk = 40) then
	begin
	col := 6;
	ch := 189;
	end;

if (map[x,y,player.z].blk = 41) then
	begin
	col := 8;
	ch := 94;
	end;
	
if (map[x,y,player.z].blk = 45) then
	begin
	if v then
		col := 11
	else col := 15;
	if random(2) = 0 then
		ch := 126
	else ch := 61;	
	end;	

if (map[x,y,player.z].blk = 46) then
	begin
	if v then
		col := 4
	else col := 12;
	if random(2) = 0 then
		ch := 126
	else ch := 61;	
	end;	

if (map[x,y,player.z].blk = 42) then
	begin
	col := 8;
	ch := 118;
	end;
	
if (map[x,y,player.z].blk = 47) then
	begin
	case random(4) of
		0:col := 4;
	    1:col := 12;
		2:col := 14;
		3:col := 15;
	end;
	case random(3) of
		0:ch := 176;
	    1:ch := 177;
		2:ch := 178;
	end;
	end;	
	
if (map[x,y,player.z].blk = 48) then
	begin
	col := 8;
	ch := 159;
	end;

if (map[x,y,player.z].blk = 49) then
	begin
	col := 7;
	ch := 208;
	end;
	
if (map[x,y,player.z].blk = 50) then
	begin
	if v then
		col := 2
	else col := 10;
	ch := 215;
	end;
	
if (map[x,y,player.z].blk = 51) then
	begin
	col := 6;
	ch := 215;
	end;
	
if (map[x,y,player.z].blk = 52) then
	begin
	col := 14;
	if v then
		ch := 177
	else ch := 176;	
	end;		

if (map[x,y,player.z].blk = 53) then
	begin
	col := 15;
	ch := 220;
	end;
	
if (map[x,y,player.z].blk = 54) then
	begin
	col := 15;
	if (Sur4(x,y,player.z,14) = 4) then
		ch := 197
	else if Between(x,y,1,1,MAXX-1,MAXY-1) and (GetB(x+1,y) = 14) and (GetB(x-1,y) = 14) then
		ch := 196
	else if Between(x,y,1,1,MAXX-1,MAXY-1) and (GetB(x,y-1) = 14) and (GetB(x,y+1) = 14) then
		ch := 179
	else
		ch := 79;
	end;	
	
	
	
setVid(x1,y1,col,chr(ch));	

end;
	
procedure TimeDraw;
var b,col:integer;	
	begin
	if H <= 10 then
		createrect(20,41,24,44,11,chr(219),TRUE)
	else
		createrect(20,41,24,44,1,chr(219),TRUE);
	
	if H > 10 then
		b := H - 10
	else
		b := H;
		
	if H > 10 then
		col := 23
	else
		col := 190;
		
	case b of
	0..1:setVid(20,43,col,chr(7));
	2..3:setVid(21,42,col,chr(7));
	4..5:setVid(22,41,col,chr(7));
	6..7:setVid(23,42,col,chr(7));
	8..9:setVid(24,43,col,chr(7));
	end;
	end;
	
procedure rayCast(x1,y1,Dis:integer);
var Nodes:array[1..MAXR] of TRNode;
	Done:boolean;
	i,lif:integer;
	x,y,k:real;
	begin
	MAP[x1,y1,Player.z].isVis := True;
	
	k := ((PI*2)/(MAXR));
	for i := 1 to MAXR do
		begin
			Nodes[i].Hit := False;
			Nodes[i].Life := Dis;
			Nodes[i].Pos.x := x1;
			Nodes[i].Pos.y := y1;
			Nodes[i].Vec.x := cos((i*k));
			Nodes[i].Vec.y := sin((i*k));
			{case i of
				MAXR-1:begin
				Nodes[i].Vec.x := 0;
				Nodes[i].Vec.y := 1;
				end;
				MAXR-2:begin
				Nodes[i].Vec.x := 1;
				Nodes[i].Vec.y := 0;
				end;
				MAXR-3:begin
				Nodes[i].Vec.x := 0;
				Nodes[i].Vec.y := -1;
				end;
				MAXR-4:begin
				Nodes[i].Vec.x := -1;
				Nodes[i].Vec.y := 0;
				end;
			end;}
		end;
	Done := False;
	while not Done do
		begin
		Done := True;
		for i := 1 to MAXR do
			if Nodes[i].Hit = False then
				begin					
				x := Nodes[i].Pos.x+Nodes[i].Vec.x;
				y := Nodes[i].Pos.y+Nodes[i].Vec.y;
				if Between(round(x),round(y),0,0,MAXX,MAXY) then
					begin
					Done := False;
					lif := Nodes[i].Life;
					if (Nodes[i].Life > 1) then
						dec(Nodes[i].Life)
					else
						Nodes[i].Hit:=TRUE;
						
					if (MAP[round(x),round(y),Player.z].iswalk) or IsVis(MAP[round(x),round(y),Player.z].blk) then
						MAP[round(x),round(y),Player.z].isVis := True
					else	
						begin
						Nodes[i].Hit:=TRUE;
						MAP[round(x),round(y),Player.z].isVis := True;
						end;
					if not Nodes[i].Hit then
						begin
							Nodes[i].Pos.x := x;
							Nodes[i].Pos.y := y;
						end;
						
						
					end;
				end
			else
				Nodes[i].Hit:=TRUE;
		end;
	end;
	
	
{VVV ITS THIS ONE YOU IDIOT VVV}	
	
procedure redraw;
var i,j,x,y:integer;
	c:char;
	B,B1,B2,B3:boolean;
	tmp:Enemy;
	s:string;
begin
for i:=-SCRW to SCRW do
	for j:=-SCRH to SCRH do
		if Between((i+player.x),(j+player.y),0,0,MAXX,MAXY) then
			MAP[(i+player.x),(j+player.y),Player.z].isVis := False;
		
for i:=-SCRW to SCRW do
	for j:=-SCRH to SCRH do
		if Between((i+player.x),(j+player.y),0,0,MAXX,MAXY) and (MAP[(i+player.x),(j+player.y),player.z].blk = 35) then
			rayCast((i+player.x),(j+player.y),7);
rayCast(player.x,player.y,VD);



for i:=-SCRW to SCRW do
	for j:=-SCRH to SCRH do
		begin
		B := (Between((i+player.x),(j+player.y),0,0,MAXX,MAXY) and (Sur4((i+player.x),(j+player.y),player.z,0) <> 0));
		B1 := (Between((i+player.x),(j+player.y),0,0,MAXX,MAXY) and not Between((i+player.x),(j+player.y),1,1,MAXX-1,MAXY-1));
		B2 := (Between((i+player.x),(j+player.y),0,0,MAXX,MAXY) and IsVis(map[(i+player.x),(j+player.y),player.z].blk));
		B3 := (Between((i+player.x),(j+player.y),0,0,MAXX,MAXY) and (Sur4IsVis((i+player.x),(j+player.y),player.z,0) <> 0));
		if ((B or B1 or B2 or B3) and (H <= 10)) and (Player.z = 0) then
			VID(i+player.x,j+player.y,i+SCRW,j+SCRH)
		else if (B or B1 or B2 or B3) and ((H > 10) or (Player.z > 0)) and (MAP[(i+player.x),(j+player.y),player.z].isVis) then
			VID(i+player.x,j+player.y,i+SCRW,j+SCRH)
		else
			setVid(i+SCRW,j+SCRH,0,chr(0));
		end;
		
if Head <> nil then
		begin
		tmp := Head;
		while tmp <> nil do
			begin
			x:=tmp^.x;
			y:=tmp^.y;
			if Between(x,y,-SCRW+player.x,-SCRH+player.y,SCRW+player.x,SCRH+player.y) and (MAP[(x),(y),player.z].isVis) then
				begin
				x:=player.x-x;
				y:=player.y-y;
				case tmp^.t of
				0:c:='H';
				1:c:='W';
				2:c:='D';
				3:c:='O';
				4:c:='T';
				5:c:='Z';
				end;
				setVid(SCRW-x,SCRH-y,12,c);
				end;
			tmp := tmp^.next;
			end;
		end;
		
		
createline(1,40,ScreenW,40,0,' ');
s := '';
for i:=1 to 5 do
	s := s + ' '+inttostr(i)+':'+itemlist(player.inv[i]);
textout(1,40,15,s);
LoadBar(1,41,12,Player.h,100,'Health');
LoadBar(1,42,14,Player.xp,XPLU,'XP');
textout(1,43,15,'Level '+inttostr(Player.l));
TimeDraw;

case player.d of
0:setVid(26,42,11,chr(30));
1:setVid(26,42,11,chr(31));
2:setVid(26,42,11,chr(17));
3:setVid(26,42,11,chr(16));
end;


setVid(SCRW,SCRH,11,chr(1));
update(false);
end;	

procedure CullMessages;
var i:integer;	
	begin
	for i:=0 to MAXM do
		if MDisp[i].A = true then
			if MDisp[i].Delay > 0 then
				dec(MDisp[i].Delay)
			else
				begin
				MDisp[i].A := False;
				redraw;
				end;
	end;
	
procedure EnemyHandle;
var tmp,tmp1:Enemy;
	Re:boolean;
	Spawnable,i,x,y,asp:integer;
	begin
	Re := FALSE;
	tmp := Head;
	if Head <> nil then
		begin
		while tmp <> nil do
			begin
			if (tmp^.h <= 0) or (Dist(tmp^.x,tmp^.y,player.x,player.y) >= 40) then
				begin
				tmp1 := tmp^.next;
				if (GetB(tmp^.x,tmp^.y) = 0) and (random(20) = 0) then
					SetBlock(tmp^.x,tmp^.y,player.z,41);
				if (tmp^.h <= 0) then
					AddMessage(EnemyName(tmp^.t)+' was Killed',3,12);
				DeleteMem(tmp);
				tmp := tmp1;
				Re := TRUE;
				end
			else
				tmp := tmp^.next;
			end;
		end;
	Spawnable:=MAXE-ENEMYCOUNT;
	if Spawnable > 0 then
		begin
		for i:= 0 to Spawnable do
			begin
			x:=player.x+(random(61)-40);
			y:=player.y+(random(61)-40);
			if Between(x,y,1,1,MAXX-1,MAXY-1) and (Dist(x,y,player.x,player.y) > 10) and (Dist(x,y,player.x,player.y) <= 30) and (MAP[x,y,player.z].blk = 0) and (MAP[x,y,player.z].isVis = FALSE) then
				begin
				InsertMem(x,y,random(6));
				Re := TRUE;
				end;
			end;
		end;
	if Re then
		redraw;
	end;	
	
procedure GEN;
var i,j,l,r,r1,g:integer;
	C : array[0..MAXX,0..MAXY,0..MAXZ] of Tvoxel;
	begin
	for i := 1 to MAXX-1 do
		for j := 1 to MAXY-1 do
			for l:=0 to MAXZ do
				begin
				MAP[i,j,l].blk := random(2);
				MAP[i,j,l].typ := random(4)+1;
				MAP[i,j,l].colV := random(2);
				for r:=1 to 5 do
					MAP[i,j,l].C[r] := 0;
				end;
	C := MAP;			
	for r := 1 to GS do
		begin
		for i := 1 to MAXX-1 do
			for j := 1 to MAXY-1 do
				for l := 0 to MAXZ do
					begin
					
					if l = 0 then
						begin
						if ((MAP[i,j,l].blk = 0) and (Sur(i,j,l,0) >= 3)) or ((MAP[i,j,l].blk = 1) and (Sur(i,j,l,0) >= 5)) then
							C[i,j,l].blk := 0
						else
							C[i,j,l].blk := 1;
						end
					else
						begin
						if ((MAP[i,j,l].blk = 0) and (Sur(i,j,l,0) >= 4)) or ((MAP[i,j,l].blk = 1) and (Sur(i,j,l,0) >= 5)) then
							C[i,j,l].blk := 0
						else
							C[i,j,l].blk := 1;
						end;
					end;
		LoadBar(1,1,15,r,GS,'LOADING MAP...');
		update(true);
		MAP := C;
		end;
	C := MAP;	
	for i := 0 to MAXX do
		for j := 0 to MAXY do
			if (random(50) = 1) and (Sur4(i,j,0,0) <> 0) and (MAP[i,j,0].blk = 1) then
				MAP[i,j,0].blk := 2;
				
	for r := 1 to WS do
		begin
		for i := 0 to MAXX do
			for j := 0 to MAXY do
				if (MAP[i,j,0].blk = 0) and (Sur4(i,j,0,2) <> 0) and (random(3) = 0) then
					C[i,j,0].blk := 2;
		LoadBar(1,2,11,r,WS,'ADDING WATER...');
		update(true);
		MAP := C;
		end;
	
	C := MAP;	
	for l := 40 to MAXZ do
		for i := 0 to MAXX do
			for j := 0 to MAXY do
				if (random(50) = 1) and (Sur4(i,j,l,0) <> 0) and (MAP[i,j,l].blk = 1) then
					MAP[i,j,l].blk := 10;
				
	for r := 1 to LS do
		begin
		for l := 40 to MAXZ do
			for i := 0 to MAXX do
				for j := 0 to MAXY do
					if (MAP[i,j,l].blk = 0) and (Sur4(i,j,l,10) <> 0) and (random(5) = 1) then
						C[i,j,l].blk := 10;
		LoadBar(1,2,11,r,WS,'ADDING LAVA...');
		update(true);
		MAP := C;
		end;
	
	
	
	
	
	
	C := MAP;
	for g := 0 to OG do
	begin
		for i := 1 to MAXX-1 do
			for j := 1 to MAXY-1 do
				for l := 0 to MAXZ do
					if (MAP[i,j,l].blk = 1) then
						begin
							r := random(10)+1;
							if Sur4(i,j,l,r) <> 0 then
								r1 := random(10)+1
							else
								r1 := random(100)+1;
							case r of
							1:if (l >= 0) and (r1 <= 4) then C[i,j,l].blk:=3;
							2:if (l >= 13) and (r1 <= 4) then C[i,j,l].blk:=4;
							3:if (l >= 20) and (r1 <= 4) then C[i,j,l].blk:=5;
							4:if (l >= 40) and (r1 <= 4) then C[i,j,l].blk:=6;
							5:if (l >= 0) and (r1 <= 5) then C[i,j,l].blk:=52;
							end;
						end;
		LoadBar(1,3,13,g,OG,'ADDING ORES...');
		update(true);
		MAP := C;
	end;
	

	

	
	for i := 0 to MAXX do
		for j := 0 to MAXY do
			if (random(50) = 0) and (Sur(i,j,0,1) = 0) and (MAP[i,j,0].blk = 0) then
				MAP[i,j,0].blk := 7;
	
	for i := 0 to MAXX do
		for j := 0 to MAXY do
			if (random(100) = 0) and (Sur4(i,j,0,1) = 0) and (MAP[i,j,0].blk = 0) then
				MAP[i,j,0].blk := 20;
				
	for i := 0 to MAXX do
		for j := 0 to MAXY do
			if (random(10) = 0) and (Sur4(i,j,0,2) > 0) and (MAP[i,j,0].blk = 0) then
				MAP[i,j,0].blk := 51;
	
	for l := 1 to MAXZ do
		begin
		for i := 0 to MAXX do
			for j := 0 to MAXY do
				if (random(50) = 1) and (MAP[i,j,l].blk = 0) then
					MAP[i,j,l].blk := 8;
		end;
	
	
		
	r:=0;	
	
	while r = 0 do
		begin
		i := random(MAXX);
		j := random(MAXY);
		if (MAP[i,j,0].blk = 0) then
				begin
				r := 1;
				player.x := i;
				player.y := j;
				end
		end;
	
	
	
	
	
	for l := 0 to MAXZ do
		for i := 0 to MAXX do
			for j := 0 to MAXY do
				begin
				if (MAP[i,j,l].blk = 0) then
					MAP[i,j,l].iswalk := true;
				if (MAP[i,j,l].blk = 2) then
					MAP[i,j,l].iswalk := true;
				if (MAP[i,j,l].blk = 9) then
					MAP[i,j,l].iswalk := true;
				if (MAP[i,j,l].blk = 10) then
					MAP[i,j,l].iswalk := true;
				end;
				
	player.spx := player.x;			
	player.spy := player.y;					
	player.spz := player.z;						
				
				
	redraw;
	end;
	
function CheckWalk(x,y:integer):integer;	
begin
if Between(player.x+x,player.y+y,0,0,MAXX,MAXY) then
	CheckWalk := map[player.x+x,player.y+y,player.z].blk;
end;

function CheckE(x,y:integer):boolean;
var tmp:Enemy;
    Hit:boolean;
	begin
	Hit := false;
	tmp := Head;
	if Head <> nil then
		begin
		while tmp <> nil do
			begin
			if (tmp^.x = player.x+x) and (tmp^.y = player.y+y) then
				Hit := true;
			tmp := tmp^.next;
			end;
		end;
	CheckE := Hit;
	end;	

function CheckM(x,y:integer):boolean;	
var i,j,b:integer;
begin
i := player.x+x;
j := player.y+y;
if map[i,j,player.z].blk = 8 then
	begin
	b := GetB(i+x,j+y);
	if (b = 0) then
		begin
		SetB(x,y,0);
		SetB(x+x,y+y,8);
		CheckM := true;
		end
	else
		CheckM := false;
	
	end;
end;

function CheckD(x,y:integer):boolean;	
var i,j,b:integer;
begin
i := player.x+x;
j := player.y+y;
if Between(i,j,1,1,MAXX-1,MAXY-1) then
	begin	
		if map[i,j,player.z].iswalk or DEBUG then
			CheckD := true
		else
			CheckD := false;
	end
else
	CheckD := false;
end;

procedure tree;
var x,y,i,j,d,trys:integer;
begin
d := random(5)+2;
trys := 0;
x := Player.x;
y := player.y;
while (d > 0) and (trys <= 3) do
	begin
	i := (random(3)-1);
	j := (random(3)-1);
	if Between(i+player.x,j+player.y,1,1,MAXX-1,MAXY-1) and (map[i+player.x,j+player.y,player.z].blk = 0) then
		begin
		if random(5) >= 2 then
			case player.d of
				0:if GetB(i+x,-1+j+y) = 0 then SetB(0+i,-1+j,11);
				1:if GetB(i+x,1+j+y) = 0 then SetB(0+i,1+j,11);
				2:if GetB(-1+i+x,j+y) = 0 then SetB(-1+i,0+j,11);
				3:if GetB(1+i+x,j+y) = 0 then SetB(1+i,0+j,11);
			end
		else
			case player.d of
				0:if GetB(i+x,-1+j+y) = 0 then SetB(0+i,-1+j,19);
				1:if GetB(i+x,1+j+y) = 0 then SetB(0+i,1+j,19);
				2:if GetB(-1+i+x,j+y) = 0 then SetB(-1+i,0+j,19);
				3:if GetB(1+i+x,j+y) = 0 then SetB(1+i,0+j,19);
			end;
		dec(d);
		end
	else
		inc(trys);
	end;
	
case player.d of
0:SetB(0,-1,12);
1:SetB(0,1,12);
2:SetB(-1,0,12);
3:SetB(1,0,12);
end;
end;
	
procedure bush;
var x,y,i,j,d,trys:integer;
begin
d := random(5)+2;
trys := 0;
x := Player.x;
y := player.y;
while (d > 0) and (trys <= 3) do
	begin
	i := (random(3)-1);
	j := (random(3)-1);
	if Between(i+x,j+y,1,1,MAXX-1,MAXY-1) and (map[i+x,j+y,player.z].blk = 0) then
		begin
		case player.d of
		0:if GetB(i+x,-1+j+y) = 0 then SetB(0+i,-1+j,19);
		1:if GetB(i+x,1+j+y) = 0 then SetB(0+i,1+j,19);
		2:if GetB(-1+i+x,j+y) = 0 then SetB(-1+i,0+j,19);
		3:if GetB(1+i+x,j+y) = 0 then SetB(1+i,0+j,19);
		end;
		dec(d);
		end
	else
		inc(trys);
	end;
	
case player.d of
0:SetB(0,-1,21);
1:SetB(0,1,21);
2:SetB(-1,0,21);
3:SetB(1,0,21);
end;
end;	

procedure flax;
var x,y,i,j,d,trys:integer;
begin
d := random(5)+2;
trys := 0;
x := Player.x;
y := player.y;
while (d > 0) and (trys <= 3) do
	begin
	i := (random(3)-1);
	j := (random(3)-1);
	if Between(i+x,j+y,1,1,MAXX-1,MAXY-1) and ((map[i+x,j+y,player.z].blk = 0) or (map[i+x,j+y,player.z].blk = 45)) then
		begin
		case player.d of
		0:if (GetB(i+x,-1+j+y) = 0) or (GetB(i+x,-1+j+y) = 45) then SetB(0+i,-1+j,48);
		1:if (GetB(i+x,1+j+y) = 0) or (GetB(i+x,1+j+y) = 45) then SetB(0+i,1+j,48);
		2:if (GetB(-1+i+x,j+y) = 0) or (GetB(-1+i+x,j+y) = 45) then SetB(-1+i,0+j,48);
		3:if (GetB(1+i+x,j+y) = 0) or (GetB(1+i+x,j+y) = 45) then SetB(1+i,0+j,48);
		end;
		dec(d);
		end
	else
		inc(trys);
	end;
	
case player.d of
0:SetB(0,-1,49);
1:SetB(0,1,49);
2:SetB(-1,0,49);
3:SetB(1,0,49);
end;
end;	

procedure Bed;
var M,i:integer;
	ch:char;
	Key:TKeyEvent;
	E:boolean;
begin
unlockupdate;
CreateBox(29,17,52,21,15,chr(79),chr(205),chr(186));
TextOut(30,18,2,'Exit');
TextOut(30,19,7,'Sleep');
TextOut(30,20,7,'PickUp');
update(true);
E:=False;
M:=0;
repeat
if keypressed then
	begin
	Key :=  GetKeyEvent;
	Key :=  TranslatekeyEvent(Key);
	ch := GetKeyEventChar(Key);
	case ch of
	's':if M < 3 then inc(M);
	'w':if M > 0 then dec(M);
	#27:E:=True;
	#13:begin
			case M of
			0:E:=True;
			1:if (H >= 11) then begin H := 0; player.spx := player.x; player.spy := player.y; player.spz := player.z; E := TRUE; end else begin E := TRUE; AddMessage('You can only sleep at night',3,15); end;
			2:begin 
				i := InvCheck(0);
				if i <> 11 then
					begin
						player.Inv[i] := 55;
						case player.d of
						0:SetB(0,-1,0);
						1:SetB(0,1,0);
						2:SetB(-1,0,0);
						3:SetB(1,0,0);
						end;
						E := true;
					end;
			  end;
			end;
		end;
	end;
	CreateBox(29,17,52,21,15,chr(79),chr(205),chr(186));
	TextOut(30,18,7,'Exit');
	TextOut(30,19,7,'Sleep');
	TextOut(30,20,7,'PickUp');
	
	case M of
	0:TextOut(30,18,2,'Exit');
	1:TextOut(30,19,2,'Sleep');
	2:TextOut(30,20,2,'PickUp');
	end;
	update(true);
	end;
until E or not (Playing);
lockupdate;
end;	


function GetChest(x,y,z,b:integer):integer;
	begin
	GetChest := MAP[x,y,z].C[b];
	end;
	
procedure SetChest(x,y,z,b,c:integer);
	begin
	MAP[x,y,z].C[b] := c;
	end;	
	
function CheckEmpty(x,y,z:integer):boolean;
var i:integer;	
	begin
	CheckEmpty := true;
	for i:=1 to 5 do
		if GetChest(x,y,z,i) <> 0 then
			begin
			CheckEmpty := false;
			break;
			end;
	end;
	
function CheckFull(x,y,z:integer):boolean;
var i:integer;	
	begin
	CheckFull := true;
	for i:=1 to 5 do
		if GetChest(x,y,z,i) = 0 then
			begin
			CheckFull := false;
			break;
			end;
	end;
	
procedure Chest(x1,y1:integer);
var M,i,j,v,x,y,z:integer;
	ch:char;
	Key:TKeyEvent;
	E:boolean;
begin
x := player.x + x1;
y := player.y + y1;
z := player.z;
unlockupdate;
BoxHelper(29,17,23,9,15);
TextOut(30,18,2,'Exit');
TextOut(30,19,7,'PickUp');
for i:=1 to 5 do
	begin
	TextOut(30,19+i,7,inttostr(i)+':'+itemlist(GetChest(x,y,player.z,i)));
	end;

update(true);
E:=False;
M:=0;
repeat
if keypressed then
	begin
	Key :=  GetKeyEvent;
	Key :=  TranslatekeyEvent(Key);
	ch := GetKeyEventChar(Key);
	case ch of
	's':if M < 6 then inc(M);
	'w':if M > 0 then dec(M);
	#27:E:=True;
	#13:begin
			case M of
			0:E:=True;
			1:if CheckEmpty(x,y,z) and (InvCheck(0) <> 11) then begin SetBlock(x,y,z,0); player.Inv[InvCheck(0)] := 34; E:=TRUE; end else begin E := TRUE; AddMessage('You Cannot Remove Filled Chests!',4,15); end;
			else begin
					if GetChest(x,y,z,M-1) = 0 then
						begin
							if CheckFull(x,y,z) = false then
								begin
									for i:=1 to 10 do
										begin
										j := 0;
										if player.Inv[i] <> 0 then
											begin
											j := player.Inv[i];
											player.Inv[i] := 0;
											break;
											end;
										end;
									if j <> 0 then
										SetChest(x,y,z,M-1,j);
								end;
						end
					else
						begin
						if InvCheck(0) <> 11 then
							begin
							j := GetChest(x,y,z,M-1);
							SetChest(x,y,z,M-1,0);
							player.Inv[InvCheck(0)] := j;
							end;
						end;
						
				 end;
			end;
		end;
	end;
	BoxHelper(29,17,23,9,15);
	TextOut(30,18,7,'Exit');
	TextOut(30,19,7,'PickUp');
	for i:=1 to 5 do
		begin
		TextOut(30,19+i,7,inttostr(i)+':'+itemlist(GetChest(x,y,z,i)));
		end;
		
	case M of
	0:TextOut(30,18,2,'Exit');
	1:TextOut(30,19,2,'PickUp');
	else begin
			for i:=1 to 5 do
				begin
					if (M = (i+1)) then
						TextOut(30,19+i,2,inttostr(i)+':'+itemlist(GetChest(x,y,z,i)))
					else
						TextOut(30,19+i,7,inttostr(i)+':'+itemlist(GetChest(x,y,z,i)));
				end;	
		 end;
	end;
	update(true);
	end;
until E or not (Playing);
lockupdate;
end;	

procedure invt;
var i,b:integer;
	byp:boolean;
begin

case player.d of
0:b := CheckWalk(0,-1);
1:b := CheckWalk(0,1);
2:b := CheckWalk(-1,0);
3:b := CheckWalk(1,0);
end;


TORCHLIT := FALSE;
for i:= 1 to 10 do
	begin
	if player.inv[i] = 35 then
		TORCHLIT := TRUE;
	if player.inv[i] = 0 then
		begin
		byp := false;
		case b of
		7:begin tree; player.inv[i] := 11; byp := true;end;
		20:begin bush; player.inv[i] := 19; byp := true;end;
		
		2:begin if (InvCheck(42) <> 11) then 
						begin 
							player.inv[InvCheck(42)] := 43; 
							case player.d of
							0:SetB(0,-1,0);
							1:SetB(0,1,0);
							2:SetB(-1,0,0);
							3:SetB(1,0,0);
							end;
						end; 
						byp := true; 
					end;
		10:begin if (InvCheck(42) <> 11) then 
						begin 
							player.inv[InvCheck(42)] := 44; 
							case player.d of
							0:SetB(0,-1,0);
							1:SetB(0,1,0);
							2:SetB(-1,0,0);
							3:SetB(1,0,0);
							end;
						end; 
						byp := true; 
					end;
		30:begin byp := true; end;
		31:begin byp := true; end;
		32:begin byp := true;
				 player.inv[i] := 32; 			
				 case player.d of
					0:begin SetB(0,-1,0); SetZ(0,-1,1,0); end;
					1:begin SetB(0,1,0); SetZ(0,1,1,0); end;
					2:begin SetB(-1,0,0); SetZ(-1,0,1,0); end;
					3:begin SetB(1,0,0); SetZ(1,0,1,0); end;
			     end;
			end;
		33:begin byp := true; end;
		34:begin 
				case player.d of
				0:Chest(0,-1);
				1:Chest(0,1);
				2:Chest(-1,0);
				3:Chest(1,0);
				end;
				byp := true; 
			end;
		45:byp := true;
		46:byp := true;
		47:byp := true;
		51:begin Flax; player.inv[i] := 48; byp := true;end;
		50:byp := true;
		55:begin Bed; byp := true; end;
		99:begin byp := true; end;
		end;
		
		if not byp then
			begin
			player.inv[i] := b;
			if (b >= 3) and (b <= 6) or (b = 1) then
				begin
				inc(Player.xp);
				if (Player.xp = XPLU) and (Player.l <> 255) then
					begin
					XPLU := XPLU + 20;
					Player.xp := 0;
					inc(player.l);
					AddMessage('Level UP! You are now Level '+inttostr(player.l),5,14);
					end;
				end;
			case player.d of
			0:SetB(0,-1,0);
			1:SetB(0,1,0);
			2:SetB(-1,0,0);
			3:SetB(1,0,0);
			end;
			end;
		break;
		end;
	
	
	end;
end;

procedure drop;
var i,b:integer;
	Droppable:boolean;
begin
for i:= 1 to 10 do
	begin
	if player.inv[i] = 35 then
		TORCHLIT := TRUE;
	if (player.inv[i] <> 0) then
		begin
		b := player.inv[i];
		case b of
		34:begin
			SetBlock(player.x,player.y,player.z,34);
			player.inv[i] := 0;
			Droppable := false;
		   end;
		32:if (player.z <> MAXZ-1) and (map[player.x,player.y,player.z+1].blk = 0) then
			begin
			SetBlock(player.x,player.y,player.z,32);
			SetBlock(player.x,player.y,player.z+1,33);
			player.inv[i] := 0;
			Droppable := false;
			end;
		43:if (GetB(player.x,player.y) = 0) then begin player.inv[i] := 42; SetBlock(player.x,player.y,player.z,2); Droppable := false; end;
		44:if (GetB(player.x,player.y) = 0) then begin player.inv[i] := 42; SetBlock(player.x,player.y,player.z,10); Droppable := false; end;
		49:begin if ((GetB(player.x,player.y) = 0) or (GetB(player.x,player.y) = 45)) and ((Sur4(player.x,player.y,0,2) > 0) or (Sur4(player.x,player.y,0,45) > 0)) then begin SetB(0,0,50); player.inv[i] := 0; break; end; Droppable := false; end;
		100:Droppable := false;
		101:Droppable := false;
		else Droppable := true;
		end;
		
		if Droppable and (map[player.x,player.y,player.z].blk = 0) then
			begin
				player.inv[i] := 0;
				case b of
				12:begin SetB(0,0,30); break; end;
				21:begin SetB(0,0,31); break; end;
				end;
				SetB(0,0,b);
				break;
			end;
		end;
	end;
end;

function Ycheck(x,y:integer):boolean;
begin
case map[x,y,player.z].blk of
32:if player.z <> MAXZ then begin player.z := player.z + 1; DumpMem; Ycheck:=TRUE; end;
33:if player.z <> 0 then begin player.z := player.z - 1; DumpMem; Ycheck:=TRUE; end;
else Ycheck:=FALSE;
end;
end;

procedure PrintItemList;
var Key:TKeyEvent;
	i:integer;
begin
CreateBox(1,1,ScreenW,ScreenH,15,chr(79),chr(205),chr(186));
update(true);
while not keypressed do
	begin
	for i := 0 to 43 do
		TextOut(2,1+i,15,itemlist(i));
	update(true);
	end;
Key :=  GetKeyEvent;
CreateBox(1,1,ScreenW,ScreenH,0,' ',' ',' ');
redraw;
end;
	
procedure PrintHelp;
var Key:TKeyEvent;
	begin
	CreateBox(29,17,52,24,15,chr(79),chr(205),chr(186));
	textout(30,18,15,'E = pick-up');
	textout(30,19,15,'Q = Place');
	textout(30,20,15,'I = Inv');
	textout(30,21,15,'Esc = menu');
	textout(30,22,15,'(W,A,S,D) keys to move');
	update(true);
	while not keypressed do
		begin
		end;
	Key :=  GetKeyEvent;
	end;

function nam:string;
const tc = 	'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-,.?';
var x,y,x1,y1:integer;
	ch:char;
	Key:TKeyEvent;
	fil1:string;
	E:boolean;
begin
y1 := 7;
x1 := 26;
fil1 := SaveFile;
createrect(1,1,ScreenW,ScreenH,0,'#',true);
createrect(25,6,55,21,14,chr(15),false);
setvid(x1,y1,11,'X');
createrect(29,8,50,10,0,chr(15),true);
createrect(29,8,50,10,14,chr(15),false);
createrect(28,12,51,16,14,chr(15),false);

textout(30,9,15,fil1);

textout(29,13,15,'ABCDEFGHIJKLMNOPQRSTUV');
textout(29,14,15,'WXYZabcdefghijklmnopqr');
textout(29,15,15,'stuvwxyz1234567890-,.?');

setvid(29,19,15,'<');
setvid(34,19,15,']');
textout(30,19,10,'BACK');

setvid(36,19,15,'[');
setvid(42,19,15,']');
textout(37,19,12,'CLEAR');

setvid(44,19,15,'[');
setvid(50,19,15,']');
textout(45,19,14,'ENTER');
update(true);
E:=false;
repeat
if keypressed then
	begin
	setvid(x1,y1,0,chr(32));
	Key :=  GetKeyEvent;
	Key :=  TranslatekeyEvent(Key);
	ch := GetKeyEventChar(Key);
		begin
			if (ch = 'w') and (y1-1 > 6) then dec(y1);
			if (ch = 's') and (y1+1 < 21) then inc(y1);
			if (ch = 'a') and (x1-1 > 25) then dec(x1);
			if (ch = 'd') and (x1+1 < 55) then inc(x1);
			if (ch = #13) then begin
								if Between(x1,y1,29,13,50,15) then
									begin
									x := x1-28;
									y := y1-13;
									if length(fil1) < 20 then
										fil1 := fil1 + tc[x+(y*22)]
									end;
								if Between(x1,y1,36,19,42,19) then
									fil1 := '';
								if Between(x1,y1,29,19,34,19) then
									if fil1 <> '' then
										Delete (fil1,length(fil1),length(fil1));
								if Between(x1,y1,44,19,50,19) then
									begin
									E := true;
									nam:=fil1;
									end;	
							end;
		end;
	createrect(29,8,50,10,0,chr(15),true);
	createrect(29,8,50,10,14,chr(15),false);
	createrect(28,12,51,16,14,chr(15),false);
	
	textout(30,9,15,fil1);
	
	textout(29,13,15,'ABCDEFGHIJKLMNOPQRSTUV');
	textout(29,14,15,'WXYZabcdefghijklmnopqr');
	textout(29,15,15,'stuvwxyz1234567890-,.?');
	
	setvid(29,19,15,'<');
	setvid(34,19,15,']');
	textout(30,19,10,'BACK');
	
	setvid(36,19,15,'[');
	setvid(42,19,15,']');
	textout(37,19,12,'CLEAR');
	
	setvid(44,19,15,'[');
	setvid(50,19,15,']');
	textout(45,19,14,'ENTER');
	
	
	setvid(x1,y1,11,'X');
	update(true);
	end;

until E;
createrect(25,5,56,21,0,'#',true);
update(true);
end;
	
procedure Save;
var F:Textfile;
	i,j,l,k:integer;
	hl,xyz:shortstring;	
	begin
	xyz:=chr(Player.x)+chr(Player.y)+chr(Player.z);
	hl:=chr(Player.h)+chr(Player.l);
	if SaveFile = '' then
		begin
		SaveFile := nam;
		ContinueSaveFile := SaveFile;
		end;
	assign(F,'Worlds\'+SaveFile+'.dat');
	rewrite(F);
	writeln(F,xyz);
	writeln(F,hl);
	writeln(F,inttostr(Player.xp));
	for i:=1 to 10 do
		writeln(F,inttostr(Player.inv[i]));
	for i:=0 to MAXX do
		begin
		for j:=0 to MAXY do
			for l:=0 to MAXZ do
				begin
				writeln(F,inttostr(MAP[i,j,l].blk));
				if MAP[i,j,l].iswalk then
					hl := '1'
				else	
					hl := '0';
				if MAP[i,j,l].isChest then
					hl := hl + '1'
				else	
					hl := hl + '0';
				writeln(F,hl);
				if MAP[i,j,l].isChest then
					for k:=1 to 5 do
						writeln(F,inttostr(MAP[i,j,l].C[k]));
				end;
				
		LoadBar(1,1,15,i,MAXX,'Saving');
		update(false);
		end;
	Close(F);
	Cleanup;
	redraw;
	end;

function Load(def:shortint):boolean;
var F:Textfile;
	i,j,l,k:integer;
	st:shortstring;	
	begin
	if (def = 0) then
		begin
		SaveFile := nam;
		end;
	if (SaveFile = '') then 
		begin
			Load:=False;
			exit;
		end;
		
	assign(F,'Worlds\'+SaveFile+'.dat');
	{$i-}
	reset(F);
	{$i+}
	close(F);
	if IOResult <> 0 then
		begin
			Load:=False;
			exit;
		end
	else
		begin
		ContinueSaveFile := SaveFile;
		assign(F,'Worlds\'+SaveFile+'.dat');
		reset(F);
		readln(F,st);
		Player.x := ord(st[1]);
		Player.y := ord(st[2]);
		Player.z := ord(st[3]);
		readln(F,st);
		Player.h := ord(st[1]);
		Player.l := ord(st[2]);
		readln(F,st);
		Player.xp:=strtoint(st);
		for i:=1 to 10 do
			begin
			readln(F,st);
			Player.inv[i]:=strtoint(st);
			end;
		for i:=0 to MAXX do
			begin
			for j:=0 to MAXY do
				for l:=0 to MAXZ do
					begin
					readln(F,st);
					MAP[i,j,l].blk := strtoint(st);
					readln(F,st);
					MAP[i,j,l].iswalk := FALSE;
					MAP[i,j,l].isChest := FALSE;
					if st[1] = '1' then
						MAP[i,j,l].iswalk := TRUE;
					if st[2] = '1' then
						begin
						MAP[i,j,l].isChest := TRUE;
						for k:=1 to 5 do
							begin
							readln(F,st);
							MAP[i,j,l].C[k] := strtoint(st);
							end;
						end;
					end;
			LoadBar(1,1,15,i,MAXX,'Loading');
			update(false);
			end;
		close(F);
		Load:=True;
		if def = 1 then
			Cleanup;
		redraw;
		end;
	end;	
	
procedure QuitMenu;
var M:integer;
	ch:char;
	Key:TKeyEvent;
	E:boolean;
begin
unlockupdate;
CreateBox(29,17,52,24,15,chr(79),chr(205),chr(186));
TextOut(30,18,2,'Exit');
TextOut(30,19,7,'Quit');
TextOut(30,20,7,'ItemList');
TextOut(30,21,7,'Help');
TextOut(30,22,7,'Save');
update(true);
E:=False;
M:=0;
repeat
if keypressed then
	begin
	Key :=  GetKeyEvent;
	Key :=  TranslatekeyEvent(Key);
	ch := GetKeyEventChar(Key);
	case ch of
	's':if M < 4 then inc(M);
	'w':if M > 0 then dec(M);
	#27:E:=True;
	#13:begin
			case M of
			0:E:=True;
			1:begin GameState := 0; E:=True; end;
			2:PrintItemList;
			3:PrintHelp;
			4:Save;
			end;
		end;
	end;
	CreateBox(29,17,52,24,15,chr(79),chr(205),chr(186));
	TextOut(30,18,7,'Exit');
	TextOut(30,19,7,'Quit');
	TextOut(30,20,7,'ItemList');
	TextOut(30,21,7,'Help');
	TextOut(30,22,7,'Save');
	
	case M of
	0:TextOut(30,18,2,'Exit');
	1:TextOut(30,19,2,'Quit');
	2:TextOut(30,20,2,'ItemList');
	3:TextOut(30,21,2,'Help');
	4:TextOut(30,22,2,'Save');
	end;
	update(true);
	end;
until E or not (Playing);
lockupdate;
end;	
	
procedure EnemyMove;
var x,y,dam:integer;
	tmp:Enemy;
	S:string;
begin
	tmp:=Head;
	if Head <> nil then
		begin
		while tmp <> nil do
			begin
			x := tmp^.x;
			y := tmp^.y;
			if Dist(x,y,player.x,player.y) >= 10 then
				case random(5) of
				0:inc(x);
				1:dec(x);
				2:inc(y);
				3:dec(y);
				end
			else
				begin
				case random(3) of
				0:if player.x > x then
					inc(x)
				  else
					if not (player.x = x) then
						dec(x);
				1:if player.y > y then
					inc(y)
				  else
					if not (player.y = y) then
						dec(y);
				end;
				end;
			
			if (Dist(x,y,player.x,player.y) <= 0) then
				if (random(2) = 0) then
					begin
					dam := (random((tmp^.t+1)*8)+5)-player.Armour;
					if dam > 0 then
						begin
						player.h := player.h - dam;
						AddMessage(EnemyName(tmp^.t)+' Hit for '+inttostr(dam)+' Damage!',3,12);
						end
					else
						AddMessage(EnemyName(tmp^.t)+' Hit But Caused no Damage!',3,11);
					end
				else
					begin
						if (random(2) = 0) then
							begin
								dam := (random(player.Attack+10)+10);
								tmp^.h := tmp^.h - dam;
								AddMessage('You hit '+EnemyName(tmp^.t)+' for '+inttostr(dam)+' Damage!',3,12);
							end
						else
							AddMessage('You Miss '+EnemyName(tmp^.t),2,9);
					end
			else if Between(x,y,1,1,MAXX-1,MAXY-1) and (MAP[x,y,player.z].iswalk) and ((MAP[x,y,player.z].blk <> 9) and (MAP[x,y,player.z].blk <> 15)) then
				begin
				tmp^.x:=x;
				tmp^.y:=y;
				if ((GetB(x,y) = 10) or (GetB(x,y) = 46)) then tmp^.h := tmp^.h - random(20);
				end;
			tmp := tmp^.next;
			end;
		end;
end;
			
procedure InventoryMenu;
var m,m1,i,k:integer;
	Move,E:boolean;
	ch:char;
	st : string;
	Key:TKeyEvent;
begin
UnlockUpdate();
E := true;
m := 1;
Move := false;
CreateBox(29,12,52,28,15,chr(79),chr(205),chr(186));
TextOut(30,12,15,'Inventory');
for i:=1 to 10 do
	begin
	st := inttostr(i)+':'+itemlist(player.inv[i]);
	if (i = m) then
		TextOut(30,12+i,3,st)
	else
		TextOut(30,12+i,15,st);
	end;
update(true);
while (E = true) do
	begin
	if keypressed then
		begin
			Key :=  GetKeyEvent;
			Key :=  TranslatekeyEvent(Key);
			ch := GetKeyEventChar(Key);
			if (ch = 'w') and (m-1 >= 1) then dec(m);
			if (ch = 's') and (m+1 <= 10) then inc(m);
			if (ch = #13) then
				if (Move = false) then
					begin
					Move := true;
					m1 := m;
					end
				else
					begin
					i := player.inv[m];
					player.inv[m] := player.inv[m1];
					player.inv[m1] := i;
					Move := false;
					end;
			if (ch = #27) or (ch = 'i') then
				E := false;
				
			CreateBox(29,12,52,28,15,chr(79),chr(205),chr(186));
			TextOut(30,12,15,'Inventory');
			for i:=1 to 10 do
				begin
				st := inttostr(i)+':'+itemlist(player.inv[i]);
				if (i = m) then
					TextOut(30,12+i,2,st)
				else
					if (Move = true) and (i = m1) then
						TextOut(30,12+i,12,st)
					else
						TextOut(30,12+i,15,st);
				end;
			update(true);
		end;
	end;
LockUpdate;	
end;

procedure Crafting;
var m,m1,i,k:integer;
	Move,E:boolean;
	ch:char;
	st : string;
	Key:TKeyEvent;
begin
UnlockUpdate();
E := true;
m := 1;
Move := false;
CreateBox(29,12,52,28,15,chr(79),chr(205),chr(186));
TextOut(30,12,15,'Crafting');
for i:=1 to 10 do
	begin
	st := inttostr(i)+':'+itemlist(player.inv[i]);
	if (i = m) then
		TextOut(30,12+i,3,st)
	else
		TextOut(30,12+i,15,st);
	end;
update(true);
while (E = true) do
	begin
	if keypressed then
		begin
			Key :=  GetKeyEvent;
			Key :=  TranslatekeyEvent(Key);
			ch := GetKeyEventChar(Key);
			if (ch = 'w') and (m-1 >= 1) then dec(m);
			if (ch = 's') and (m+1 <= 10) then inc(m);
			if (ch = #13) then
				if (Move = false) then
					begin
					Move := true;
					m1 := m;
					end
				else
					begin
					if m1 <> m then
						begin
							i := Combine(player.inv[m],player.inv[m1]);
							if i <> 0 then
								if Tool(player.inv[m]) then
									player.inv[m1] := i
								else if Tool(player.inv[m1]) then
									player.inv[m] := i
								else
									begin			
									player.inv[m1] := 0;
									player.inv[m] := i;
									end;
							Move := false;
						end;
					end;
			if (ch = #27) or (ch = 'i') then
				E := false;
				
			CreateBox(29,12,52,28,15,chr(79),chr(205),chr(186));
			TextOut(30,12,15,'Crafting');
			for i:=1 to 10 do
				begin
				st := inttostr(i)+':'+itemlist(player.inv[i]);
				if (i = m) then
					TextOut(30,12+i,2,st)
				else
					if (Move = true) and (i = m1) then
						TextOut(30,12+i,12,st)
					else
						TextOut(30,12+i,15,st);
				end;
			update(true);
		end;
	end;
LockUpdate;	
end;
	
procedure Playermov;
var x,y:integer;
	ch:char;
	Key:TKeyEvent;
	NeedsRedraw:boolean;
begin
NeedsRedraw := false;
if keypressed then
	begin
	x := player.x;
	y := player.y;
	Key :=  GetKeyEvent;
	Key :=  TranslatekeyEvent(Key);
	ch := GetKeyEventChar(Key);
		begin
			if (ch = 'x') then player.inv[1]:=42;
			if (ch = 'w') and (y-1 > 0) and (CheckD(0,-1) or CheckM(0,-1)) and not CheckE(0,-1)  then begin dec(y); player.d:=0; Ycheck(x,y); end else if (ch = 'w') then begin player.d:=0; end;
			if (ch = 's') and (y+1 < MAXY) and (CheckD(0,1) or CheckM(0,1)) and not CheckE(0,1)  then begin inc(y); player.d:=1; Ycheck(x,y); end else if (ch = 's') then begin player.d:=1; end;
			if (ch = 'a') and (x-1 > 0) and (CheckD(-1,0) or CheckM(-1,0)) and not CheckE(-1,0)  then begin dec(x); player.d:=2; Ycheck(x,y); end else if (ch = 'a') then begin player.d:=2; end;
			if (ch = 'd') and (x+1 < MAXX) and (CheckD(1,0) or CheckM(1,0)) and not CheckE(1,0)  then begin inc(x); player.d:=3; Ycheck(x,y); end else if (ch = 'd') then begin player.d:=3; end;
			if (ch = 'f') then
				begin
				while not keypressed do begin end;
				Key :=  GetKeyEvent;
				Key :=  TranslatekeyEvent(Key);
				ch := GetKeyEventChar(Key);
				if (ch = 'w') then
					player.d := 0;
				if (ch = 's') then
					player.d := 1;
				if (ch = 'a') then
					player.d := 2;
				if (ch = 'd') then
					player.d := 3;
				NeedsRedraw := true;
				end;
			if (ch = 'c') then begin Crafting; NeedsRedraw := true; end;
			if (ch = 'w') or (ch = 's') or (ch = 'a') or (ch = 'd') then
				begin
				if (GetB(x,y) = 10) or (GetB(x,y) = 46) then
					player.h := player.h - 10;
				NeedsRedraw := true;
				end;
				
			if (ch = 'e') then begin invt; NeedsRedraw := true; end;
			if (ch = 'q') then begin drop; NeedsRedraw := true; end;
			if (ch = 'i') then begin InventoryMenu; NeedsRedraw := true; end;
			if (ch = '/') then inc(player.Attack);
			if (ch = '.') then H:=11;
			if (ch = ',') then inc(player.Armour);
			if (ch = #13) then
				if DEBUG = true then
					DEBUG := false
				else	
					DEBUG := true;
			if (ch = #27) then begin QuitMenu; NeedsRedraw := true; end;
		end;
	if DEBUG then
		begin
		player.h := 100;
		end;	
	
	if not Equal(player.x,player.y,x,y) then
		begin
			player.x := x;
			player.y := y;
			NeedsRedraw := true;
		end;
	end;
	
	if Player.h <= 0 then
		begin
		player.h := 100;
		player.x := player.spx;
		player.y := player.spy;
		player.z := player.spz;
		AddMessage('YOU DIED!',5,12);
		NeedsRedraw := true;
		end;
		
	if (NeedsRedraw) then
		redraw;
	
end;
	
procedure AppaDrop(x,y:integer);
var i,j,d,trys:integer;
	begin
	trys := 0;
	d := 0;
	while (d = 0) and (trys <= 2) do
		begin
		i := (random(3)-1);
		j := (random(3)-1);
		if (Between(i+x,j+y,0,0,MAXX,MAXY) and (GetB(i+x,j+y) = 0)) then
			begin
			case random(20) of
			0:SetBlock(i+x,j+y,0,29);
			1..5:SetBlock(i+x,j+y,0,28);
			end;
			d := 1;
			end
		else
			inc(trys);
		end;
	end;
	
function InArea(x,y,r,b:integer):Boolean;	
var i,j:integer;
	f:boolean;
	begin
	f := false;
	for i := -r to r do
		for j := -r to r do
			if Between((x+i),(j+y),0,0,MAXX,MAXY) and (Dist((x+i),(y+j),x,y) <= r) and (GetB(x+i,y+j) = b) then
				f := true;
	InArea := f;
	end;	
	
	
procedure Ter;
var i,j:integer;
begin
for i := 1 to MAXX-1 do
	for j := 1 to MAXY-1 do
		begin
		if (random(50) = 0) then
			case GetB(i,j) of
			30:SetBlock(i,j,0,7);
			31:SetBlock(i,j,0,20);
			47:SetBlock(i,j,0,0);
			28..29:if random(2) = 0 then
					SetBlock(i,j,0,0);
			7:AppaDrop(i,j);
			50:SetBlock(i,j,0,51);
			end;
		
		end;	
end;	
		
procedure FireSpread(x,y:integer);
var i,j,d,trys:integer;
begin
d := random(5)+3;
trys := 0;
while (d > 0) and (trys <= 3) do
	begin
	i := (random(3)-1);
	j := (random(3)-1);
	if Between(i+x,j+y,1,1,MAXX-1,MAXY-1) and (map[i+x,j+y,player.z].blk = 0) then
		begin
		if GetB(i+x,j+y) = 0 then SetBlock(i+x,j+y,player.z,47);
		dec(d);
		end
	else
		inc(trys);
	end;
	
end;	
		
procedure DynTer;
var i,j:integer;
	Update:boolean;
	begin
	Update := false;
	if (H>=11) or (player.z > 0) then
		begin
		EnemyMove;
		Update := true;
		end;
	for i := 1 to MAXX-1 do
		for j := 1 to MAXY-1 do
			begin
				if (GetB(i,j) = 0) and (random(3) = 0) and ((Sur4(i,j,player.z,2) > 0) or ((Sur4(i,j,player.z,45) > 0) and InArea(i,j,4,2))) then
					begin
					SetBlock(i,j,player.z,45);
					Update := true;
					end;
				if (GetB(i,j) = 0) and (random(3) = 0) and ((Sur4(i,j,player.z,10) > 0) or ((Sur4(i,j,player.z,46) > 0) and InArea(i,j,4,10))) then
					begin
					SetBlock(i,j,player.z,46);
					Update := true;
					end;
				if (GetB(i,j) = 30) and (random(5) = 0) and ((Sur(i,j,player.z,46) > 0) or (Sur(i,j,player.z,10) > 0) or (Sur(i,j,player.z,47) > 0)) then
					begin
					SetBlock(i,j,player.z,41);
					FireSpread(i,j);
					Update := true;
					end;
				if (GetB(i,j) = 31) and (random(5) = 0) and ((Sur(i,j,player.z,46) > 0) or (Sur(i,j,player.z,10) > 0) or (Sur(i,j,player.z,47) > 0)) then
					begin
					SetBlock(i,j,player.z,41);
					FireSpread(i,j);
					Update := true;
					end;
				if (GetB(i,j) = 7) and (random(10) = 0) and ((Sur(i,j,player.z,46) > 0) or (Sur(i,j,player.z,10) > 0) or (Sur(i,j,player.z,47) > 0)) then
					begin
					SetBlock(i,j,player.z,41);
					FireSpread(i,j);
					Update := true;
					end;
				if (random(2) = 0) and (GetB(i,j) = 45) and not InArea(i,j,4,2) then
					begin
					SetBlock(i,j,player.z,0);
					Update := true;
					end;
				if (random(2) = 0) and (GetB(i,j) = 46) and not InArea(i,j,4,10) then
					begin
					SetBlock(i,j,player.z,0);
					Update := true;
					end;
				if (random(4) = 0) and (GetB(i,j) = 47) then
					begin
					SetBlock(i,j,player.z,0);
					Update := true;
					end;
			end;
	if Update then
		redraw;
	end;
		
procedure TimeUpdate;
var TS : TTimeStamp;
begin
TS:=DateTimeToTimeStamp(Now);
STP := TS.Time;

if ST = 0 then
	ST := TS.Time;

if ST1 = 0 then
	ST1 := TS.Time;	
	
if ((STP - ST1) >= 500) then	
	begin
		DynTer;
		CullMessages;
		ST1 := TS.Time;
	end;
	
if STP - ST >= UPTIM then	
	begin
	ST := TS.Time;
	inc(H);
	if (H = 11) and (TIMECROSS = false) then
		begin
		TIMECROSS := true;
		redraw;
		end;
	TimeDraw;
	update(false);
	end;

if H > 20 then
	begin
	TIMECROSS := false;
	Ter;
	H:=0;
	DumpMem;
	redraw;
	end;
end;	
	
procedure TestGen;
var i,j:integer;
begin
for i := 1 to MAXX-1 do
	for j := 1 to MAXY-1 do
		begin
		if (i mod 2 = 0) and (j mod 2 = 0) then
			SetBlock(i,j,0,7)
		else
			SetBlock(i,j,0,0);

		MAP[i,j,0].typ := random(4)+1;
		MAP[i,j,0].colV := random(2);	
		end;

for i := 1 to MAXX-1 do
	begin
	SetBlock(i,1,0,i-1);
	SetBlock(i,2,0,0);
	end;
redraw;
end;	
	
procedure FileCheck;
var F:Textfile;
	st:string;
begin
if not DirectoryExists('Worlds') then
	if not CreateDir('Worlds') then
		begin
		textout(1,1,15,'Failed To create Worlds Directory');
		update(true);
		sleep(5);
		halt;
		end;

assign(F,'Config.cfg');
{$i-}	
reset(F);
close(F);
{$i+}

if IOResult<>0 then
	begin
	assign(F,'Config.cfg');
	rewrite(F);
	writeln(F,'FALSE');
	writeln(F,'');
	close(F);
	SaveFile := '';
	DEBUG := False;
	end
else
	begin
	assign(F,'Config.cfg');
	reset(F);
	readln(F,st);
	DEBUG := StrToBool(st);
	readln(F,st);
	ContinueSaveFile := st;
	write('WANK');
	close(F);
	end;
end;	
	
function MainMenu:integer;
	var M:integer;
	ch:char;
	Key:TKeyEvent;
	E:boolean;
begin
TextOut(30,18,2,'*Start New Game');
TextOut(30,19,7,'Load Game');
TextOut(30,20,7,'Continue ['+ContinueSaveFile+']');
TextOut(30,21,7,'Quit Game');
update(true);
E:=False;
M:=0;
repeat
if keypressed then
	begin
	Key :=  GetKeyEvent;
	Key :=  TranslatekeyEvent(Key);
	ch := GetKeyEventChar(Key);
	case ch of
	's':if M < 3 then inc(M);
	'w':if M > 0 then dec(M);
	#13:begin
			if M = 2 then
				SaveFile := ContinueSaveFile;
			MainMenu:=M; 
			E := true;
		end;
	end;
	TextOut(30,18,7,'Start New Game ');
	TextOut(30,19,7,'Load Game ');
	TextOut(30,20,7,'Continue ['+ContinueSaveFile+'] ');
	TextOut(30,21,7,'Quit Game ');
	case M of
	0:TextOut(30,18,2,'*Start New Game');
	1:TextOut(30,19,2,'*Load Game');
	2:TextOut(30,20,2,'*Continue ['+ContinueSaveFile+']');
	3:TextOut(30,21,2,'*Quit Game');
	end;
	update(true);
	end;
until E;
sleep(500);
DEBUG := False;
if keypressed then
	begin
	Key :=  GetKeyEvent;
	Key :=  TranslatekeyEvent(Key);
	ch := GetKeyEventChar(Key);
	if (ch = 'd') then
		DEBUG := True;
	end;
end;	
	
Procedure GameRun;
begin
	LockUpdate;
	if (H >= 11) or (Player.z > 0) then
		EnemyHandle;
	Playermov;
	TimeUpdate;
	DisplayMessages;
	UnlockUpdate;
	Update(True);
end;
	
procedure MenuRun;
begin
	clrscr;
	DumpMem;
	PlaySnd('test');
	INIT;
	FileCheck;
	case MainMenu of
	0:if DEBUG then
		begin
		clrscr;
		TestGen;
		GameState := 1;
		SaveFile:='';
		end
	 else
		begin
		clrscr;
		GEN;
		GameState := 1;
		SaveFile:='';
		end;
	1:begin
		SaveFile := '';
		if not Load(0) then
		begin
			clrscr;
			textout(1,1,15,'Error opening file...');
			textout(1,2,15,'Creating New world...');
			update(true);
			sleep(1600);
			createrect(1,1,20,2,15,' ',true);
			GEN;
		end;
		GameState := 1;
	  end;
	2:begin if not Load(1) then
		begin
			clrscr;
			textout(1,1,15,'Error opening file...');
			textout(1,2,15,'Creating New world...');
			update(true);
			sleep(1600);
			createrect(1,1,20,2,15,' ',true);
			GEN;
		end;
		GameState := 1;
	  end;
	3:begin Playing := false; end;
	end;
end;
	
begin
GameState := 0;
Intro;
repeat
	case GameState of
	0:MenuRun;
	1:GameRun;
	end;
until not Playing;
Cleanup;
DumpMem;
DoneKeyboard;
end.
