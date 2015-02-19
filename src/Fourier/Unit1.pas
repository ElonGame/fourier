unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ModuleComplex,ModuleFFT;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var fourier:TCmxArray; index:TIndexArray;fexp:TCmxArray; i:cardinal; t:TComplex;
begin
  setlength(fourier,8);
  fexp:=GetFFTExpTable(8); index:=GetArrayIndex(8);
   for i:=0 to 7 do begin
      fourier[i].Re:=index[i];
      Fourier[i].Im:=0
   end;
   FFT(fourier,fexp);
   for i:= 1 to 3 do begin
       t:=fourier[i];
       fourier[i]:=fourier[index[i]];
       fourier[index[i]]:=t;
   end;
   fexp:=GetFFTExpTable(8,True);
   FFT(fourier,fexp);
   for i:= 0 to 7 do begin
      fourier[i].RE:=fourier[i].Re/8;fourier[i].im:=fourier[i].im/8;
   end;
   for i:= 0 to 7 do
    Writeln(fourier[i].RE,fourier[i].im);

end;

end.
