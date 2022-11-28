unit SHA0;
//SHA-0
//Author: domasz
//Last Update: 2022-11-26
//Licence: MIT

interface

uses SysUtils, HasherBase;

type THasherSHA0 = class(THasherbase)
  private
    FTotalSize: Int64;
    FHash: array[0..4] of Cardinal;
  public
    constructor Create; override;
    procedure Update(Msg: PByte; Length: Integer); override;
    function Final: String; override;
end;

implementation

constructor THasherSHA0.Create;
begin
  inherited Create;

  Check := 'F0360779D2AF6615F306BB534223CF762A92E988';

  FHash[0] := $67452301;
  FHash[1] := $EFCDAB89;
  FHash[2] := $98BADCFE;
  FHash[3] := $10325476;
  FHash[4] := $C3D2E1F0;
end;

procedure THasherSHA0.Update(Msg: PByte; Length: Integer);
var i: Integer;
    r: Integer;
    j: Integer;
    A,B,C,D,E,F: Cardinal;
    T: Cardinal;
    w: array[0..79] of Integer;
    buf: array[0..63] of Byte;
    Left: Integer;
    Bits: Int64;
begin
  Inc(FTotalSize, Length);

  i := 0;

  while i < Length do begin
       A := FHash[0];
       B := FHash[1];
       C := FHash[2];
       D := FHash[3];
       E := FHash[4];

       if Length - i > 63 then begin
         Move(Msg^, buf[0], 64);
         Inc(Msg, 64);
       end
       else begin
        Left := Length mod 64;

        FillChar(Buf, 64, 0);
        Move(Msg^, buf[0], Left);

        Buf[Left] := $80;

 	Bits := FTotalSize shl 3;

        Buf[56] := bits shr 56;
 	buf[57] := bits shr 48;
 	buf[58] := bits shr 40;
 	buf[59] := bits shr 32;
 	buf[60] := bits shr 24;
 	buf[61] := bits shr 16;
 	buf[62] := bits shr 8;
 	buf[63] := bits;
       end;

      for j:=0 to 15 do begin
        w[j] := (buf[j*4] shl 24) or (buf[j*4 +1] shl 16) or (buf[j*4 +2] shl 8) or (buf[j*4 +3]);
      end;

      for r := 16 to 79 do begin
        T    := w[r - 3] xor w[r - 8] xor w[r - 14] xor w[r - 16];
        w[r] := T; //diff betweeh SHA0 and SHA1
      end;

      for r := 0 to 19 do begin
        F := ((B and C) or ((not B) and D)) + $5A827999;
        T := RolDWord(A, 5) + F + E + w[r];
        E := D;
        D := C;
        C := RolDWord(B, 30);
        B := A;
        A := T;
      end;

      for r := 20 to 39 do begin
        F := (B xor C xor D) + $6ED9EBA1;
        T := RolDWord(A, 5) + F + E + w[r];
        E := D;
        D := C;
        C := RolDWord(B, 30);
        B := A;
        A := T;
      end;

      for r := 40 to 59 do begin
        F := (B and C or B and D or C and D) + $8F1BBCDC;
        T := RolDWord(A, 5) + F + E + w[r];
        E := D;
        D := C;
        C := RolDWord(B, 30);
        B := A;
        A := T;
      end;

      for r := 60 to 79 do begin
        F := (B xor C xor D) + $CA62C1D6;
        T := RolDWord(A, 5) + F + E + w[r];
        E := D;
        D := C;
        C := RolDWord(B, 30);
        B := A;
        A := T;
      end;

      FHash[0] := FHash[0] + A;
      FHash[1] := FHash[1] + B;
      FHash[2] := FHash[2] + C;
      FHash[3] := FHash[3] + D;
      FHash[4] := FHash[4] + E;

      Inc(i, 64);
  end;
end;

function THasherSHA0.Final: String;
begin
  Result := IntToHex(FHash[0], 8) + IntToHex(FHash[1], 8) + IntToHex(FHash[2], 8) +
            IntToHex(FHash[3], 8) + IntToHex(FHash[4], 8);
end;

initialization
  HasherList.RegisterHasher('SHA-0', THasherSHA0);

end.
