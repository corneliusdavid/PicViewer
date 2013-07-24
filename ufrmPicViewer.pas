unit ufrmPicViewer;

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

  The Original Code is ufrmPicViewer.dfm/ufrmPicViewer.pas.

  The Initial Developer of the Original Code is Cornelius Concepts, Inc..
  Portions created by the Initial Developer are Copyright (C) 2003, 2007
  the Initial Developer. All Rights Reserved.

  Contributor(s): David E. Cornelius of Cornelius Concepts, Inc.
  <dev@CorneliusConcepts.com>.

  Test Run Parameters: -directory="c:\pics\2001\4x4 Snow Peak" -fitinwin
*)

interface

uses
  Windows, Messages, SysUtils, Classes, GraphicEx, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, ImgList, ExtCtrls, Menus, Buttons, ActnList, FileCtrl, StdCtrls,
  RzTreeVw, RzShellCtrls, RzListVw, SsBase, StAbout, StShlCtl;

type
  TfrmBrowsePics = class(TForm)
    imgToolIcons: TImageList;
    pnlDirectory: TPanel;
    barTools: TToolBar;
    btnPrev: TToolButton;
    btnExit: TToolButton;
    btnDel: TToolButton;
    pnlFilters: TPanel;
    lstFilters: TFilterComboBox;
    sboxPicBackground: TScrollBox;
    imgPicture: TImage;
    mnuFilesPopup: TPopupMenu;
    itmFilesDelete: TMenuItem;
    lstActions: TActionList;
    actFullScreen: TAction;
    actNext: TAction;
    actPrevious: TAction;
    actExit: TAction;
    btnFullScreen: TToolButton;
    actDeleteFile: TAction;
    btnFirst: TToolButton;
    splPicture: TSplitter;
    actHelp: TAction;
    btnHelp: TToolButton;
    actFirst: TAction;
    actLast: TAction;
    actStartMovie: TAction;
    btnNext: TToolButton;
    btnLast: TToolButton;
    btnMovie: TToolButton;
    ToolButton7: TToolButton;
    ToolButton1: TToolButton;
    tmrStartup: TTimer;
    tmrMovie: TTimer;
    ToolButton4: TToolButton;
    actStopMovie: TAction;
    btnScale: TToolButton;
    actStretch: TAction;
    StShellNotification: TStShellNotification;
    splFiles: TSplitter;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    imlActionImages: TImageList;
    lstFiles: TFileListBox;
    lstFolders: TDirectoryListBox;
    lstDrives: TDriveComboBox;
    btnRefresh: TToolButton;
    actRefresh: TAction;
    ToolButton6: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actNextExecute(Sender: TObject);
    procedure actPreviousExecute(Sender: TObject);
    procedure actDeleteFileExecute(Sender: TObject);
    procedure actFullScreenExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actFirstExecute(Sender: TObject);
    procedure actLastExecute(Sender: TObject);
    procedure tmrStartupTimer(Sender: TObject);
    procedure actStartMovieExecute(Sender: TObject);
    procedure tmrMovieTimer(Sender: TObject);
    procedure actStopMovieExecute(Sender: TObject);
    procedure actStretchExecute(Sender: TObject);
    procedure lstFilesClick(Sender: TObject);
    procedure lstFoldersChange(Sender: TObject);
    procedure StShellNotificationFileChange(Sender: TObject;
      ShellItem: TStShellItem);
    procedure StShellNotificationFileDelete(Sender: TObject; OldShellItem,
      NewShellItem: TStShellItem);
    procedure actRefreshExecute(Sender: TObject);
    procedure StShellNotificationFileRename(Sender: TObject; OldShellItem,
      NewShellItem: TStShellItem);
    procedure StShellNotificationShellChangeNotify(Sender: TObject;
      OldShellItem, NewShellItem: TStShellItem; Events: TStNotifyEventsSet);
  private
    FFitInWin: Boolean;
    FGoingToPicture: Boolean;
    FFirstTime: Boolean;
    FFullScreenMode: Boolean;
    // startup flags
    FStartFullScreen: Boolean;
    FStartMovie: Boolean;
    FGotoDirectory: string;
    procedure ShowPicture;
    procedure UpdateCaption(fn: string);
    procedure UpdateTitle(fn: string);
    procedure ProcessParams;
    function  GetFirstTime: Boolean;
    procedure SetFullScreenMode(const Value: Boolean);
    procedure SetInitialDir(const Value: string);
    property InitialDir: string write SetInitialDir;
    property FirstTime: Boolean read GetFirstTime write FFirstTime;
    property FullScreenMode: Boolean read FFullScreenMode write SetFullScreenMode;
  end;

var
  frmBrowsePics: TfrmBrowsePics;

implementation

uses
  Math, ufrmAbout;

{$R *.DFM}

const
  APP_TITLE = 'PicViewer';
  LAST_EXT = 4;
  VALID_EXTS: array[0..LAST_EXT] of string = ('JPG', 'JPEG', 'GIF', 'BMP', 'ICO');

procedure TfrmBrowsePics.FormCreate(Sender: TObject);
begin
  FFirstTime := True;
  FGoingToPicture := False;
end;

procedure TfrmBrowsePics.FormActivate(Sender: TObject);
begin
  if FirstTime and (ParamCount > 0) then
    ProcessParams;
end;

function TfrmBrowsePics.GetFirstTime: Boolean;
begin
  Result := FFirstTime;

  FFirstTime := False;
end;

procedure TfrmBrowsePics.lstFilesClick(Sender: TObject);
begin
  if lstFiles.ItemIndex >= 0 then
    ShowPicture;
end;

procedure TfrmBrowsePics.lstFoldersChange(Sender: TObject);
begin
  StShellNotification.Active := False;
  StShellNotification.WatchFolder := lstFolders.Directory;
  StShellNotification.Active := True;
end;

procedure TfrmBrowsePics.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmBrowsePics.actFirstExecute(Sender: TObject);
begin
  if lstFiles.Items.Count > 0 then begin
    lstFiles.ItemIndex := 0;
    ShowPicture;
  end;
end;

procedure TfrmBrowsePics.actPreviousExecute(Sender: TObject);
begin
  if lstFiles.ItemIndex > 0 then begin
    lstFiles.ItemIndex := lstFiles.ItemIndex - 1;
    ShowPicture;
  end;
end;

procedure TfrmBrowsePics.actRefreshExecute(Sender: TObject);
var
  savei: Integer;
  savefn: string;
  checki: Integer;
begin
  savei := lstFiles.ItemIndex;
  savefn := lstFiles.Items[lstFiles.ItemIndex];

  lstFiles.Update;

  checki := lstFiles.Items.IndexOf(savefn);
  if checki <> -1 then
    lstFiles.ItemIndex := checki
  else begin
    lstFiles.ItemIndex := Min(savei, lstFiles.Items.Count - 1);
    ShowPicture;
  end;
end;

procedure TfrmBrowsePics.actNextExecute(Sender: TObject);
begin
  if lstFiles.ItemIndex < (lstFiles.Items.Count - 1) then begin
    lstFiles.ItemIndex := lstFiles.ItemIndex + 1;
    ShowPicture;
  end else if btnMovie.Down then
    actFirst.Execute;
end;

procedure TfrmBrowsePics.actLastExecute(Sender: TObject);
begin
  if lstFiles.Items.Count > 0 then begin
    lstFiles.ItemIndex := lstFiles.Items.Count - 1;
    ShowPicture;
  end;
end;

procedure TfrmBrowsePics.actDeleteFileExecute(Sender: TObject);
var
  SavePlace: Integer;
begin
  // setup dialog box
  if MessageDlg('Delete ' + lstFiles.FileName + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    // save our current place in the file list ('cause it's going to change!)
    SavePlace := lstFiles.ItemIndex;

    // try to delete the file, give an error message if not
    if DeleteFile(lstFiles.FileName) then begin
      lstFiles.Update;
    end else
      MessageDlg(lstFiles.FileName + ' could not be deleted.', mtWarning, [mbCancel], 0);

    // restore place in list as close as possible
    if SavePlace >= lstFiles.Items.Count then
      Dec(SavePlace);
    // ... as long as it's still a valid place
    if SavePlace >= 0 then begin
      lstFiles.ItemIndex := SavePlace;
      ShowPicture;
    end;
  end;
end;

procedure TfrmBrowsePics.actFullScreenExecute(Sender: TObject);
begin
  FullScreenMode := not FullScreenMode;
end;

procedure TfrmBrowsePics.SetFullScreenMode(const Value: Boolean);
const
  BorderStyles: array[Boolean] of TFormBorderStyle = (bsSizeable, bsNone);
  CursorStyles: array[Boolean] of TCursor = (crDefault, crNone);
  PictureAligns: array[Boolean] of TAlign = (alNone, alClient);
  ScrollBoxColors: array[Boolean] of TColor = (clBtnFace, clBlack);
begin
  if FFullScreenMode <> Value then begin
    Screen.Cursor := CursorStyles[Value];
    sboxPicBackground.Cursor := CursorStyles[Value];
    sboxPicBackground.AutoScroll := not Value;
    sboxPicBackground.Color := ScrollBoxColors[Value];
    imgPicture.Cursor := CursorStyles[Value];
    imgPicture.Align := PictureAligns[Value];
    imgPicture.Center := Value;
    splPicture.Visible := not Value;
    pnlDirectory.Visible := not Value;
    BorderStyle := BorderStyles[Value];
    FFullScreenMode := Value;
  end;
end;

procedure TfrmBrowsePics.actHelpExecute(Sender: TObject);
begin
  with TfrmAbout.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmBrowsePics.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if tmrMovie.Enabled then
    actStopMovie.Execute;

  if not FGoingToPicture then begin
    FGoingToPicture := True;
    try
      case Key of
        // go FIRST
        VK_HOME:
            actFirst.Execute;
        // go BACK
        VK_UP,
        VK_BACK,
        VK_RBUTTON,
        VK_LEFT:
          begin
            Key := 0;
            actPrevious.Execute;
          end;
        // go FORWARD
        VK_DOWN,
        VK_SPACE,
        VK_RETURN,
        VK_LBUTTON,
        VK_RIGHT:
          begin
            Key := 0;
            actNext.Execute;
          end;
        // go LAST
        VK_END:
            actLast.Execute;
        // force FullScreen OFF
        VK_ESCAPE:
            FullScreenMode := False;
        // toggle FullScreen
        VK_F12:
            actFullScreen.Execute;
      end;
    finally
      FGoingToPicture := False;
    end;
  end;
end;

procedure TfrmBrowsePics.ProcessParams;
const
  MOVIE_PARAM = 'MOVIE';
  FITINWIN = 'FITINWIN';
  DIRECTORY_PARAM = 'DIRECTORY';
  MAXIMIZE_PARAM = 'MAXIMIZE';
  FULLSCREEN_PARAM = 'FULLSCREEN';
var
  i: Integer;
  s, param: string;
  EqualSignPos: Integer;
begin
  FStartMovie := False;
  FFitInWin := False;
  FStartFullScreen := False;
  FGotoDirectory := '';

  for i := 1 to ParamCount do begin
    s := ParamStr(i);
    if s[1] = '-' then begin
      // take off the leading dash and upper case everything
      s := UpperCase(Copy(s, 2, Length(s)));

      // pull off the first word--this is our parameter
      EqualSignPos := Pos('=', s);
      if EqualSignPos > 0 then
        param := Copy(s, 1, EqualSignPos-1)
      else
        param := Copy(s, 1, Length(s));

      // leave anything else there (copy after the possible "=")
      s := Copy(s, Length(param)+2, Length(s));

      // now see what parameter it is
      if param = MOVIE_PARAM then
        FStartMovie := True
      else if param = FITINWIN then
        FFitInWin := True
      else if param = DIRECTORY_PARAM then
        FGotoDirectory := s
      else if param = MAXIMIZE_PARAM then
        WindowState := wsMaximized
      else if param = FULLSCREEN_PARAM then
        FStartFullScreen := True;
    end;
  end;

  tmrStartup.Enabled := True;
end;

procedure TfrmBrowsePics.SetInitialDir(const Value: string);
begin
  if (Value[2] = ':') and (Value[1] in ['A'..'Z']) then begin
    lstDrives.Drive := Value[1];
    lstFolders.Drive := Value[1];
  end;
  lstFolders.Directory := ExtractFilePath(IncludeTrailingBackslash(Value));
  lstFiles.Update;

  actFirst.Execute;
end;

procedure TfrmBrowsePics.ShowPicture;
var
  fn: string;
  i: Integer;
  ext: string;
begin
  fn := lstFiles.Items[lstFiles.ItemIndex];

  if Length(fn) = 0 then begin
    imgPicture.Picture.Bitmap.FreeImage;
    UpdateCaption(fn);
    UpdateTitle(fn);
  end else begin
    // find out if this is a valid extension by getting the chosen file,
    // and looking at the extension (without the period)
    ext := UpperCase(Copy(ExtractFileExt(fn), 2, 255));

    // go through the list of valid extensions and see if we have a match
    if ext <> '' then begin
      for i := 0 to LAST_EXT do
        if ext = VALID_EXTS[i] then
          Break;

      // if we broke out of the loop by the end of the list, we have a valid picture file.
      if i <= LAST_EXT then
        try
          if not FullScreenMode then
            Screen.Cursor := crHourGlass;
          try
            imgPicture.Picture.LoadFromFile(fn);
            UpdateCaption(fn);
            UpdateTitle(fn);
          except
            actRefresh.Execute;
          end;
        finally
          if not FullScreenMode then
            Screen.Cursor := crDefault;
        end;
    end;
  end;
end;

procedure TfrmBrowsePics.StShellNotificationFileChange(Sender: TObject;
  ShellItem: TStShellItem);
begin
  actRefresh.Execute;
end;

procedure TfrmBrowsePics.StShellNotificationFileDelete(Sender: TObject;
  OldShellItem, NewShellItem: TStShellItem);
begin
  actRefresh.Execute;
end;

procedure TfrmBrowsePics.StShellNotificationFileRename(Sender: TObject;
  OldShellItem, NewShellItem: TStShellItem);
begin
  actRefresh.Execute;
end;

procedure TfrmBrowsePics.StShellNotificationShellChangeNotify(Sender: TObject;
  OldShellItem, NewShellItem: TStShellItem; Events: TStNotifyEventsSet);
begin
  actRefresh.Execute;
end;

procedure TfrmBrowsePics.tmrStartupTimer(Sender: TObject);
begin
  tmrStartup.Enabled := False;

  if FStartFullScreen then
    FullScreenMode := True;
  if Length(FGotoDirectory) > 0 then
    InitialDir := FGotoDirectory;
  if FStartMovie then
    actStartMovie.Execute;
  if FFitInWin then
    actStretch.Execute;
end;

procedure TfrmBrowsePics.actStartMovieExecute(Sender: TObject);
begin
  btnMovie.Down := True;

  // make sure we're at least on the first picture
  if lstFiles.ItemIndex < 0 then
    actFirst.Execute;

  // start them rolling!
  tmrMovie.Enabled := True;

  // disable screen saver
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,0,nil,0);
end;

procedure TfrmBrowsePics.actStopMovieExecute(Sender: TObject);
begin
  tmrMovie.Enabled := False;
  btnMovie.Down := False;

  // re-enable screen saver
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,1,nil,0);
end;

procedure TfrmBrowsePics.tmrMovieTimer(Sender: TObject);
begin
  actNext.Execute;
end;

procedure TfrmBrowsePics.actStretchExecute(Sender: TObject);
const
  PIC_ALIGNS: array[Boolean] of TAlign = (alNone, alClient);
begin
  actStretch.Checked := not actStretch.Checked;
  imgPicture.Stretch := actStretch.Checked;
  imgPicture.Align := PIC_ALIGNS[actStretch.Checked];
end;

procedure TfrmBrowsePics.UpdateCaption(fn: string);
begin
  Caption := APP_TITLE + ' ' + fn;
end;

procedure TfrmBrowsePics.UpdateTitle(fn: string);
begin
  Application.Title := APP_TITLE + ' ' + ExtractFileName(fn);
end;

end.
