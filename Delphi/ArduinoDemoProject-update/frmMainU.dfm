object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ComPortArduino'
  ClientHeight = 417
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnDblClick = FormDblClick
  TextHeight = 13
  object lbStatus: TLabel
    Left = 8
    Top = 57
    Width = 31
    Height = 13
    Caption = 'Status'
  end
  object lbComPortList: TLabel
    Left = 8
    Top = 8
    Width = 82
    Height = 13
    Caption = 'Select COM port:'
  end
  object lbResponse: TLabel
    Left = 8
    Top = 152
    Width = 51
    Height = 13
    Caption = 'Response:'
  end
  object edtStatus: TEdit
    Left = 8
    Top = 73
    Width = 233
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 0
    Text = 'Not connected'
  end
  object ccbComPortList: TComComboBox
    Left = 8
    Top = 24
    Width = 113
    Height = 21
    ComPort = ComPort
    ComProperty = cpPort
    AutoApply = True
    Text = 'COM1'
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 1
  end
  object btnLedOn: TButton
    Left = 8
    Top = 104
    Width = 113
    Height = 41
    Caption = 'Turn Led On'
    Enabled = False
    TabOrder = 2
    OnClick = btnLedOnClick
  end
  object btnLedOff: TButton
    Left = 128
    Top = 104
    Width = 113
    Height = 41
    Caption = 'Turn Led Off'
    Enabled = False
    TabOrder = 3
    OnClick = btnLedOffClick
  end
  object memResponse: TMemo
    Left = 8
    Top = 168
    Width = 233
    Height = 89
    ReadOnly = True
    TabOrder = 4
  end
  object btnDisconnect: TButton
    Left = 166
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    Enabled = False
    TabOrder = 5
    OnClick = btnDisconnectClick
  end
  object btnConnect: TButton
    Left = 166
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 6
    OnClick = btnConnectClick
  end
  object mmLog: TMemo
    Left = 8
    Top = 263
    Width = 233
    Height = 146
    ReadOnly = True
    TabOrder = 7
  end
  object ComPort: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    DiscardNull = True
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = True
    OnAfterOpen = ComPortAfterOpen
    OnAfterClose = ComPortAfterClose
    OnBeforeOpen = ComPortBeforeOpen
    OnRxChar = ComPortRxChar
    Left = 192
    Top = 272
  end
  object tmrConnect: TTimer
    OnTimer = tmrConnectTimer
    Left = 192
    Top = 176
  end
end
