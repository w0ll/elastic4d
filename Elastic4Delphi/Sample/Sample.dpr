program Sample;

uses
  Vcl.Forms,
  FSample in 'FSample.pas' {FForm},
  FSample.Resources in 'FSample.Resources.pas',
  FSample.Utils in 'FSample.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFForm, FForm);
  Application.Run;
end.
