program Test_units_formutil;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {frmMain},
  formutil_unit in '..\formutil_unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
