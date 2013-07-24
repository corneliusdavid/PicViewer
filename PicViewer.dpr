program PicViewer;

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

  The Original Code is PicViewer.dpr/PicViewer.dof.

  The Initial Developer of the Original Code is Cornelius Concepts.
  Portions created by the Initial Developer are Copyright (C) 2003
  the Initial Developer. All Rights Reserved.

  Contributor(s): David E. Cornelius DBA Cornelius Concepts
  <david@CorneliusConcepts.com>.
*)

uses
  Forms,
  Graphics,
  ufrmPicViewer in 'ufrmPicViewer.pas' {frmBrowsePics},
  ufrmAbout in 'ufrmAbout.pas' {frmAbout};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PicViewer';
  Application.CreateForm(TfrmBrowsePics, frmBrowsePics);
  Application.HintColor := clInfoBk;
  Application.HintHidePause := 5000; // 5 seconds
  Application.HintPause := 500; // 1/2 second
  Application.Run;
end.
