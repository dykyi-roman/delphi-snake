unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Menus, Vcl.ExtCtrls;

type
  TfSnake = class(TForm)
    MainMenu1: TMainMenu;
    StatusBar1: TStatusBar;
    Game1: TMenuItem;
    New1: TMenuItem;
    Save1: TMenuItem;
    Load1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    N3: TMenuItem;
    Pause1: TMenuItem;
    pbGrid: TPaintBox;
    procedure Exit1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pbGridPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Pause1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSnake: TfSnake;

implementation

uses
  uSnake;

{$R *.dfm}

procedure TfSnake.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfSnake.FormCreate(Sender: TObject);
begin
  Game := TGame.Create(pbGrid.Canvas, fSnake.ClientWidth, fSnake.ClientHeight);
end;

procedure TfSnake.FormDestroy(Sender: TObject);
begin
  Game.Free;
end;

procedure TfSnake.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 If (Assigned(Game)) Then
  Case Key Of
    VK_UP:;
    VK_DOWN:;
    VK_LEFT:;
    VK_RIGHT:;
  end;
end;

procedure TfSnake.New1Click(Sender: TObject);
begin
  Game.New;
end;

procedure TfSnake.pbGridPaint(Sender: TObject);
begin
  if Game.Active then
    Game.Grid.Draw;
end;

procedure TfSnake.Start1Click(Sender: TObject);
begin
  Game.Start;
end;

procedure TfSnake.Pause1Click(Sender: TObject);
begin
  if Game.Active then
    Pause1.Caption := 'Start'
  else
    Pause1.Caption := 'Pause';
  Game.Pouse;
end;

end.
