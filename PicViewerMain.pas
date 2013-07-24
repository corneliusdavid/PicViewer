{**********************************************************************}
{ File archived using GP-Version                                       }
{ GP-Version is Copyright 1999 by Quality Software Components Ltd      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.qsc.co.uk                                                 }
{**********************************************************************}
{}
{ $Log:  N:\Program Files\GP-Version LITE\Archives\PicViewer\PicViewer\PicViewerMain.paV
{
{   Rev 1.4    4/9/00 10:51:28 PM  david
{ added support for more graphic file types, except for .GIF
{ which isn't supported (so removed it); modified the info
{ screen slightly.
}
{
{   Rev 1.3    4/7/00 11:06:41 PM  david
{ added Help button to show LMDAboutDlg, removed
{ Minimize button, added splitter.
}
{
{   Rev 1.2    4/6/00 11:38:14 PM  david    Version: 1.0
{ SpaceBar now default picture advancer
}
{
{   Rev 1.1    4/6/00 11:16:19 PM  david    Version: 1.0
{ Final initial version!
{
{ Built using ONLY Delphi standard controls, views bitmaps or
{ jpegs, has a full screen mode, can advance using
{ F3/SpaceBar/Enter, can backup using F2/BackSpace.
}
{
{   Rev 1.0    4/6/00 10:52:06 PM  david
{ Initial Revision
}
{}
unit PicViewerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, GraphicEx, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, ImgList, ExtCtrls, Menus, Buttons, LMDCustomHint,
  LMDCustomShapeHint, LMDShapeHint, LMDApplicationCtrl, LMDCustomComponent,
  LMDContainerComponent, LMDBaseDialog, LMDAboutDlg, ActnList, FileCtrl,
  StdCtrls;

type
  TfrmBrowsePics = class(TForm)
    imgToolIcons: TImageList;
    pnlDirectory: TPanel;
    barTools: TToolBar;
    btnPrev: TToolButton;
    btnExit: TToolButton;
    btnDel: TToolButton;
    pnlDrives: TPanel;
    lstDrives: TDriveComboBox;
    lstFiles: TFileListBox;
    pnlFilters: TPanel;
    lstFilters: TFilterComboBox;
    lstFolders: TDirectoryListBox;
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
    dlgAbout: TLMDAboutDlg;
    actHelp: TAction;
    btnHelp: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
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
    LMDApplicationCtrl: TLMDApplicationCtrl;
    actStopMovie: TAction;
    btnScale: TToolButton;
    actStretch: TAction;
    procedure ShowPicture(Sender: TObject);
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
    procedure dlgAboutCustomClick(Sender: TObject);
    procedure actStopMovieExecute(Sender: TObject);
    procedure actStretchExecute(Sender: TObject);
  private
    FFitInWin: Boolean;
    FGoingToPicture: Boolean;
    FFirstTime: Boolean;
    FFullScreenMode: Boolean;
    // startup flags
    FStartFullScreen: Boolean;
    FStartMovie: Boolean;
    FGotoDirectory: string;
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

{$R *.DFM}

const
  LAST_EXT = 4;
  VALID_EXTS: array[0..LAST_EXT] of string = ('JPG', 'JPEG', 'GIF', 'BMP', 'ICO');

procedure TfrmBrowsePics.ShowPicture(Sender: TObject);
var
  i: Integer;
  ext: string;
begin
  // find out if this is a valid extension by getting the chosen file,
  // and looking at the extension (without the period)
  ext := UpperCase(Copy(ExtractFileExt(lstFiles.FileName), 2, 255));

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
        imgPicture.Picture.LoadFromFile(lstFiles.FileName);
      finally
        if not FullScreenMode then
          Screen.Cursor := crDefault;
      end;
  end;
end;

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

procedure TfrmBrowsePics.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmBrowsePics.actFirstExecute(Sender: TObject);
begin
  if lstFiles.Items.Count > 0 then begin
    lstFiles.ItemIndex := 0;
    ShowPicture(nil);
  end;
end;

procedure TfrmBrowsePics.actPreviousExecute(Sender: TObject);
begin
  if lstFiles.ItemIndex > 0 then begin
    lstFiles.ItemIndex := lstFiles.ItemIndex - 1;
    ShowPicture(nil);
  end;
end;

procedure TfrmBrowsePics.actNextExecute(Sender: TObject);
begin
  if lstFiles.ItemIndex < (lstFiles.Items.Count - 1) then begin
    lstFiles.ItemIndex := lstFiles.ItemIndex + 1;
    ShowPicture(nil);
  end else if btnMovie.Down then
    actFirst.Execute;
end;

procedure TfrmBrowsePics.actLastExecute(Sender: TObject);
begin
  if lstFiles.Items.Count > 0 then begin
    lstFiles.ItemIndex := lstFiles.Items.Count - 1;
    ShowPicture(nil);
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
      ShowPicture(nil);
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
  dlgAbout.ExecuteEnh(self);
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

procedure TfrmBrowsePics.dlgAboutCustomClick(Sender: TObject);
begin
  MessageBox(0, PChar('Possible command-line parameters include: '#13#10#10 +
                      '-maximize'#13#10 +
                      'This maximizes the application''s window to the full height and width of your screen.'#13#10#10 +
                      '-fullscreen'#13#10 +
                      'This hides the toolbar buttons, drive, directory, and file list and sets a black background.' +
                      'Also, the scroll bars and mouse pointer are hidden. ' +
                      'The shortcut is F12.'#13#10#10 +
                      '-fitinwin'#13#10 +
                      'This scales the pictures to the size of the viewable area. The shortcut is F11.'#13#10#10 +
                      '-movie'#13#10 +
                      'This starts stepping through the pictures, loading the next one every 7 seconds.  At the end of ' +
                      'the list, it starts over at the beginning.  Any key except F5 (the shortcut) leaves movie mode.'#13#10#10 +
                      '-directory=<Path>'#13#10 +
                      'This starts the application in the specified directory.  If the directory has spaces in it, enclose it in quotes.'#13#10#10#10 +
                      'Written in Delphi 6 by David Cornelius. Portions copyright by Borland Software Corporation and LMD Innovative.'),
                      'More information...', MB_OK + MB_ICONINFORMATION + MB_TASKMODAL);
end;

procedure TfrmBrowsePics.actStretchExecute(Sender: TObject);
const
  PIC_ALIGNS: array[Boolean] of TAlign = (alNone, alClient);
begin
  actStretch.Checked := not actStretch.Checked;
  imgPicture.Stretch := actStretch.Checked;
  imgPicture.Align := PIC_ALIGNS[actStretch.Checked];
end;

end.
