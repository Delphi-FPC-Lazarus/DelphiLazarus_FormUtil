{
  FormUtil
  Position speichern und laden

  xx/xxxx FPC Ubuntu

  --------------------------------------------------------------------
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  THE SOFTWARE IS PROVIDED "AS IS" AND WITHOUT WARRANTY

  Author: Peter Lorenz
  Is that code useful for you? Donate!
  Paypal webmaster@peter-ebe.de
  --------------------------------------------------------------------

}

{$I ..\share_settings.inc}
unit formutil_unit;

interface

uses
{$IFDEF FPC}
{$IFNDEF UNIX}Windows, {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, IniFiles;
{$ELSE}
Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  IniFiles, Vcl.Forms;
{$ENDIF}
procedure ReadFormPos(const konfig: string; Form: TForm;
  defaultwidth, defaultheight: Integer; noFormSize: Boolean);
procedure WriteFormPos(const konfig: string; Form: TForm);

implementation

const
  csForm: string = 'FORM_';
  csWindowState: string = 'WINDOWSTATE';
  csMonitor: string = 'MONITOR';
  csTop: string = 'TOP';
  csLeft: string = 'LEFT';
  csHeightScaled: string = 'HEIGHT_SCALED';
  csWidthScaled: string = 'WIDTH_SCALED';
  csHeight: string = 'HEIGHT';
  csWidth: string = 'WIDTH';
  csDPI: string = 'DPI';
  csScaled: string = 'SCALED';

procedure CheckFormPos(Form: TForm; MonitorNum: Integer);
var
  Monitor: TMonitor;
begin
  if (MonitorNum >= 0) and (MonitorNum <= Screen.MonitorCount - 1) then
    Monitor := Screen.Monitors[MonitorNum]
  else
    Monitor := Screen.PrimaryMonitor;

  // Größe
  // if Form.Width > Monitor.WorkareaRect.Width then Form.Width:= Monitor.WorkareaRect.Width;
  // if Form.Height > Monitor.WorkareaRect.Height then Form.Height:= Monitor.WorkareaRect.Height;

  // Position (links/oben)
  if Form.Left < Monitor.WorkareaRect.Left then
    Form.Left := Monitor.WorkareaRect.Left;
  if Form.Top < Monitor.WorkareaRect.Top then
    Form.Top := Monitor.WorkareaRect.Top;

  // Position (rechts/unten)
  if Form.Left + Form.Width > Monitor.WorkareaRect.Left + Monitor.WorkareaRect.Width
  then
    Form.Left := Monitor.WorkareaRect.Left + Monitor.WorkareaRect.Width -
      Form.Width;
  if Form.Top + Form.Height > Monitor.WorkareaRect.Top + Monitor.WorkareaRect.Height
  then
    Form.Top := Monitor.WorkareaRect.Top + Monitor.WorkareaRect.Height -
      Form.Height;

end;

procedure ReadFormPos(const konfig: string; Form: TForm;
  defaultwidth, defaultheight: Integer; noFormSize: Boolean);
var
  ini: TIniFile;
  MonitorNum: Integer;
  Monitor: TMonitor;
  // Reset: Boolean;
begin
  ini := nil;
  MonitorNum := Screen.PrimaryMonitor.MonitorNum;
  try
    ini := TIniFile.Create(konfig);
    MonitorNum := ini.ReadInteger(csForm + Form.Name, csMonitor,
      Screen.PrimaryMonitor.MonitorNum);
    if (MonitorNum >= 0) and (MonitorNum <= Screen.MonitorCount - 1) then
      Monitor := Screen.Monitors[MonitorNum]
    else
      Monitor := Screen.PrimaryMonitor;

    if ini.ReadInteger(csForm + Form.Name, csWindowState, Integer(wsNormal))
      = Integer(wsMaximized) then
    begin
      Form.WindowState := wsMaximized;
    end
    else
    begin
      // Reset := (ini.ReadInteger(csForm + Form.Name, csDPI, Form.PixelsPerInch) <> Form.PixelsPerInch);
      // or (ini.ReadBool(csForm + Form.Name, csScaled, Form.Scaled) <> Form.Scaled);

      if noFormSize then // or Reset then
      begin
        Form.Height := defaultheight;
        Form.Width := defaultwidth;
      end
      else
      begin
        if Form.Scaled then
        begin
          Form.Height := ini.ReadInteger(csForm + Form.Name, csHeightScaled,
            trunc(defaultheight * Form.Monitor.PixelsPerInch / Form.PixelsPerInch));
          Form.Width := ini.ReadInteger(csForm + Form.Name, csWidthScaled,
            trunc(defaultwidth * Form.Monitor.PixelsPerInch / Form.PixelsPerInch));
        end
        else
        begin
          Form.Height := ini.ReadInteger(csForm + Form.Name, csHeight,
            defaultheight);
          Form.Width := ini.ReadInteger(csForm + Form.Name, csWidth,
            defaultwidth);
        end;
      end;

      Form.Top := ini.ReadInteger(csForm + Form.Name, csTop, 100);
      Form.Left := ini.ReadInteger(csForm + Form.Name, csLeft, 100);
    end;
  finally
    FreeAndNil(ini);
    CheckFormPos(Form, MonitorNum);
  end;
end;

procedure WriteFormPos(const konfig: string; Form: TForm);
var
  ini: TIniFile;
begin
  ini := nil;
  try
    ini := TIniFile.Create(konfig);
    ini.WriteInteger(csForm + Form.Name, csWindowState,
      Integer(Form.WindowState));
    ini.WriteInteger(csForm + Form.Name, csMonitor, Form.Monitor.MonitorNum);
    ini.WriteInteger(csForm + Form.Name, csTop, Form.Top);
    ini.WriteInteger(csForm + Form.Name, csLeft, Form.Left);
    if Form.Scaled then
    begin
      ini.WriteInteger(csForm + Form.Name, csHeightScaled, Form.Height);
      ini.WriteInteger(csForm + Form.Name, csWidthScaled, Form.Width);
    end
    else
    begin
      ini.WriteInteger(csForm + Form.Name, csHeight, Form.Height);
      ini.WriteInteger(csForm + Form.Name, csWidth, Form.Width);
    end;
    ini.WriteInteger(csForm + Form.Name, csDPI, Form.PixelsPerInch);
    ini.WriteBool(csForm + Form.Name, csScaled, Form.Scaled);
  finally
    FreeAndNil(ini);
  end;
end;

end.
