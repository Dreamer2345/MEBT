program SawTooth;

uses MMSystem,sysutils;

begin
Writeln ('Current Directory is : ',GetCurrentDir);
sndPlaySound(PChar(GetCurrentDir+'\'+k+'.wav'), SND_ASYNC);
readln;
end.
