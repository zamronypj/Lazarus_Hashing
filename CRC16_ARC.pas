unit CRC16_ARC;
//CRC-16 ARC
//Author: domasz
//Version: 0.1 (2022-11-17)
//Licence: MIT

interface

uses SysUtils, HasherBase;

type THasherCRC16_ARC = class(THasherBase)
  private
    FHash: Word;
  public
    constructor Create; override;
    procedure Update(Msg: PByte; Length: Integer); override;
    function Final: String; override;
end;

implementation

var Table: array[0..255] of Word = (
$00000000, $0000C0C1, $0000C181, $00000140, $0000C301, $000003C0, $00000280, $0000C241, 
$0000C601, $000006C0, $00000780, $0000C741, $00000500, $0000C5C1, $0000C481, $00000440, 
$0000CC01, $00000CC0, $00000D80, $0000CD41, $00000F00, $0000CFC1, $0000CE81, $00000E40, 
$00000A00, $0000CAC1, $0000CB81, $00000B40, $0000C901, $000009C0, $00000880, $0000C841, 
$0000D801, $000018C0, $00001980, $0000D941, $00001B00, $0000DBC1, $0000DA81, $00001A40, 
$00001E00, $0000DEC1, $0000DF81, $00001F40, $0000DD01, $00001DC0, $00001C80, $0000DC41, 
$00001400, $0000D4C1, $0000D581, $00001540, $0000D701, $000017C0, $00001680, $0000D641, 
$0000D201, $000012C0, $00001380, $0000D341, $00001100, $0000D1C1, $0000D081, $00001040, 
$0000F001, $000030C0, $00003180, $0000F141, $00003300, $0000F3C1, $0000F281, $00003240, 
$00003600, $0000F6C1, $0000F781, $00003740, $0000F501, $000035C0, $00003480, $0000F441, 
$00003C00, $0000FCC1, $0000FD81, $00003D40, $0000FF01, $00003FC0, $00003E80, $0000FE41, 
$0000FA01, $00003AC0, $00003B80, $0000FB41, $00003900, $0000F9C1, $0000F881, $00003840, 
$00002800, $0000E8C1, $0000E981, $00002940, $0000EB01, $00002BC0, $00002A80, $0000EA41, 
$0000EE01, $00002EC0, $00002F80, $0000EF41, $00002D00, $0000EDC1, $0000EC81, $00002C40, 
$0000E401, $000024C0, $00002580, $0000E541, $00002700, $0000E7C1, $0000E681, $00002640, 
$00002200, $0000E2C1, $0000E381, $00002340, $0000E101, $000021C0, $00002080, $0000E041, 
$0000A001, $000060C0, $00006180, $0000A141, $00006300, $0000A3C1, $0000A281, $00006240, 
$00006600, $0000A6C1, $0000A781, $00006740, $0000A501, $000065C0, $00006480, $0000A441, 
$00006C00, $0000ACC1, $0000AD81, $00006D40, $0000AF01, $00006FC0, $00006E80, $0000AE41, 
$0000AA01, $00006AC0, $00006B80, $0000AB41, $00006900, $0000A9C1, $0000A881, $00006840, 
$00007800, $0000B8C1, $0000B981, $00007940, $0000BB01, $00007BC0, $00007A80, $0000BA41, 
$0000BE01, $00007EC0, $00007F80, $0000BF41, $00007D00, $0000BDC1, $0000BC81, $00007C40, 
$0000B401, $000074C0, $00007580, $0000B541, $00007700, $0000B7C1, $0000B681, $00007640, 
$00007200, $0000B2C1, $0000B381, $00007340, $0000B101, $000071C0, $00007080, $0000B041, 
$00005000, $000090C1, $00009181, $00005140, $00009301, $000053C0, $00005280, $00009241, 
$00009601, $000056C0, $00005780, $00009741, $00005500, $000095C1, $00009481, $00005440, 
$00009C01, $00005CC0, $00005D80, $00009D41, $00005F00, $00009FC1, $00009E81, $00005E40, 
$00005A00, $00009AC1, $00009B81, $00005B40, $00009901, $000059C0, $00005880, $00009841, 
$00008801, $000048C0, $00004980, $00008941, $00004B00, $00008BC1, $00008A81, $00004A40, 
$00004E00, $00008EC1, $00008F81, $00004F40, $00008D01, $00004DC0, $00004C80, $00008C41, 
$00004400, $000084C1, $00008581, $00004540, $00008701, $000047C0, $00004680, $00008641, 
$00008201, $000042C0, $00004380, $00008341, $00004100, $000081C1, $00008081, $00004040
);

constructor THasherCRC16_ARC.Create;
begin
  inherited Create;
  FHash :=  $0000;
  Check := 'BB3D';
end;

procedure THasherCRC16_ARC.Update(Msg: PByte; Length: Integer);
var i: Integer;
begin
  for i:=0 to Length-1 do begin
    FHash := (FHash shr 8) xor Table[(FHash xor Msg^) and $FF];
    Inc(Msg);
  end;   
end;

function THasherCRC16_ARC.Final: String;
begin
  
  Result := IntToHex(FHash, 4); 
end;

initialization
  HasherList.RegisterHasher('CRC-16 ARC', THasherCRC16_ARC);

end.