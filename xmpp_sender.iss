; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Xmpp Sender"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "zloy@github.com"
#define MyAppURL "http://www.github.com/zloy/xmpp_sender"
#define MyAppExeName "xmpp_sender.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{79A72309-12C8-4510-BE62-299D3D01D2F7}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\Xmpp Sender
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=..
OutputBaseFilename=setup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "C:\InstantRails\ruby_apps\xmpp_sender\readme"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\InstantRails\ruby_apps\xmpp_sender\license"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\InstantRails\ruby_apps\xmpp_sender\xmpp_sender.yml"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

