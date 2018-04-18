program Drawingtest;

uses Cansdraw,sysutils;


const FOV = 200;


type
	TWall = record
	x,y,z,x1,y1,z1:integer;
	end;

var i,j,z,z1,x,x1,y,y1,MIDX,MIDY,px,py,pz,k:integer;
	l:real;
	w:array[0..8] of TWall;
	
	
	


	
	
	
begin

for i := 1 to ScreenH do
	begin
	CreateLine(1,i,ScreenW,(ScreenH+1)-i,i,'@');
	update(false);
	end;
for i := 1 to ScreenW do
	begin
	CreateLine((ScreenW+1)-i,1,i,ScreenH,i,'@');
	update(false);
	end;
randomize;
clrscr;
px := 0;
py := 0;







MIDX := round(ScreenW/2);
MIDY := round(ScreenH/2);


k := 10;

w[0].x:=-10;
w[0].y:=10;
w[0].z:=1;
w[0].x1:=0;
w[0].y1:=5-k;
w[0].z1:=1;


w[1].x:=0;
w[1].y:=5-k;
w[1].z:=1;
w[1].x1:=10;
w[1].y1:=10;
w[1].z1:=1;

w[2].x:=10;
w[2].y:=10;
w[2].z:=1;
w[2].x1:=5-k;
w[2].y1:=0;
w[2].z1:=1;

w[3].x:=5-k;
w[3].y:=0;
w[3].z:=1;
w[3].x1:=10;
w[3].y1:=-10;
w[3].z1:=1;

w[4].x:=10;
w[4].y:=-10;
w[4].z:=1;
w[4].x1:=0;
w[4].y1:=-5+k;
w[4].z1:=1;

w[5].x:=0;
w[5].y:=-5+k;
w[5].z:=1;
w[5].x1:=-10;
w[5].y1:=-10;
w[5].z1:=1;

w[6].x:=-10;
w[6].y:=-10;
w[6].z:=1;
w[6].x1:=-5+k;
w[6].y1:=0;
w[6].z1:=1;

w[7].x:=-5+k;
w[7].y:=0;
w[7].z:=1;
w[7].x1:=-10;
w[7].y1:=10;
w[7].z1:=1;

w[8].x:=-10;
w[8].y:=10;
w[8].z:=1;
w[8].x1:=0;
w[8].y1:=5-k;
w[8].z1:=1;

repeat
for i:=0 to 356 do
	begin		
	pz := i;
	if true then
		begin
			for j:=0 to 8 do
				begin
					x:=w[j].x-px;
					x1:=w[j].x1-px;
					y:=w[j].y-py;
					y1:=w[j].y1-py;
					z:=w[j].z-pz;
					z1:=w[j].z1-pz;
					
					if pz <> 0 then
						l := FOV/pz
					else
						l := FOV;
					
					Rotate2D(x,y,i);
					Rotate2D(x1,y1,i);
					x := round(x * l);
					y := round(y * l);
					x1 := round(x1 * l);
					y1 := round(y1 * l);
					CreateLine(MIDX-x,MIDY-y,MIDX-x1,MIDY-y1,j mod 256,chr(1));
				end;
			update(true);
			{
			for j:=0 to 8 do
				begin
					x:=w[j].x-px;
					x1:=w[j].x1-px;
					y:=w[j].y-py;
					y1:=w[j].y1-py;
					Rotate2D(x,y,i);
					Rotate2D(x1,y1,i);
					x := round(x * l);
					y := round(y * l);
					x1 := round(x1 * l);
					y1 := round(y1 * l);
					CreateLine(MIDX-x,MIDY-y,MIDX-x1,MIDY-y1,0,'#');
				end;}
		end;
	end;
until false;
readln;
end.
