program matview;

{$mode delphi}

uses
  Codebot.System,
  Interfaces, // this includes the LCL widgetset
  Classes, Forms, Dialogs, LCLIntf, UITypes,
  Main, ExportDlg, MaterialFont, MaterialTools
  { you can add units after this };

{$R *.res}
{$R fonts.res}

function CheckFont: Boolean;
var
  S: string;
begin
  Result := Screen.Fonts.IndexOf('Material Design Icons') > -1;
  if not Result then
  begin
    S := 'The required "Material Design Icons" font was not found on your system. ';
    if GetPlatform > platformWindowsXP then
      S := S + 'Would you like help installing it?'
    else
      S := S + 'Would you like to install it?';
    if MessageDlg(S, mtConfirmation, [mbyes, mbNo], 0) = mrYes then
    begin
      Application.ProcessMessages;
      Sleep(100);
      {$ifdef linux}
      S := PathCombine(StrEnvironmentVariable('HOME'), '.fonts');
      DirCreate(S);
      S := PathCombine(S, MaterialFontFile);
      ResSaveData('materialdesignicons', S);
      Result := True;
      {$endif}
      {$ifdef windows}
      if GetPlatform = platformWindowsXP then
      begin
        S := 'C:\Windows\Fonts\' + MaterialFontFile;
        ResSaveData('materialdesignicons', S);
        Result := True;
      end
      else
      begin
        S := ConfigAppDir(False, True);
        S := PathCombine(S, MaterialFontFile);
        ResSaveData('materialdesignicons', S);
        OpenDocument(S);
      end;
      {$endif}
      if Result then
        Sleep(3000);
    end;
  end;
end;

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  if CheckFont then
  begin
    Application.CreateForm(TMaterialIconForm, MaterialIconForm);
    Application.Run;
  end;
end.

