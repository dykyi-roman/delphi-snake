program SnakeProject;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fSnake},
  uSnake in 'uSnake.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfSnake, fSnake);
  Application.Run;
end.
