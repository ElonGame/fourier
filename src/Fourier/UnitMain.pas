unit UnitMain;
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ModuleFFT,ModuleComplex,ModuleWAV, StdCtrls, ExtCtrls, TeEngine,
  Series, TeeProcs, Chart,Math, ComCtrls, cmpBarControl, cmpPianoRoll,
  cmpKeyboard, cmpMidiData,mmsystem, Menus, Grids, MPlayer,
  Buttons, ToolWin,IniFiles,UnitAbout;
const
      tempos:array[1..9] of byte=
        (44,50,55,60,90,105,120,175,200);
      notes_name:array[1..12]of string=
      ('C','C#','D','D#','E','F','F#','G','G#','A','B','H');
      default_freq:array[1..12]of double=
      (261.63,277.18,293.66,311.13,329.63,349.23,
        369.99,392.00,415.30,440.00,466.16,493.88);
      octaves:array [1..10] of string=
    ('��������', '�����' ,'������� ','����� ',
      '1-� ','2-� ','3-� ','4-� ','5-� ','6-� ');
      rus_names:array[1..12] of string=
    ('��', '�� ����', '��', '�� ����', '��', '��',
    '�� ����', '����', '���� ����', '��', '�� ������', '��');
      Instruments:array [0..127] of String=(
'AcousticGrandPiano','BrightAcousticPiano','ElectricGrandPiano',
'HonkyTonkPiano','ElectricPiano1','ElectricPiano2','Harpsichord','Clavinet',
'Celesta','Glockenspiel','MusicBox','Vibraphone','Marimba','Xylophone',
'TubularBells','Dulcimer',
'DrawbarOrgan','PercussiveOrgan','RockOrgan','ChurchOrgan',
'ReedOrgan','Accordion','Harmonica','TangoAccordion',
'AcousticNylonGuitar','AcousticSteelGuitar','JazzElectricGuitar',
'CleanElectricGuitar','MutedElectricGuitar','OverdrivenGuitar',
'DistortionGuitar','GuitarHarmonics','AcousticBass',
'FingeredElectricBass','PickedElectricBass','FretlessBass',
'SlapBass1','SlapBass2','SynthBass1','SynthBass2',
'Violin','Viola','Cello','Contrabass',
'TremoloStrings','PizzicatoStrings','OrchestralHarp','Timpani',
'StringEnsemble1','StringEnsemble2','SynthStrings1',
'SynthStrings2','ChoirAahs','VoiceOohs','SynthVoice','OrchestraHit',
'Trumpet','Trombone','Tuba','MutedTrumpet','FrenchHorn',
'BrassSection','SynthBrass1','SynthBrass2',
'SopranoSax','AltoSax','TenorSax','BaritoneSax',
'Oboe','EnglishHorn','Bassoon','Clarinet',
'Piccolo','Flute','Recorder','PanFlute','BlownBottle',
'Shakuhachi','Whistle','Ocarina',
'SquareLead','SawtoothLead','CalliopeLead','ChiffLead',
'CharangLead','VoiceLead','FifthsLead','BassandLead',
'NewAgePad','WarmPad','PolySynthPad','ChoirPad',
'BowedPad','MetallicPad','HaloPad','SweepPad',
'SynthFXRain','SynthFXSoundtrack','SynthFXCrystal','SynthFXAtmosphere',
'SynthFXBrightness','SynthFXGoblins','SynthFXEchoes','SynthFXSciFi',
'Sitar','Banjo','Shamisen','Koto','Kalimba',
'Bagpipe','Fiddle','Shanai',
'TinkleBell','Agogo','SteelDrums','Woodblock',
'TaikoDrum','MelodicTom','SynthDrum','ReverseCymbal',
'GuitarFretNoise','BreathNoise','Seashore','BirdTweet',
'TelephoneRing','Helicopter','Applause','Gunshot');

type
  TFreqArray=array [1..12] of Double;
  TInstrSet=set of 0..127;
  TMyForm =class (Tform)
    clbSpectum: TColorBox;//���� �������
    chkWaveform: TCheckBox; //�������� ������ �����
    chkListSpectr: TCheckBox; //������������ �������������
    chkAutosave: TCheckBox; //��������������
    clbWaveform: TColorBox; //���� �������� �����
    edtWavPoints: TEdit;  //���������� ����� �������
    rgWindowFuncs: TRadioGroup; //������� �������
    cbxFFTCount: TComboBox;   //���������� ���
    cbxInstruments: TComboBox; //����������
    cbxTempo: TComboBox;    //����
    procedure update_instruments;
    public
    notes_freq:TFreqArray;
    instr:TInstrSet;
  end;
  TForm1 = class(TMyForm)
    MidiData: TMidiData;//������ MIDI
    MainMenu: TMainMenu;//����
    N1: TMenuItem; //����� ����
    N2: TMenuItem; //����� ����
    odgWaveOpen: TOpenDialog;//������ �������� �����
    WAV1: TMenuItem; //����� ����
    Timer1: TTimer;  //������
    grpWAV: TGroupBox; //������ ���������
    btnWavSel: TBitBtn; //������ ������ ������
    stWavName: TStaticText; //��� �����
    Label2: TLabel; //�������
    Label3: TLabel; //�������
    Label4: TLabel; //�������
    Label11: TLabel; //�������
    chtWaveform: TChart; // ������ �������� �����
    Label1: TLabel;  // �������
    grpAnalyze: TGroupBox; //������ ���������� �������
    PianoRoll: TPianoRoll; //����������
    MIDIKeys: TMIDIKeys;  //��������
    Bevel1: TBevel;      // �������
    stMidiName: TStaticText; //��� �����
    btnMidiSel: TBitBtn;   //������ ������ �����
    grpMIDI: TGroupBox;   //������ ����������
    chtSpectrum: TChart;  //������������
    Series1: TBarSeries;  //������ �������������
    btnAnalyze: TBitBtn;  //������ �������
    Label13: TLabel;     //�������
    stFocusedNote: TLabel; //������� ����
    Bevel2: TBevel;       //�����
    Label14: TLabel;    //�������
    trkSpectrum: TTrackBar; //�������� �������������
    trkMinAmp: TTrackBar;  //�������� ���������
    Label12: TLabel;   //�������
    btnFindNotes: TBitBtn;  //������ ������ ���
    sdgMidiSave: TSaveDialog; //���������� �����
    Label15: TLabel;   //�������
    btnSaveMidi: TBitBtn;      //���������� �����
    Label18: TLabel;  //�������
    MediaPlayer: TMediaPlayer;   //�������������
    trkMPlayer: TTrackBar;     // �������� �������������
    Label9: TLabel;  //�������
    Label5: TLabel;  //�������
    Label6: TLabel;  //�������
    N3: TMenuItem; //����� ����
    N4: TMenuItem;  //����� ����
    MIDI1: TMenuItem; //����� ����
    MIDI2: TMenuItem; //����� ����
    N5: TMenuItem;  //����� ����
    N6: TMenuItem;  //����� ����
    N7: TMenuItem;  //����� ����
    N8: TMenuItem;  //����� ����
    N9: TMenuItem;  //����� ����
    N10: TMenuItem; //����� ����
    N11: TMenuItem;     //����� ����
    N12: TMenuItem;     //����� ����
    N13: TMenuItem;     //����� ����
    Series2: TFastLineSeries; //������ ������� �������� �����
    Label7: TLabel;           //�������
    sdgIniSave: TSaveDialog;   //���������� ��������
    odgIniOpen: TOpenDialog;   //�������� ��������
    N15: TMenuItem;            //����� ����
    MIDI3: TMenuItem;          //����� ����
    Label8: TLabel;             //�������

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure trkSpectrumChange(Sender: TObject);
    procedure trkMinAmpChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WAV1Click(Sender: TObject);
    procedure PianoRollScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure PianoRollFocus(Sender: TObject);
    procedure PianoRollMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PianoRollMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MediaPlayerNotify(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MediaPlayerPostClick(Sender: TObject; Button: TMPBtnType);
    procedure OpenWAVE(const filename:string);
    procedure DrawWaveform(pcount:cardinal);
    procedure btnWavSelClick(Sender: TObject);
    procedure chkWaveformClick(Sender: TObject);
    procedure clbWaveformChange(Sender: TObject);
    procedure trkMPlayerChange(Sender: TObject);
    procedure btnAnalyzeClick(Sender: TObject);
    procedure FreeFourier;
    procedure FreeWAV;
    procedure FreeMidi;
    procedure btnFindNotesClick(Sender: TObject);
    procedure btnMidiSelClick(Sender: TObject);
    procedure btnSaveMidiClick(Sender: TObject);
    procedure cbxInstrumentsSelect(Sender: TObject);
    procedure chkAutosaveClick(Sender: TObject);
    procedure cbxFFTCountChange(Sender: TObject);
    procedure clbSpectumSelect(Sender: TObject);
    procedure rgWindowFuncsClick(Sender: TObject);
    procedure edtWavPointsKeyPress(Sender: TObject; var Key: Char);
    procedure MIDI1Click(Sender: TObject);
    procedure MIDI2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure MIDI3Click(Sender: TObject);
    procedure edtWavPointsExit(Sender: TObject);
    procedure UpdateWaveForm;
    procedure UpdateOptions;
    procedure cbxInstrumentsChange(Sender: TObject);
    procedure cbxTempoChange(Sender: TObject);
    procedure MIDIKeysNoteOn(Sender: TObject; var note,
      velocity: Integer);
    procedure MIDIKeysNoteOff(Sender: TObject; var note,
      velocity: Integer);
    procedure N15Click(Sender: TObject);

  private
    { Private declarations }
    PlayingNote:integer;
  public
    { Public declarations }
   // procedure Notify (tp : TActiveFormNotify); override;
  end;
var
  MidiPort,MidiStatus:Integer;  //���� MIDI � ������ ��� ��������
  instr_indexes:array of byte; //������� ������������ ������������ MIDI
  //���������� ����� ��� ���������� ������� �������� �����
  pcount:integer =250;
  UsedWindow:byte=2; //������ ������������ ������� �������
  FCount:Integer       = 2*4096; //���������� ����� ��� ��������������
  //���������� ����� ��� �������������� ����� 1
  FCount_1:Integer     = 2*4096-1;
  FCountDiv2:Integer   = (2*4096 div 2); //�������� ����� ��� ��������������
  //�������� ����� ��� �������������� ����� 1
  FCountDiv2_1:Integer = (2*4096 div 2)-1;
  norm:Double      =  1/(2*4096); // ����������� ��������� ���������
  MaxAmplitude:Double;  //������������ ��������� ����� ��������
  Eps:Double;    //����������� ����������� ��������� ���������
  UpdateTrack:Boolean=true;  //���� ���������� �������� �������������
  AnalyzeComplete:Boolean=false; //���� ���������� �������������
  WaveLoaded:Boolean=false;   //���� ��������� WAV-�����
  MidiCreated:Boolean=false;  //���� �������� MIDI-������
  MidiSaved:Boolean=false;   //���� ���������� MIDI-������
  Form1: TForm1;       //����� ���������
  WavPCM      : TPCMWaveFile;  //WAV-����
  Fourier     : array of TCmxArray;  //������ ��������


implementation
{$R *.dfm}
uses cmpMidiIterator,unitMidiGlobals,UnitSettings;
procedure TForm1.UpdateOptions;
var midimsg:integer;
var pkey:char;
begin
  if Form2.NeedUpdate then begin
    btnAnalyzeclick(btnAnalyze);
    btnFindNotesclick(btnFindNotes);
    clbSpectumSelect(clbSpectum);
    clbWaveformChange(clbWaveform);
    update_instruments;
    cbxInstrumentsSelect(cbxInstruments);
    cbxFFTCountChange(cbxFFTCount);
    chkAutosaveClick(chkAutosave);
    pkey:=#13;
    edtWavPointsKeyPress(edtWavPoints,pkey);
  end;
  if MidiStatus=MMSYSERR_NOERROR then begin
  Midimsg:=$C0 + (instr_indexes [ cbxInstruments.ItemIndex] *$100);
  midiOutShortMsg (midiport, midimsg);
end;
end;
procedure TMyForm.update_instruments;
var i:byte;  temp:integer;
begin
  temp:=cbxInstruments.ItemIndex;
  cbxInstruments.Items.Clear;
  setlength(instr_indexes,0);
  for i:=0 to 127 do
    if i in instr then begin
       setlength(instr_indexes,length(instr_indexes)+1);
       instr_indexes[high( instr_indexes)]:=i;
       cbxInstruments.Items.Add(instruments[i]);
    end;
  if temp<cbxInstruments.Items.Count then
    cbxInstruments.ItemIndex:=temp
  else
    cbxInstruments.ItemIndex:=0;
end;

procedure TForm1.UpdateWaveForm;
var key:char;
begin
  key:=#13;
  edtWavPointsKeyPress(edtWavPoints,key);
end;
procedure TForm1.N12Click(Sender: TObject);
var settings:TMemIniFile;   pkey:char;
begin
if odgIniOpen.Execute then begin
  settings:=TMemIniFile.Create(odgIniOpen.FileName);
  LoadSettings(form1,settings);
  FreeAndNil(settings);
  btnAnalyzeclick(btnAnalyze);
    btnFindNotesclick(btnFindNotes);
    clbSpectumSelect(clbSpectum);
    clbWaveformChange(clbWaveform);
    cbxInstrumentsSelect(cbxInstruments);
    chkAutosaveClick(chkAutosave);
    pkey:=#13;
    edtWavPointsKeyPress(edtWavPoints,pkey);
end;
end;
procedure TForm1.FreeMidi;
begin
  FreeAndNil(MidiData);
  PianoRoll.MidiData:=nil;
  PianoRoll.Repaint;
  MidiCreated:=false;
  MidiSaved:=false;
end;

procedure TForm1.FreeWAV;
begin
if WavPCM<>NIL then
    FreeAndNil(WavPCM);
WaveLoaded:=False;
    UpdateTrack:=false;
    trkMPlayer.Max:=0;
    label11.Caption:='������: N/A';
    label4.Caption:='�����������: N/A';
    label3.Caption:='������: N/A';
    label2.Caption:='������: N/A';
    label11.Font.Color:=clBlack;
    label2.Font.Color:=clBlack;
    label3.Font.Color:=clBlack;
    label4.Font.Color:=clBlack;
    btnAnalyze.Kind:=bkCancel; btnAnalyze.Enabled:=False;
    btnAnalyze.Caption:='�������������';
    btnAnalyze.Cancel:=false;
end;

procedure TForm1.FreeFourier;
var i:cardinal;
begin
  MaxAmplitude:=0;
  label5.Caption:='0';
  trkMinAmp.Min:=0;
  Label18.Caption:='0';
  Series1.Clear;
AnalyzeComplete:=false;
    btnFindNotes.Enabled:=false;
    btnFindNotes.Kind:=bkCancel;
    btnFindNotes.Caption:='����� ���';
    btnFindNotes.Cancel:=false;
if length(fourier)<>0 then
    for i:=0 to high(fourier) do
      fourier[i]:=nil;
  fourier:=nil;
  trkSpectrum.Max:=0;;
end;
procedure TForm1.OpenWAVE(const filename:string);
begin
 stWavName.Caption:=filename;
  if MediaPlayer.filename<>'' then begin
    MediaPlayer.Close;
    MediaPlayer.FileName:='';
  end;
  FreeFourier;
  FreeWAV;
  WavPCM:= TPCMWaveFile.Create;
  WavPCM.LoadFromFile(filename);
   if WavPCM.IdError<>NoError then
       begin
         Label2.caption:='������: �� RIFF WAV';
         Label2.Font.Color:=clRed;
       end
   else
     begin
         Label2.caption:='������: RIFF WAV';
         Label2.Font.Color:=clGreen;
   label3.Caption:='������: '+inttostr(WavPCM.Channels);
   if WavPCM.Channels<>1 then
          Label3.Font.Color:=clRed
   else
          Label3.Font.Color:=clGreen;

   label4.Caption:='�����������: '+ inttostr(WavPCM.BitsPerSample);
   if WavPCM.BitsPerSample<>16 then
       Label4.Font.Color:=clRed
   else
       Label4.Font.Color:=clGreen;
   end;
   if (label2.Font.Color=clGreen)and (label3.Font.Color=clGreen)
      and (label4.Font.Color=clGreen)
   then begin
      WaveLoaded:=True;
      label11.Caption:='������: �������� ��� �������';
      label11.Font.Color:=clGreen;
      Label7.Caption:='/'+inttostr(wavpcm.Samples.Size div 2);
      btnAnalyze.Kind:=bkOK; btnAnalyze.Enabled:=True;
      btnAnalyze.Caption:='�������������';
      btnAnalyze.Default:=false;
      MediaPlayer.FileName:=filename;
      MediaPlayer.Open;
      if chkWaveform.Checked then
        UpdateWaveform;
   end else begin
    WaveLoaded:=False;
    label11.Caption:='������: �� �������� ��� �������';
    label11.Font.Color:=clRed;
   end;
end;

procedure TForm1.DrawWaveform(pcount:cardinal);
var i,h:cardinal; sample:smallint; pos:cardinal;
begin
  if WaveLoaded and (pcount>1) then begin
  Series2.SeriesColor:=clbWaveform.Selected;
  Series2.Clear;
  pos:=WavPCM.Samples.Position;
  WavPcm.Samples.Seek(0,soFromBeginning);
  i:=1;
  h:=(WavPCM.Samples.Size)div (2*(pcount-1));
  if h<=1 then h:=1 else h:=h-1;
  while i+h<=(WavPCM.Samples.Size)div 2 do begin
    Wavpcm.Samples.Read(sample,2);
    WavPcm.Samples.Seek((h-1)*2,soCurrent);
    Series2.AddXY((i-1)/3600/24/WavPCM.SamplesPerSec, sample );
    i:=i+h;
  end;
  Wavpcm.Samples.Seek(-1,soEnd);
  Wavpcm.Samples.Read(sample,2);
    Series2.AddXY((i-1)/3600/24/WavPCM.SamplesPerSec, sample );
  WavPCM.Samples.Seek(pos,soFromBeginning);
  end;
  chtWaveform.Refresh;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
  FreeandNil(WavPCM);
  for i:=0 to high(Fourier) do
    fourier[i]:=nil;
  fourier:=nil;

end;

procedure TForm1.trkSpectrumChange(Sender: TObject);
var i:cardinal;
begin
  if AnalyzeComplete then begin
    Series1.Clear;
    for i:=0 to FCountdiv2-1 do
      Series1.AddXY(i*WavPCM.SamplesPerSec/FCount_1,
      fourier[trkSpectrum.Position][i].Re);
   end;
end;

procedure TForm1.trkMinAmpChange(Sender: TObject);
begin
  if trkMinAmp.Min<>0 then
   Label18.Caption:=inttostr(round(trkMinAmp.Position/
                                    trkMinAmp.Min*MaxAmplitude));
end;

procedure TForm1.FormCreate(Sender: TObject);
var Settings:TMemIniFile;
begin
MIDISTATUS:=midiOutOpen(@MIDIPort,MIDI_MAPPER,0,0,0);
MIDIKeys.MIDIPort:=Midiport;
MIDIKeys.MIDIPortOk:=Midistatus=MMSYSERR_NOERROR;
MediaPlayer.TimeFormat:=tfMilliseconds;
MediaPlayer.Notify:=true;
PlayingNote:=-1;
MIDIKeys.BaseOctave:=11-PianoRoll.VertScrollBar.Position;

 PianoRoll.MidiData:=MidiData;
 Settings:=TMemIniFile.Create('config.ini');
 LoadSettings(form1,settings);
 update_instruments;
end;
procedure TForm1.PianoRollFocus(Sender: TObject);
var
 noteOnEvent : PMidiEventData;
begin
  inherited;
  with PianoRoll do
    GetFocusedNote (noteOnEvent);

  if Assigned (noteOnEvent) and Assigned (noteOnEvent.OnOffEvent) then
  begin
    stFocusedNote.Caption := GetNoteName (noteonevent.data.b2)

  end
  else
  begin
    stFocusedNote.Caption := '---';
  end
end;
procedure TForm1.WAV1Click(Sender: TObject);
begin
 if odgWaveOpen.Execute then
 begin
    openWaVe(odgWaveOpen.FileName);
 end;
end;

procedure TForm1.PianoRollScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
inherited;
  MIDIKeys.BaseOctave:=11-ScrollPos;
end;


procedure TForm1.PianoRollMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if PlayingNote<>-1 then begin
    MIDIKeys.ReleaseNote (PlayingNote, 0, True);
    PlayingNote:=-1;
  end;
end;

procedure TForm1.PianoRollMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var   noteOnEvent : PMidiEventData;
begin
  with PianoRoll do if Assigned(MidiData) then  begin
    GetFocusedNote(noteonEvent);
    if noteonevent<>NIL then begin
      MIDIKeys.PressNote (Noteonevent^.data.b2,Noteonevent^.data.b3, True);
      playingNote:= Noteonevent^.data.b2;
    end;
  end;
end;

procedure TForm1.MediaPlayerNotify(Sender: TObject);
begin
  MediaPlayer.Notify:=true;
  MediaPlayer.AutoEnable:=True;
  if MediaPlayer.Mode=mpPlaying then begin
    trkMPlayer.Max:=MediaPlayer.Length;
    UpdateTrack:=false;
    trkMPlayer.Position:=MediaPlayer.Position;
    if chkListSpectr.Checked And AnalyzeComplete then
      trkSpectrum.Position:=round(WavPCM.SamplesPerSec/
                                  1000*MediaPlayer.Position)
                                    div FCount;
    if MediaPlayer.Position=MediaPlayer.Length then begin
      MediaPlayer.Notify:=true;
      MediaPlayer.Stop;
    end else
      Timer1.Enabled:=true;
  end
  else begin
   if (MediaPlayer.Mode=mpPaused) and
        (MediaPlayer.NotifyValue=nvSuccessful) then begin
       MediaPlayer.AutoEnable:=False;
       MediaPlayer.EnabledButtons:=MediaPlayer.EnabledButtons+[btPlay];
   end;
   if  (MediaPlayer.Mode=mpStopped) then
    if (MediaPlayer.NotifyValue=nvSuccessful) then begin
      trkMPlayer.Position:=0;
    end else MediaPlayer.Notify:=false;
    Timer1.Enabled:=False;
   end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  UpdateTrack:=false;
  if MediaPlayer.Mode=mpPlaying then begin

      trkMPlayer.Position:=MediaPlayer.Position;
    if chkListSpectr.Checked And AnalyzeComplete then
      trkSpectrum.Position:=round(WavPCM.SamplesPerSec/
                                    1000*MediaPlayer.Position)
                                  div FCount;
    Timer1.Enabled:=true;
  end else
  if MediaPlayer.Mode=mpStopped then begin
      UpdateTrack:=False;
      trkMPlayer.Position:=0;
      if chkListSpectr.Checked And AnalyzeComplete then
        trkSpectrum.Position:=0;
   end;

end;

procedure TForm1.MediaPlayerPostClick(Sender: TObject;
  Button: TMPBtnType);
begin
  MediaPlayer.AutoEnable:=true;
  if Button=btPlay then begin

    trkMPlayer.Max:=MediaPlayer.Length;
    UpdateTrack:=false;
    MediaPlayer.Position:=trkMPlayer.Position;
    if chkListSpectr.Checked And AnalyzeComplete then
      trkSpectrum.Position:=round(WavPCM.SamplesPerSec/
                                      1000*MediaPlayer.Position)
                                  div FCount;
    MediaPlayer.Notify:=true;
    Timer1.Enabled:=true;
    MediaPlayer.Play;
  end else begin
    if button=btStop then begin
      MediaPlayer.Stop;
      MediaPlayer.Position:=0;
      UpdateTrack:=false;
      trkMPlayer.Position:=0;
      if chkListSpectr.Checked And AnalyzeComplete then
        trkSpectrum.Position:=0;
    end;
    If button=btStep then
      trkMPlayer.Position:=trkMPlayer.Position+trkMPlayer.Max div 100;
    if button=btBack then
      trkMPlayer.Position:=trkMPlayer.Position-trkMPlayer.Max div 100;
    Timer1.Enabled:=False;
  end;
end;

procedure TForm1.btnWavSelClick(Sender: TObject);
begin
 if odgWaveOpen.Execute then
 begin
    openWaVe(odgWaveOpen.FileName);
 end;
end;

procedure TForm1.chkWaveformClick(Sender: TObject);
begin
  If chkWaveform.Checked then
    DrawWaveform(pcount)
  else
    Series2.Clear;
end;

procedure TForm1.clbWaveformChange(Sender: TObject);
begin
  Series2.SeriesColor:=clbWaveform.Selected;
end;

procedure TForm1.trkMPlayerChange(Sender: TObject);
begin
  if waveloaded and updateTrack then begin
    MediaPlayer.PauseOnly;
    //MediaPlayer.Position:=trkMPlayer.Position;
    //MediaPlayer.Play;
  end else updatetrack:=true;
end;

procedure TForm1.btnAnalyzeClick(Sender: TObject);
var i,t:cardinal;
  TempSamples  : T16BitsPerSample;
  ExpTable    : TCmxArray;
  IndexTable : TIndexArray;
  LeftAxis:TChartAxis;
  pos:int64;
begin
IndexTable:=nil;ExpTable:=nil;TempSamples:=nil;
if WaveLoaded then begin
try
  t:=0;
  FreeFourier;
  SetLength(TempSamples,FCount);
  ExpTable:=GetFFTExpTable(FCount);
  IndexTable:=GetArrayIndex(FCount);
  pos:=WavPCM.Samples.Position;
  WavPcm.Samples.Seek(0,soBeginning);
  While  (WavPCM.Samples.Size- WavPCM.Samples.Position)>FCount*2  do
     begin
         WavPCM.Samples.ReadBuffer(TempSamples[0],FCount*2);
          setlength(fourier,t+1);
          setlength(fourier[t],FCount);
          for I:=0 to FCount_1 do begin
              UsedWindow:= 0;
              case rgWindowFuncs.ItemIndex of
              1:TempSamples[i]:=round(HannWindow(I,FCount)*TempSamples[i]);
              2:TempSamples[i]:=round(HammingWindow(I,FCount)*TempSamples[i]);
              3:TempSamples[i]:=round(BlackmanWindow(I,FCount)*TempSamples[i]);
              else TempSamples[i]:=round(TempSamples[i]);
              end;

              fourier[t][I].Re:=TempSamples[IndexTable[I]];
              fourier[t][I].Im:=0;
          end;
         FFT(fourier[t],ExpTable);
         fourier[t][0].Re:=0;
         for i:=1 to FCountdiv2_1 do begin
             fourier[t][i].Re:=sqrt(fourier[t][i].Re*fourier[t][i].Re+
                                  fourier[t][i].Im*fourier[t][i].Im)*norm*2;
             if maxAmplitude<fourier[t][i].Re then
               maxAmplitude:=fourier[t][i].Re;
         end;
         for i:=FCountdiv2 to FCount_1 do
             fourier[t][i].Re:=0;
         inc(t);
      end;
    WavPCM.Samples.Seek(pos,soBeginning);
    ExpTable    :=Nil;
    IndexTable :=Nil;
    TempSamples  :=Nil;
    AnalyzeComplete:=True;
    btnFindNotes.Enabled:=true;
    btnFindNotes.Kind:=bkOK;
    btnFindNotes.Caption:='����� ���';
    btnFindNotes.Default:=false;
    leftaxis:=Series1.GetVertAxis;
    leftaxis.Maximum:=MaxAmplitude;
    label5.Caption:=inttostr(round(MaxAmplitude));
    if round(maxAmplitude)>maxint then
      trkMinAmp.Min:=-maxint
    else
      trkMinAmp.Min:=-round(MaxAmplitude);
    trkMinAmp.Position:=round(0.8*trkMinAmp.Min);
    trkSpectrum.Max:=High(fourier);
    trkSpectrumChange(self);
  except else
    AnalyzeComplete:=false;
    FreeFourier;
  end;
 end;
end;

procedure TForm1.btnFindNotesClick(Sender: TObject);
var i,j,k:integer;t:cardinal;
  channels:array of byte;
  data:TEventData;  note:byte;
  lg,ppqn:integer;
  tempo,ft:cardinal; head:array of byte; added:boolean;
begin
if analyzecomplete then try
  if MidiCreated and not MidiSaved then
    if MessageDlg('��������� �� ���������! ����������?',
                      mtWarning,mbOKCancel,0)<>1 then
      exit;
  t:=0;
  channels:=nil;

    FreeMidi;
    MidiData:=TMidiData.Create(Form1);
    MidiData.New;

  eps:=trkMinAmp.Position/trkMinAmp.Min*MaxAmplitude;
if MidiData.AddNewTrack(0)then  begin
  MidiData.Tracks[0].BeginUpdate;
  setlength(head,3);
  tempo:=round(60000000/tempos[cbxTempo.ItemIndex+1]);
  head[0]:=(tempo div $10000) mod $100;head[1]:=(tempo div $100) mod $100;
  head[2]:=tempo mod $100;
  tempo:=tempo div 1000;

  MidiData.Tracks[0].InsertMetaEvent(0,$51,pchar(head),3);
  lg:=trunc(log10(tempo/FCount*WavPCM.SamplesPerSec))-2;
  if abs(lg)<5 then begin
      PPQN:=trunc(tempo/(FCount_1/WavPCM.SamplesPerSec)*power(10,1-lg));
      MidiData.PPQN:=ppqn;
      ft:=round(power(10,4-lg));
  end else ft:=180;
  if length(fourier)>0 then
  for j:=-4 to 6 do   begin
       for k:=1 to 12 do
         if abs(fourier[t][round(notes_freq[k]*power(2,j-1)*FCount_1/
                    WavPCM.SamplesPerSec)].Re)>=eps then begin
              i:=length(channels);
              setlength(channels,i+1);
              data.status:=$90; data.b2:=(j+4)*12+(k-1); data.b3:=127;
              channels[i]:=data.b2;
              MidiData.Tracks[0].InsertEvent(t*ft,data,0);
            end;
  end;
  for t:=1 to high(fourier) do begin
     for j:=0 to high(channels) do
       if channels[j]<>$FF then begin
        note:=channels[j];
        if abs(fourier[t][round(notes_freq[(note mod 12)+1]*
                power(2,(note div 12) -5)*FCount_1/
                    WavPCM.SamplesPerSec)].Re)<eps then
            begin
              data.status:=$80; data.b2:=note; data.b3:=127;
              channels[j]:=$FF;
              MidiData.Tracks[0].InsertEvent(t*ft,data,0);
            end;
       end;
     for j:=-4 to 6 do
       for k:=1 to 12 do
         if abs(fourier[t][round(notes_freq[k]*power(2,j-1)*FCount_1/
                    WavPCM.SamplesPerSec)].Re)>=eps then begin
            added:=false;
            for i:=0 to high(channels) do
             if (channels[i]=$FF) or (channels[i]=(j+4)*12+(k-1)) then
              begin
              added:=true;
               if (channels[i]=(j+4)*12+(k-1)) then break;
              data.status:=$90; data.b2:=(j+4)*12+(k-1); data.b3:=127;
              channels[i]:=data.b2;
              MidiData.Tracks[0].InsertEvent(t*ft,data,0);
               break
             end;
            if not added then begin
              i:=length(channels);
              setlength(channels,i+1);
              data.status:=$90; data.b2:=(j+4)*12+(k-1); data.b3:=127;
              channels[i]:=data.b2;
              MidiData.Tracks[0].InsertEvent(t*ft,data,0);
            end;
     end;
  end;
  for j:=0 to high(channels) do
    if channels[j]<>$ff then begin
        note:=channels[j];
        data.status:=$80; data.b2:=note; data.b3:=127;
        channels[j]:=$FF;
        MidiData.Tracks[0].InsertEvent(high(fourier)*ft,data,0);
  end;
  channels:=nil;
  MidiData.Tracks[0].SetPatch(cbxInstruments.ItemIndex);
  MidiData.Tracks[0].EndUpdate;
  MidiCreated:=true;
  PianoRoll.MidiData:=MidiData;
  PianoRoll.Refresh;
  if chkAutosave.Checked and btnSaveMidi.Enabled then
   try
    MidiData.FileName:=stMidiName.Caption;
    MidiData.Save;
    MidiSaved:=true;
   except else
      MidiSaved:=false;
   end;
end;
except else
  channels:=nil;
  MidiSaved:=false;
  MidiCreated:=false;
  FreeMidi;
end;
end;

procedure TForm1.btnMidiSelClick(Sender: TObject);
begin
if sdgMidiSave.Execute then
 begin
    stMidiName.Caption:=sdgMidiSave.FileName;
    btnSaveMidi.Enabled:=true;
    if midicreated and not midisaved then
    try
      MidiData.FileName:=stMidiName.Caption;
      MidiData.Save;
      MidiSaved:=true;
    except else MidiSaved:=false;
    end;
 end;
end;

procedure TForm1.btnSaveMidiClick(Sender: TObject);
begin
  if midicreated then
  try
  MidiData.FileName:=stMidiName.Caption;
  MidiData.Save;
  MidiSaved:=true;
  except else MidiSaved:=false;
  end
  else MessageDlg('������� ��������� ������ � ����� ���!',
              mtInformation,[mbok],0);
end;

procedure TForm1.cbxInstrumentsSelect(Sender: TObject);
var midimsg:integer;
begin
if MidiStatus=MMSYSERR_NOERROR then begin
  Midimsg:=$C0 + (instr_indexes [ cbxInstruments.ItemIndex] *$100);
  midiOutShortMsg (midiport, midimsg);
  end;
if AnalyzeComplete and MidiCreated then begin
  MidiData.Tracks[0].BeginUpdate;
   MidiData.Tracks[0].SetPatch(instr_indexes[cbxInstruments.ItemIndex]);
  MidiData.Tracks[0].EndUpdate;
  PianoRoll.Update;
  PianoRoll.Repaint;
end;
end;

procedure TForm1.chkAutosaveClick(Sender: TObject);
begin
  if chkAutosave.Checked then
    btnSaveMidi.Visible:=false
  else
    btnSaveMidi.Visible:=true;
end;

procedure TForm1.cbxFFTCountChange(Sender: TObject);
var x:integer;
begin
  x:= 1 shl (cbxFFTCount.ItemIndex+10) ;
  if fcount<>x then begin
    
    FCount:= x;
    FCount_1:= FCount-1;
    FCountDiv2:= (FCount div 2);
    FCountDiv2_1:= (FCount div 2)-1;
    norm:=1/Fcount;

    if AnalyzeComplete then
      btnAnalyzeClick(btnAnalyze);
  end;
end;

procedure TForm1.clbSpectumSelect(Sender: TObject);
begin
  Series1.SeriesColor:=clbSpectum.Selected;
end;

procedure TForm1.rgWindowFuncsClick(Sender: TObject);
begin
  if (UsedWindow<>rgWindowFuncs.ItemIndex) and AnalyzeComplete then
    btnAnalyzeClick(btnAnalyze);
end;

procedure TForm1.edtWavPointsKeyPress(Sender: TObject; var Key: Char);
var x:integer;
begin
  x:=pcount;
  if (key<>#8) then
  try
    pcount:=strtoint(edtWavPoints.Text);
    if WaveLoaded then begin
      if pcount>wavpcm.Samples.size div 2 then begin
        pcount:=wavpcm.Samples.size div 2;
        edtWavPoints.text:=inttostr(pcount);
      end;
    if {(pcount<>x) and }chkWaveform.Checked then
      DrawWaveform(pcount);
    end;
  except else
    pcount:=x;
    edtWavPoints.text:=inttostr(x);
    edtWavPoints.SelStart:=length(edtWavPoints.Text);
  end;

end;

procedure TForm1.MIDI1Click(Sender: TObject);
begin
if midicreated then begin
if sdgMidiSave.Execute and midiCreated then
 if (stMidiName.Caption<>sdgMidiSave.FileName) or not MidiSaved then begin
    if stMidiName.Caption<>sdgMidiSave.FileName then
      stMidiName.Caption:=sdgMidiSave.FileName;
    btnSaveMidi.Enabled:=true;
  try
  MidiData.FileName:=stMidiName.Caption;
  MidiData.Save;
  MidiSaved:=true;
  except else MidiSaved:=false;
  end;
 end
end else MessageDlg('������� ��������� ������!',mtInformation,[mbok],0);
end;

procedure TForm1.MIDI2Click(Sender: TObject);
begin
if midicreated then begin
if sdgMidiSave.Execute and midiCreated then
  try
  MidiData.FileName:=sdgMidiSave.FileName;
  MidiData.Save;
  MidiSaved:=true;
  except else MidiSaved:=false;
  end;
end else MessageDlg('������� ��������� ������!',mtInformation,[mbok],0);
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  FreeAndNil(Form1);
  Application.Terminate;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeWav;
  FreeFourier;
  FreeMidi;
  instr_indexes:=nil;
  midioutClose(MidiPort);
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  Form2.PageControl1.TabIndex:=0;
  Form2.ShowModal;
  UpdateOptions;
end;

procedure TForm1.N8Click(Sender: TObject);

begin
  Form2.PageControl1.TabIndex:=1;
  Form2.ShowModal;
  UpdateOptions;
end;

procedure TForm1.N10Click(Sender: TObject);
var settings:TMemIniFile;
begin
if sdgIniSave.Execute then begin
  settings:=TMemIniFile.Create(sdgIniSave.FileName);
  SaveSettings(form1,settings);
  settings.UpdateFile;
  FreeAndNil(settings);
end;
end;

procedure TForm1.N11Click(Sender: TObject);
var settings:TMemIniFile;
begin
if sdgIniSave.Execute then begin
  settings:=TMemIniFile.Create(sdgIniSave.FileName);
  SaveSettings(form1,settings);
  settings.UpdateFile;
  FreeAndNil(settings);
end;
end;

procedure TForm1.N13Click(Sender: TObject);
begin
Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TForm1.MIDI3Click(Sender: TObject);
begin
Form2.PageControl1.TabIndex:=2;
  Form2.ShowModal;
  UpdateOptions;
end;

procedure TForm1.edtWavPointsExit(Sender: TObject);
var key:char;
begin
  key:=#13;
  edtWavPointsKeyPress(edtWavPoints,key);
end;

procedure TForm1.cbxInstrumentsChange(Sender: TObject);
begin
 cbxInstrumentsSelect(Sender);
end;

procedure TForm1.cbxTempoChange(Sender: TObject);
begin
  if MidiCreated then
    btnFindNotesClick(btnFindNotes);
end;






procedure TForm1.MIDIKeysNoteOn(Sender: TObject; var note,
  velocity: Integer);
begin
  stFocusedNote.Caption:=GetNoteName(note);
end;

procedure TForm1.MIDIKeysNoteOff(Sender: TObject; var note,
  velocity: Integer);
begin
  stFocusedNote.Caption:='';
end;

procedure TForm1.N15Click(Sender: TObject);
begin
  AboutDlg.ShowModal;
end;

end.


