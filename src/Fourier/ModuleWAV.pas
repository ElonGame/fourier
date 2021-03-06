unit ModuleWav;

{$H+}

interface

uses
  Classes, SysUtils;

Const
  NoError            = 0;
  ReadError          = 1;
  HeaderError        = 2;
  DataError          = 3;
  FileCorrupt        = 4;
  IncorectFileFormat = 5;
  FileDontFound      = 6;

  MaxBlock = 200;

 type
  T3Bytes = array [0..2] of Byte;

  T8BitsPerSample  = array of Byte;
  T16BitsPerSample = array of SmallInt;
  T24BitsPerSample = array of T3Bytes;
  T32BitsPerSample = array of Integer;

  //TAudioData = array of integer; 

  TWaveHeaderChank = record     
      wFormatTag     : Smallint;
      wChannels      : WORD;
      wSamplesPerSec : Cardinal;
      wAvgBytesPerSec: Cardinal;
      wBlockAlign    : WORD;
      wBitsPerSample : WORD;
      wcbSize        : WORD;
    end;


  { TPCMWaveFile }

  TPCMWaveFile = class
    private
      WaveFile       : TFileStream;
      FSamples        : TMemoryStream;

      F_8BitsSamples  :T8BitsPerSample;
      F_16BitsSamples :T16BitsPerSample;
      F_24BitsSamples :T24BitsPerSample;
      F_32BitsSamples :T32BitsPerSample;

      FAvgBytesPerSec: Cardinal;
      FCountFFTPoint: Word;

      FFileSize      : Cardinal;
      FSamplesPerSec : Cardinal;
      FBlockAlign    : Word;
      FChannels      : Word;
      FBitsPerSample : Word;
      FFormatTag     : Word;
      FIdError       : Word;
      procedure SetCountFFTPoint(const AValue: Word);

    public
      property _8BitsSamples  :T8BitsPerSample  read F_8BitsSamples;   
      property _16BitsSamples :T16BitsPerSample  read F_16BitsSamples;
      {������ ������� (16 ���)}
      property _24BitsSamples :T24BitsPerSample  read F_24BitsSamples;
      //������ ������� (24 ���)
      property _32BitsSamples :T32BitsPerSample  read F_32BitsSamples;
      //������ ������� (32 ���)

      property IdError       :Word     read FIdError;
      //ID ������ ��� ������� �����
      property FileSize      :Cardinal read FFileSize;
      //������ ����� � ������
      property FormatTag     :Word     read FFormatTag;
      // ��������� �������
      property Channels      :Word     read FChannels;
      // ����� �������
      property BitsPerSample :Word     read FBitsPerSample;
      // ��� �� �����
      property SamplesPerSec :Cardinal read FSamplesPerSec;
      // ������� �������������
      property AvgBytesPerSec:Cardinal read FAvgBytesPerSec;
      // ���� � �������
      property BlockAlign    :Word     read FBlockAlign;
      // ������������ ������ � data-�����

      property CountFFTPoint:Word read FCountFFTPoint write SetCountFFTPoint;
              //����� ����� ������� � ���

      property Samples:TMemoryStream read  FSamples;

      function NextSamples:Boolean;
      //��������� ��������� ������ ����� �� �����
      procedure LoadFromFile(Const FileName:String);
      constructor Create;
      destructor Destroy; override;
    end;


implementation

uses math;
{ TPCMWaveFile }

procedure TPCMWaveFile.SetCountFFTPoint(const AValue: Word);
begin
  if FCountFFTPoint=AValue then exit;
  FCountFFTPoint:=AValue;
end;

function TPCMWaveFile.NextSamples: Boolean;
var
   CountSamples:Int64; //����� ������� � ������� _8BitsSamples.._32BitsSamples
begin
  Result:=False;

    If  (WaveFile=Nil) or (FIdError<>0) then exit;

    //CountSamples - ������ ������� �������� �� ������������ ����
    CountSamples:=WaveFile.Size-WaveFile.Seek(0, soFromCurrent);

    //��������� ���-�� ���� � ����� �������
    CountSamples:=CountSamples div (BitsPerSample div 8);

    if CountSamples < CountFFTPoint*Channels then exit;
    //����� �����, �� ����� �������������

    CountSamples:=Min(CountSamples,MaxBlock*CountFFTPoint*Channels);


    Case BitsPerSample of
    1..8: begin
            SetLength(F_8BitsSamples,CountSamples);
            //�������� ������ ��� ������
            WaveFile.ReadBuffer(F_8BitsSamples[0],CountSamples);
            //�������� ������ � ������
            Result:=True;
            Exit;
          end;
    9..16: begin
            SetLength(F_16BitsSamples,CountSamples);
            //�������� ������ ��� ������
            WaveFile.ReadBuffer(F_16BitsSamples[0],CountSamples*2);
            //�������� ������ � ������
            Result:=True;
            Exit;
           end;
   17..24: begin
            SetLength(F_24BitsSamples,CountSamples);
            //�������� ������ ��� ������
            WaveFile.ReadBuffer(F_24BitsSamples[0],CountSamples*3);
            //�������� ������ � ������
            Result:=True;
            Exit;
           end;
   25..32: begin
            SetLength(F_32BitsSamples,CountSamples);
            //�������� ������ ��� ������
            WaveFile.ReadBuffer(F_32BitsSamples[0],CountSamples*4);
            //�������� ������ � ������
            Result:=True;
            Exit;
           end;
    else
          begin
            F_8BitsSamples  :=nil;
            F_16BitsSamples :=nil;
            F_24BitsSamples :=nil;
            F_32BitsSamples :=nil;
          end;
    end;//Case BitsPerSample of
end;

procedure TPCMWaveFile.LoadFromFile(const FileName: String);
var
  wFileSize     : Cardinal;
  wChankSize    : Cardinal;
  ID            : array[0..3] of Char;
  Header        : TWaveHeaderChank;
  RealFileSize  : Cardinal;
  h:Integer;
begin

  FSamples.Clear;

  FIdError:=FileDontFound;
  if not FileExists(FileName) then exit; //����� ��� �������

   Try
     WaveFile := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
     WaveFile.Seek(0, soFromBeginning);  //� ������ �����

     WaveFile.ReadBuffer(ID[0], 4);      //������ ��� �����
    if String(ID) <> 'RIFF' then  //���������� ��� �����
      begin
      FIdError:=IncorectFileFormat; //���� �� ���������
      FreeAndNil(WaveFile);
      Exit;
      end;

      WaveFile.ReadBuffer(wFileSize, 4);   //������ ������ �����
      FFileSize:=wFileSize;

    if WaveFile.size <> (wFileSize + 8) then
    //���������� ������������ ���������� �������
     begin
     //� ������� �����(�� ������ ���� ��� ���������)
      FIdError:=IncorectFileFormat;   //���� �� ���������
      FreeAndNil(WaveFile);
      Exit;
      end;

      WaveFile.ReadBuffer(ID[0], 4);
      //������ ��������� Id ������� ��� ��� 'WAVE'
    if String(ID) <> 'WAVE' then //���������� ������ �����
      begin
        FIdError:=IncorectFileFormat;  //���� �� ���������
        FreeAndNil(WaveFile);
        Exit;
      end;

    wChankSize := 0;
    repeat                              //���� ���� �������
      WaveFile.Seek(wChankSize, soFromCurrent);
      //���������� ��� �������������� �����
      WaveFile.ReadBuffer(ID[0], 4);           //������ ������������� �����
      WaveFile.ReadBuffer(wChankSize, 4);      //������ ������ �����

      if wChankSize > High(integer) then
      //��������� ������ �������� �� ����������
        begin
          FIdError:=DataError;
          FreeAndNil(WaveFile);
          exit;
        end;

    until (String(ID)='fmt ') or (String(ID)='data');

    if String(ID)='data' then    //��������� ������ �� ��������� �������
      begin
        FIdError:=HeaderError;
        //������ �.� ������ ���� �����  String(ID)='fmt '
        FreeAndNil(WaveFile);
        Exit;
      end;

      //������ ��������� ������ ����� ���������
      WaveFile.ReadBuffer(Header, Min(wChankSize, SizeOf(TWaveHeaderChank)));

      FFormatTag     :=Header.wFormatTag;
      FChannels      :=Header.wChannels;
      FSamplesPerSec :=Header.wSamplesPerSec;
      FBlockAlign    :=Header.wBlockAlign;
      FBitsPerSample :=Header.wBitsPerSample;


    //������� ��������� ������ � ����� �����
    //����� ������ ��� ������� ����������
    if wChankSize > SizeOf(TWaveHeaderChank) then
      WaveFile.Seek(wChankSize - SizeOf(TWaveHeaderChank), soFromCurrent);

     wChankSize := 0;
     repeat                              //���� ���� ������
       WaveFile.Seek(wChankSize, soFromCurrent);
       //���������� ��� �������������� �����
       WaveFile.ReadBuffer(ID[0], 4);
       //������ ������������� �����
       WaveFile.ReadBuffer(wChankSize, 4);
       //������  ������ �����
     until  String(ID)='data';

       if String(ID)='data' then
         begin
          FIdError:=NoError;
          FSamples.CopyFrom(WaveFile,wChankSize);
          FSamples.Seek(0,soFromBeginning);
         end;



   except

    end;
 end;

constructor TPCMWaveFile.Create;
begin
  F_8BitsSamples  :=nil;
  F_16BitsSamples :=nil;
  F_24BitsSamples :=nil;
  F_32BitsSamples :=nil;

  FIdError := NoError;
  FFileSize:= 0;
  FSamples  := TMemoryStream.Create;
  //WaveFile := TFileStream.Create;
end;

destructor TPCMWaveFile.Destroy;
begin
  F_8BitsSamples  :=nil;
  F_16BitsSamples :=nil;
  F_24BitsSamples :=nil;
  F_32BitsSamples :=nil;

  FAvgBytesPerSec:=0;
  FFileSize      :=0;
  FSamplesPerSec :=0;
  FBlockAlign    :=0;
  FChannels      :=0;
  FBitsPerSample :=0;
  FFormatTag     :=0;
  FIdError       :=0;

  {FreeAndNil(WaveFile)};
  FreeAndNil(WaveFile);
  FreeAndNil(FSamples);
  inherited Destroy;
end;

end.

