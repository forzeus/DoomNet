[Setup]
AppId=DoomNet.Windows.x64
AppName=DoomNet
AppVersion={#MyAppVersion}
AppPublisher=DoomNet
AppPublisherURL=https://github.com/forzeus/DoomNet
AppSupportURL=https://github.com/forzeus/DoomNet/issues
AppUpdatesURL=https://github.com/forzeus/DoomNet/releases
DefaultDirName={localappdata}\Programs\DoomNet
DefaultGroupName=DoomNet
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
MinVersion=10.0
OutputBaseFilename=DoomNet-Windows-Setup-x64
SetupIconFile=..\..\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\DoomNet.exe
UninstallDisplayName=DoomNet
VersionInfoCompany=DoomNet
VersionInfoDescription=DoomNet Setup
VersionInfoProductName=DoomNet
VersionInfoVersion={#MyAppVersion}
Compression=lzma2
SolidCompression=no
WizardStyle=modern
AppMutex=DoomNetMutex
CloseApplications=no
RestartApplications=no

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkedonce

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[INI]
Filename: "{app}\doomnet-install.ini"; Section: "Installation"; Key: "Kind"; String: "Setup"

[Icons]
Name: "{userprograms}\DoomNet"; Filename: "{app}\DoomNet.exe"; WorkingDir: "{app}"
Name: "{userdesktop}\DoomNet"; Filename: "{app}\DoomNet.exe"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\DoomNet.exe"; WorkingDir: "{app}"; Description: "{cm:LaunchProgram,DoomNet}"; Flags: nowait postinstall skipifsilent unchecked

[UninstallDelete]
Type: files; Name: "{app}\doomnet-install.ini"

; Deliberately no service removal, shared registry or profile directory deletion.
; Existing upstream elevated core identity is not isolated yet.
