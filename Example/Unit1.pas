unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses formutil_unit;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteFormPos(ChangefileExt(application.ExeName, '.ini'), self);  // should be in %appdata%
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ReadFormPos(ChangefileExt(application.ExeName, '.ini'), self, 800, 600, false); // should be in %appdata%
end;

end.
