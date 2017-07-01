unit uSnake;

interface

uses
  SysUtils, Windows, Classes, Graphics;

const
  DEFAULT_CELL        = 20;
  GRID_WIDTH          = 15;
  GRID_HEIGHT         = 25;
  DEFAULT_GRID_COLOR  = clGreen;
  DEFAULT_SNAKE_COLOR = clBlue;
  DEFAULT_HEAD_COLOR  = clRed;
  DEFAULT_APPLE_COLOR = clYellow;
  SNAKE_MSG_GAMEOVER  = 'Game is over';

type
  TTurningType = (ttt_left, ttt_right, ttt_up, ttt_down);
  TTurning = record
    Position: TPoint;
    State   : TTurningType;
  end;

  //-------------------------------------------------------------
  TBaseGrid = class
    FColor      : TColor;
    FCell       : Byte;
    FWidth      : Word;
    FHeight     : Word;
    Canvas      : TCanvas;
  private
    procedure DrawRect(ARect: TPoint; AColor: TColor);
    procedure SetHeight(const Value: Word);
    procedure SetWidth(const Value: Word);
  public
    constructor Create(ACanvas: TCanvas; AWidth: Integer; AHeight: Integer);  virtual;
    property Color     : TColor  read FColor    write FColor;
    property Width     : Word    read FWidth    write SetWidth    default GRID_WIDTH;
    property Height    : Word    read FHeight   write SetHeight   default GRID_HEIGHT;
    property Cell      : Byte    read FCell     write FCell       default DEFAULT_CELL;
  end;
  //-------------------------------------------------------------

  TList<T> = record
  type
    TArr = TArray<T>;
  strict private
    FArr : TArr;
    function    GetArr(Part : Integer): T;
    procedure   SetArr(Part : Integer; Value: T);
    function    GetCount: Integer;
  public
    procedure   SetCount(Const Value: Integer);
    property    Arr[Index: Integer]: T Read GetArr Write SetArr;
    property    Count: Integer Read GetCount Write SetCount;
  end;
  //---------------------------------------------------------------------
  TGrid   = class(TBaseGrid)
  private
    FGrid : TArray<Tarray<Boolean>>;
    procedure   CreateGrid;
  public
    constructor Create(ACanvas: TCanvas; AWidth: Integer; AHeight: Integer); override;
    //
    procedure   Clear;
    procedure   Draw(const ACell: Integer = DEFAULT_CELL);
  end;
  //------------------------------------------------------------------------
  TSnakeArr = TArray<TPoint>;
  TSnake = class(TBaseGrid)
  private
    FHeadColor  : TColor;
    Last        : TPoint;
    FSnake      : TList<TPoint>;
    procedure   SetStartLength;
  public
    constructor Create(ACanvas: TCanvas; AWidth, AHeight: Integer); override;
    destructor  Destroy; override;
    procedure   BuildSnake(Color: TColor = DEFAULT_SNAKE_COLOR);
    procedure   Draw;
  protected
    property    HeadColor  : TColor read FHeadColor  write FHeadColor  default DEFAULT_HEAD_COLOR;
  end;
  //-------------------------------------------------------------
  TApple = class(TBaseGrid)
  private
    FPossition : TPoint;
  public
    constructor Create(ACanvas: TCanvas; AWidth, AHeight: Integer);
    property Possition : TPoint read FPossition write FPossition;
  end;
  //-------------------------------------------------------------
  TGame = class(TBaseGrid)
  private
    FSpeed    : Word;
    FActive   : Boolean;
    ListOfTurn: TArray<TTurning>;
    procedure  SetSpeed(const Value: Word);
  public
    Grid  : TGrid;
    Snake : TSnake;
    Apple : TApple;
    constructor Create(ACanvas: TCanvas; AWidth: Integer = GRID_WIDTH; AHeight: Integer = GRID_HEIGHT); override;
    destructor  Destroy; override;
    //
    procedure   GenerateNewApple;
    procedure   New;
    procedure   Start;
    procedure   Pouse;
    procedure   Save(APath: string); virtual; abstract;
    procedure   Load(APath: string); virtual; abstract;
  public
    property    Active : Boolean  read FActive write FActive  default False;
    property    Speed  : Word     read FSpeed  write SetSpeed default 1;
  end;

var
  Game  : TGame;

implementation

{ TList<T> }

function TList<T>.GetArr(Part: Integer): T;
begin
  Result := FArr[Part];
end;

function TList<T>.GetCount: Integer;
begin
  Result := Length(FArr);
end;

procedure TList<T>.SetArr(Part: Integer; Value: T);
begin
  FArr[Part] := Value;
end;

procedure TList<T>.SetCount(const Value: Integer);
begin
  SetLength(FArr, Value);
end;

{ TBaseGrid }

constructor TBaseGrid.Create(ACanvas: TCanvas; AWidth, AHeight: Integer);
begin
  Canvas    := ACanvas;
  FCell     := DEFAULT_CELL;
  Height    := AHeight;
  Width     := AWidth;
end;

procedure TBaseGrid.DrawRect(ARect: TPoint; AColor: TColor);
begin
  Canvas.Brush.Color := AColor;
  Canvas.Brush.Style := bsSolid;
  Canvas.Rectangle(FCell*ARect.X, FCell*ARect.Y, FCell*ARect.X-FCell, FCell*ARect.Y-FCell);
end;

procedure TBaseGrid.SetHeight(const Value: Word);
begin
  FHeight := Value div FCell;
end;

procedure TBaseGrid.SetWidth(const Value: Word);
begin
  FWidth := Value div FCell;
end;

{ TGrid }

procedure TGrid.Clear;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    Brush.Style := bsSolid;
    FillRect(Rect(0,0,1000,1000));
  end;
end;

constructor TGrid.Create(ACanvas: TCanvas; AWidth, AHeight: Integer);
begin
  inherited Create(ACanvas, AWidth, AHeight);
  Color := DEFAULT_GRID_COLOR;
  CreateGrid;
end;

procedure TGrid.CreateGrid;
var
  i: Integer;
begin
  SetLength(FGrid, Height);
  For I := 0 To Height - 1 Do
    SetLength(FGrid[i], Width+1);
end;

procedure TGrid.Draw(const ACell: Integer);
var
  i, j : integer;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    Brush.Style := bsClear;
    Pen.Color   := FColor;
    for j := 0 to Width - 1 do
      for i := 0 to Height - 1 do
        Rectangle(j * FCell, i * FCell, FCell + j * FCell, FCell + i * FCell);
  end;
end;

{ TApple }

constructor TApple.Create(ACanvas: TCanvas; AWidth, AHeight: Integer);
begin
  inherited Create(ACanvas, AWidth, AHeight);
  Color := DEFAULT_APPLE_COLOR;
end;

{ TSnake }

procedure TSnake.BuildSnake(Color: TColor);
var
  I: Integer;
begin
  For I := 0 To FSnake.Count Do
    begin
      if i = 0 then
        DrawRect(FSnake.Arr[i], HeadColor)
      else
        DrawRect(FSnake.Arr[i], Color)
    end;
end;

constructor TSnake.Create(ACanvas: TCanvas; AWidth, AHeight: Integer);
begin
  inherited Create(ACanvas, AWidth, AHeight);
  Color     := DEFAULT_SNAKE_COLOR;
  HeadColor := DEFAULT_HEAD_COLOR;
  // Set Snake Possition

  SetStartLength;
end;

destructor TSnake.Destroy;
begin
  FSnake.SetCount(0);
  inherited;
end;

procedure TSnake.Draw;
begin
  BuildSnake;
  DrawRect(Last, clBtnFace);
end;

procedure TSnake.SetStartLength;
begin
  FSnake.SetCount(3);
  FSnake.Arr[0] := Point(10,10);
  FSnake.Arr[1] := Point(10,11);
  FSnake.Arr[2] := Point(10,12);
end;

{ TGame }

constructor TGame.Create(ACanvas: TCanvas; AWidth, AHeight: Integer);
begin
  inherited Create(ACanvas, AWidth, AHeight);
  Snake   := TSnake.Create(ACanvas, AWidth, AHeight);
  Apple   := TApple.Create(ACanvas, AWidth, AHeight);
  Grid    := TGrid.Create (ACanvas, AWidth, AHeight);
  //
  Randomize;
  Active  := False;
  Speed   := 1;
  FWidth  := AWidth;
  FHeight := AHeight;
end;

destructor TGame.Destroy;
begin
  FreeAndNil(Apple);
  FreeAndNil(Snake);
  FreeAndNil(Grid);
  inherited;
end;

procedure TGame.GenerateNewApple;

function Generate: TPoint;
var
  i : Integer;
begin
  Result := Point(1+Random(Width div Cell),1+Random(Height div Cell));
  for i := 0 to Snake.FSnake.Count -1 do
    if Snake.FSnake.Arr[i] = Apple.Possition then
      Generate;
end;

begin
  Apple.Possition := Generate;
  DrawRect(Apple.Possition, Apple.Color);
end;


procedure TGame.New;
begin
  Pouse;
  try
    Grid.Draw;
    Snake.Draw;
    GenerateNewApple;
  finally
    Start;
  end;
end;

procedure TGame.Pouse;
begin
  Active := False;
end;

procedure TGame.SetSpeed(const Value: Word);
begin
  FSpeed := Value;
end;

procedure TGame.Start;
begin
  Active := True;
end;

end.

