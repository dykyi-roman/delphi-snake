object fSnake: TfSnake
  Left = 0
  Top = 0
  Caption = 'Snake'
  ClientHeight = 451
  ClientWidth = 387
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pbGrid: TPaintBox
    Left = 0
    Top = 0
    Width = 387
    Height = 432
    Align = alClient
    OnPaint = pbGridPaint
    ExplicitTop = -51
    ExplicitWidth = 333
    ExplicitHeight = 502
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 432
    Width = 387
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
    ExplicitLeft = 248
    ExplicitTop = 192
    ExplicitWidth = 0
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 24
    object Game1: TMenuItem
      Caption = 'Game'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object Pause1: TMenuItem
        Caption = 'Pause'
        OnClick = Pause1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Caption = 'Save'
      end
      object Load1: TMenuItem
        Caption = 'Load'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
  end
end
