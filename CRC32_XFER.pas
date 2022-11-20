unit CRC32_XFER;
//CRC-32 XFER
//Author: domasz
//Last Update: 2022-11-20
//Licence: MIT

interface

uses SysUtils, HasherBase;

type THasherCRC32_XFER = class(THasherbase)
  private
    FHash: Cardinal;
  public
    constructor Create; override;
    procedure Update(Msg: PByte; Length: Integer); override;
    function Final: String; override;
end;


implementation

var Table: array[0..255] of LongInt = (
$00000000, $000000AF, $0000015E, $000001F1, $000002BC, $00000213, $000003E2, $0000034D, 
$00000578, $000005D7, $00000426, $00000489, $000007C4, $0000076B, $0000069A, $00000635, 
$00000AF0, $00000A5F, $00000BAE, $00000B01, $0000084C, $000008E3, $00000912, $000009BD, 
$00000F88, $00000F27, $00000ED6, $00000E79, $00000D34, $00000D9B, $00000C6A, $00000CC5, 
$000015E0, $0000154F, $000014BE, $00001411, $0000175C, $000017F3, $00001602, $000016AD, 
$00001098, $00001037, $000011C6, $00001169, $00001224, $0000128B, $0000137A, $000013D5, 
$00001F10, $00001FBF, $00001E4E, $00001EE1, $00001DAC, $00001D03, $00001CF2, $00001C5D, 
$00001A68, $00001AC7, $00001B36, $00001B99, $000018D4, $0000187B, $0000198A, $00001925, 
$00002BC0, $00002B6F, $00002A9E, $00002A31, $0000297C, $000029D3, $00002822, $0000288D, 
$00002EB8, $00002E17, $00002FE6, $00002F49, $00002C04, $00002CAB, $00002D5A, $00002DF5, 
$00002130, $0000219F, $0000206E, $000020C1, $0000238C, $00002323, $000022D2, $0000227D, 
$00002448, $000024E7, $00002516, $000025B9, $000026F4, $0000265B, $000027AA, $00002705, 
$00003E20, $00003E8F, $00003F7E, $00003FD1, $00003C9C, $00003C33, $00003DC2, $00003D6D, 
$00003B58, $00003BF7, $00003A06, $00003AA9, $000039E4, $0000394B, $000038BA, $00003815, 
$000034D0, $0000347F, $0000358E, $00003521, $0000366C, $000036C3, $00003732, $0000379D, 
$000031A8, $00003107, $000030F6, $00003059, $00003314, $000033BB, $0000324A, $000032E5, 
$00005780, $0000572F, $000056DE, $00005671, $0000553C, $00005593, $00005462, $000054CD, 
$000052F8, $00005257, $000053A6, $00005309, $00005044, $000050EB, $0000511A, $000051B5, 
$00005D70, $00005DDF, $00005C2E, $00005C81, $00005FCC, $00005F63, $00005E92, $00005E3D, 
$00005808, $000058A7, $00005956, $000059F9, $00005AB4, $00005A1B, $00005BEA, $00005B45, 
$00004260, $000042CF, $0000433E, $00004391, $000040DC, $00004073, $00004182, $0000412D, 
$00004718, $000047B7, $00004646, $000046E9, $000045A4, $0000450B, $000044FA, $00004455, 
$00004890, $0000483F, $000049CE, $00004961, $00004A2C, $00004A83, $00004B72, $00004BDD, 
$00004DE8, $00004D47, $00004CB6, $00004C19, $00004F54, $00004FFB, $00004E0A, $00004EA5, 
$00007C40, $00007CEF, $00007D1E, $00007DB1, $00007EFC, $00007E53, $00007FA2, $00007F0D, 
$00007938, $00007997, $00007866, $000078C9, $00007B84, $00007B2B, $00007ADA, $00007A75, 
$000076B0, $0000761F, $000077EE, $00007741, $0000740C, $000074A3, $00007552, $000075FD, 
$000073C8, $00007367, $00007296, $00007239, $00007174, $000071DB, $0000702A, $00007085, 
$000069A0, $0000690F, $000068FE, $00006851, $00006B1C, $00006BB3, $00006A42, $00006AED, 
$00006CD8, $00006C77, $00006D86, $00006D29, $00006E64, $00006ECB, $00006F3A, $00006F95, 
$00006350, $000063FF, $0000620E, $000062A1, $000061EC, $00006143, $000060B2, $0000601D, 
$00006628, $00006687, $00006776, $000067D9, $00006494, $0000643B, $000065CA, $00006565
);

constructor THasherCRC32_XFER.Create;
begin
  inherited Create;
  FHash := $00000000;
  Check := 'BD0BE338';
end;

procedure THasherCRC32_XFER.Update(Msg: PByte; Length: Integer);
var i: Integer;
begin
  for i:=0 to Length-1 do begin
    FHash := (FHash shl 8) xor Table[Msg^ xor (FHash shr 24)];
    Inc(Msg);
  end;   
end;

function THasherCRC32_XFER.Final: String;
begin
  
  Result := IntToHex(FHash, 8);
end;


initialization
  HasherList.RegisterHasher('CRC-32 XFER', THasherCRC32_XFER);

end.
