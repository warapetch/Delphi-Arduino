unit frmMainU;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, CPortCtl, CPort, System.Types,
  Vcl.ExtCtrls;
type
  TfrmMain = class(TForm)
    lbStatus: TLabel;
    edtStatus: TEdit;
    ccbComPortList: TComComboBox;
    lbComPortList: TLabel;
    ComPort: TComPort;
    btnLedOn: TButton;
    btnLedOff: TButton;
    lbResponse: TLabel;
    memResponse: TMemo;
    tmrConnect: TTimer;
    btnDisconnect: TButton;
    btnConnect: TButton;
    mmLog: TMemo;
    procedure tmrConnectTimer(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure btnLedOnClick(Sender: TObject);
    procedure btnLedOffClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComPortBeforeOpen(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure ComPortAfterClose(Sender: TObject);
    procedure ComPortAfterOpen(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  private
    { Private declarations }
    LReadedStrAll : String;
    procedure addLog(value: String);
    procedure addStatus(value: String);
  public
    { Public declarations }
  end;
var
  frmMain: TfrmMain;

implementation
{$R *.dfm}

procedure TfrmMain.addLog(value : String);
begin
  var sTime := formatdatetime('HH:NN:SS',NOW);
  mmLog.Lines.Add(sTime+' '+value);
end;

procedure TfrmMain.addStatus(value : String);
begin
  var sTime := formatdatetime('HH:NN:SS',NOW);
  memResponse.Lines.Add(sTime+' '+value);
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
      addStatus('>> Try connect '+ccbComPortList.Text);
      ComPort.Open;  // ComPort.connect ed := True;
      ComPort.WriteStr('INIT');
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
    edtStatus.Text := 'Try Disconnect ...';
    addStatus('>> try Disconnect');
    ComPort.Connected := false;
end;

procedure TfrmMain.btnLedOffClick(Sender: TObject);
begin
  LReadedStrAll := '';
  addStatus('>> try LED_OFF');
  // Send string to arduino
  ComPort.WriteStr('LED_OFF');
end;

procedure TfrmMain.btnLedOnClick(Sender: TObject);
begin
  LReadedStrAll := '';
  addStatus('>> Try LED_ON');
  // Send string to arduino
  ComPort.WriteStr('LED_ON'); // LED_ON_01
end;

procedure TfrmMain.ComPortAfterClose(Sender: TObject);
begin
    edtStatus.Text := 'Not connected';
    btnLedOn.Enabled  := False;
    btnLedOff.Enabled := False;
    btnConnect.Enabled  := True;
    btnDisconnect.Enabled := False;
end;

procedure TfrmMain.ComPortAfterOpen(Sender: TObject);
begin
    edtStatus.Text := 'Connected';
    btnConnect.Enabled  := False;
    btnDisconnect.Enabled := True;
end;

procedure TfrmMain.ComPortBeforeOpen(Sender: TObject);
begin
    LReadedStrAll := '';
    edtStatus.Text := 'Not connected';
    btnLedOn.Enabled  := False;
    btnLedOff.Enabled := False;
end;

function findEnd_NewLine(Value : String) : Integer;
var
  I: Integer;
begin
    Result := -1;
    for I := 1 to Length(Value) do
        begin
           if (Value[I] = #13) OR (Value[I] = #$A) then
              begin
                Result := I;
                Break;
              end;
        end;
end;

procedure TfrmMain.ComPortRxChar(Sender: TObject; Count: Integer);
var
  LReadedStr: String;
  foundEnd_NewLine : Boolean;
begin
  // Read string from COM port
  ComPort.ReadStr(LReadedStr, Count);

  mmLog.Lines.Add(LReadedStr);
  if findEnd_NewLine(LReadedStr) > 0 then
     mmLog.Lines.Add('found #13 >> '+LReadedStr);

  // If string is not empty
  if LReadedStr <> '' then
  begin
    if findEnd_NewLine(LReadedStr) > 0 then // #$A == #13 == \n
       begin
          // READY#$A LED_ON = OK#$A
          var _str := LReadedStr;
          var _str1 : String;
          var _ifound : Integer;

          while findEnd_NewLine(_str) > 0 do
             begin
               _ifound := findEnd_NewLine(_str);
               _str1 := Copy(_str,1,_ifound-1);
               LReadedStrAll := LReadedStrAll + Trim(_str1);
               Delete(_str,1,_ifound);
             end;

          if (Trim(_str) <> '') then
            LReadedStrAll := LReadedStrAll +Trim(_str);

          foundEnd_NewLine := true;
       end
    else
    LReadedStrAll := LReadedStrAll +LReadedStr;

    // Check for status and enable buttons
    if Trim(LReadedStrAll) = 'READY' then
    begin
      btnLedOn.Enabled := True;
      btnLedOff.Enabled := True;
    end;

    // end of Response text
    if foundEnd_NewLine then
       begin
          // Add string to memo
          addStatus('<< '+LReadedStrAll);
          foundEnd_NewLine := false;
       end;

    // Move memo vertical scroll bar to end
    memResponse.ScrollBy(0, 99999);
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Close COM port on exit
  if ComPort.Connected then
     begin
         ComPort.Close;
         Application.ProcessMessages;
     end;

end;

procedure TfrmMain.FormDblClick(Sender: TObject);
begin
  ccbComPortList.Refresh;
end;

procedure TfrmMain.tmrConnectTimer(Sender: TObject);
begin
//  if not IsDebuggerPresent() then
//  begin
//    // In non debug mode use timer
//    // Try connect to COM port
//    if not ComPort.Connected then
//    begin
//      try
//        ComPort.Open;
//        ComPort.WriteStr('-');
//        edtStatus.Text := 'Connected';
//      except
//        edtStatus.Text := 'Not connected';
//        btnLedOn.Enabled := False;
//        btnLedOff.Enabled := False;
//      end;
//    end;
//  end;
end;

end.
