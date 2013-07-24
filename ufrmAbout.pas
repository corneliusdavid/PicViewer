unit ufrmAbout;

(**** License Information ****

  Version: MPL 1.1

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the
  License.

  The Original Code is ufrmAbout.dfm/ufrmAbout.pas.

  The Initial Developer of the Original Code is Cornelius Concepts, Inc.
  Portions created by the Initial Developer are Copyright (C) 2003, 2007
  the Initial Developer. All Rights Reserved.

  Contributor(s): David E. Cornelius of Cornelius Concepts, Inc.
  <dev@CorneliusConcepts.com>.
*)

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, ComCtrls, ShellAPI;

type
  TfrmAbout = class(TForm)
    pgcAbout: TPageControl;
    shtGeneral: TTabSheet;
    shtCmdLine: TTabSheet;
    mmoDescribe: TMemo;
    shtLicense: TTabSheet;
    mmoLicense: TMemo;
    mmoCommandLine: TMemo;
    shtLinks: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Shape1: TShape;
    Image2: TImage;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    procedure lblWebClick(Sender: TObject);
  end;


implementation

{$R *.DFM}


procedure TfrmAbout.lblWebClick(Sender: TObject);
var
  ShellInfo: TShellExecuteInfo;
begin
  FillChar(ShellInfo, SizeOf(TShellExecuteInfo), 0 );
  ShellInfo.cbSize := SizeOf(TShellExecuteInfo);
  ShellInfo.fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_NO_UI or
                     SEE_MASK_FLAG_DDEWAIT;
  ShellInfo.Wnd := HWnd_Desktop;
  ShellInfo.lpVerb := 'Open';
  ShellInfo.lpFile := PChar((Sender as TLabel).Caption);
  ShellInfo.lpParameters := nil;
  ShellInfo.lpDirectory := nil;
  ShellInfo.nShow := sw_ShowNormal;

  ShellExecuteEx(@ShellInfo);
end;

end.
