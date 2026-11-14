; ============================================================================
;  MyToolBox - Inno Setup installer script (Inno Setup 7, also works with 6.3+)
;
;  Put this file in the project folder, next to MyToolBox.xojo_xml_project.
;  Build the Windows app in Xojo first (Build > Build for Windows), then
;  compile this script. The installer is written to the "Installer" subfolder.
; ============================================================================

; ---------------------------------------------------------------------------
;  Settings you may need to adjust
; ---------------------------------------------------------------------------
#define MyAppName        "MyToolBox"
#define MyAppVersion     "2.0.1"
#define MyAppPublisher   "RAKwireless"
#define MyAppURL         "https://www.rakwireless.com"
#define MyAppExeName     "MyToolBox.exe"
#define ProjectFile      "MyToolBox.xojo_xml_project"

; Xojo installation, only used to get the Visual C++ runtime installer
#define XojoDir          "C:\Program Files\Xojo\Xojo 2025r2.1"

; 1 = the Xojo project is built as a 64-bit Windows app, 0 = 32-bit
#define Win64Build       1

; Optional files in the "Resources" folder of the project.
; If a file does not exist it is simply left out.
#define IconFile         "Resources\MyToolBox.ico"
#define LicenseTextFile  "Resources\License.txt"

; ---------------------------------------------------------------------------
;  Derived values (normally no changes needed)
; ---------------------------------------------------------------------------
#if Win64Build
  #define PlatformFolder "Windows 64 bit"
  #define VCRedistFile   "VC_redist.x64.exe"
  #define VCRuntimeKey   "x64"
#else
  #define PlatformFolder "Windows 32 bit"
  #define VCRedistFile   "VC_redist.x86.exe"
  #define VCRuntimeKey   "x86"
#endif

; Xojo names the build folder "Builds - <project name>"
#define BuildsFolder "Builds - MyToolBox"
#if !DirExists(SourcePath + BuildsFolder)
  #undef BuildsFolder
  #define BuildsFolder "Builds - " + ProjectFile
#endif

#define BuildDir BuildsFolder + "\" + PlatformFolder + "\" + MyAppName
#if !DirExists(SourcePath + BuildDir)
  #error "Xojo build output not found. Build the Windows app in Xojo first, or adjust BuildsFolder / PlatformFolder at the top of this script."
#endif

#define VCRedist XojoDir + "\Extras\Windows Runtime\Installers\" + VCRedistFile

[Setup]
; AppId identifies this application for updates and uninstall. Never reuse it for another app.
AppId={{B95D4DA8-2ADC-4E1B-A0E3-4F26294D10DB}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
VersionInfoVersion={#MyAppVersion}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=Installer
OutputBaseFilename={#MyAppName}-Setup-{#MyAppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
UninstallDisplayIcon={app}\{#MyAppExeName}
; Xojo 2025 desktop apps need Windows 10 or later
MinVersion=10.0
#if Win64Build
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
#endif
#if FileExists(SourcePath + IconFile)
SetupIconFile={#IconFile}
#endif
#if FileExists(SourcePath + LicenseTextFile)
LicenseFile={#LicenseTextFile}
#endif

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; The EXE plus the "MyToolBox Libs" and "MyToolBox Resources" folders that Xojo creates next to it
Source: "{#BuildDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

#if FileExists(VCRedist)
; Microsoft Visual C++ runtime (Xojo apps need it), taken from the Xojo installation.
; It is only installed if it is not already present on the target PC.
Source: "{#VCRedist}"; DestDir: "{tmp}"; Flags: deleteafterinstall; Check: VCRedistNeedsInstall
#else
  #pragma message "WARNING: Visual C++ runtime installer not found in the Xojo folder. The installer will be built without it."
#endif

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
#if FileExists(VCRedist)
Filename: "{tmp}\{#VCRedistFile}"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing Microsoft Visual C++ runtime..."; Flags: waituntilterminated; Check: VCRedistNeedsInstall
#endif
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
{ True if the Visual C++ 2015-2022 runtime for the architecture of the app is not installed yet }
function VCRedistNeedsInstall: Boolean;
var
  Installed: Cardinal;
begin
  Result := True;
  if RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\{#VCRuntimeKey}',
                        'Installed', Installed) then
    Result := (Installed <> 1);
end;
