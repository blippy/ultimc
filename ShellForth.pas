{
Ultibo Forth Shell extension unit.

Copyright (C) 2015 - SoftOz Pty Ltd.

Arch
====

 <All>

Boards
======

 <All>

Licence
=======

 LGPLv2.1 with static linking exception (See COPYING.modifiedLGPL.txt)
 
Credits
=======

 Information for this unit was obtained from:

 
References
==========

 

Shell Forth
===========

}

{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit ShellForth;

interface

uses GlobalConfig,GlobalConst,GlobalTypes,Platform,Threads,Devices,FileSystem,SysUtils,Classes,Ultibo,UltiboClasses,UltiboUtils,Shell,HTTP
     , parser
     ;


//To Do //Look for:

//--

{==============================================================================}
{Global definitions}
//{$INCLUDE ..\core\GlobalDefines.inc}

{==============================================================================}
type
 {Shell Forth specific clases}
 TShellForth = class(TShellCommand)
 public
  {}
  constructor Create;
 private
  {Internal Variables}
 
  {Internal Methods}
  
 protected
  {Internal Variables}

  {Internal Methods}
  
 public
  {Public Properties}

  {Public Methods}
  function DoHelp(AShell:TShell;ASession:TShellSession):Boolean; override;
  function DoInfo(AShell:TShell;ASession:TShellSession):Boolean; override;
  function DoCommand(AShell:TShell;ASession:TShellSession;AParameters:TStrings):Boolean; override;
 end;
 
 //TShellWGET = class(TShellCommand) //To Do //Simple WGET 

{==============================================================================}
{Initialization Functions}
procedure ShellForthInit;

{==============================================================================}
{Shell Forth Functions}
 
{==============================================================================}
{Shell Forth Helper Functions}
 
{==============================================================================}
{==============================================================================}

implementation

{==============================================================================}
{==============================================================================}
var
 {Shell Forth specific variables}
 ForthInterpreter:Integer; // Probably replace with an object refernce
 ShellForthInitialized:Boolean;
 TheShell:TShell;
 TheSession:TShellSession;
 
{==============================================================================}
{==============================================================================}
{TShellForth}
constructor TShellForth.Create;
begin
 inherited Create;
 Name:='Forth';
 Flags:=SHELL_COMMAND_FLAG_INFO or SHELL_COMMAND_FLAG_HELP;
end;

function TShellForth.DoHelp(AShell:TShell;ASession:TShellSession):Boolean; 
begin
 Result:=False;
 if AShell = nil then Exit;
 AShell.DoOutput(ASession,'Submit sentence to forth interpreter');
 AShell.DoOutput(ASession,'');
 Result:=True;
end;
 
function TShellForth.DoInfo(AShell:TShell;ASession:TShellSession):Boolean; 
begin
 Result:=False;
 if AShell = nil then Exit;
 AShell.DoOutput(ASession,'Submit sentence to forth interpreter');
 Result:=True;
end;

procedure ShellForthWritePtr(text:string);
begin
 TheShell.DoOutput(TheSession, text);
end;

var
 StartUpLineCounter:Integer;

procedure ShellForthReadLnPtr(var text:string);
begin
 case StartUpLineCounter of
 1:
  text:=': print type cr ;';
 2:
  text:='s" Ultibo!"';
 3:
  text:='print'
 else
  TheShell.DoInput(TheSession, text);
 end;
 Inc(StartUpLineCounter);
end;

function TShellForth.DoCommand(AShell:TShell;ASession:TShellSession;AParameters:TStrings):Boolean; 
var
 Sentence:String;
 i:Integer;
begin
 Result:=False;
 if AShell = nil then Exit;
 if AParameters = nil then Exit;

 {stuff inserted by MC (Mark Carter)}
 AShell.DoOutput(ASession, Format('forth interpreter initialized',[]));
 AShell.DoOutput(ASession, 'Go forth');
 TheShell := AShell;
 TheSession := ASession;
 WritePtr := @ShellForthWritePtr;
 ReadLinePtr := @ShellForthReadLnPtr;
 ForthWriteLn('From inside WritePtr, Now say something');
// ReadLinePtr(Sentence); // TODO this doesn't actually work
// ForthWriteLn(concat('You said:', Sentence));
// exit(); // exit just for now
 StartUpLineCounter := 1;
 RunForthRepl();
 Exit;

 if ForthInterpreter = 0 then
  begin
   ForthInterpreter:=1; 
   AShell.DoOutput(ASession, Format('forth interpreter initialized',[]));
  end;

 Sentence:='';
 for I:=0 to AParameters.Count - 1 do
  begin
   if Length(Sentence) <> 0 then
    Sentence:=Sentence + ' ';
   Sentence:=Sentence + AParameters[I];
  end;
 AShell.DoOutput(ASession, Format('forth sentence <%s>',[Sentence]));
 AShell.DoOutput(ASession, Format('forth output is %s',['...']));
end;
 
{==============================================================================}
{==============================================================================}
{Initialization Functions}
procedure ShellForthInit;
begin
 {}
 {Check Initialized}
 if ShellForthInitialized then Exit;
 
 {Register Forth Commands}
 ShellRegisterCommand(TShellForth.Create);

 ShellForthInitialized:=True;
end;
 
{==============================================================================}
{==============================================================================}
{Shell Forth Functions}
 
{==============================================================================}
{==============================================================================}
{Shell Forth Helper Functions}
 
{==============================================================================}
{==============================================================================}

initialization
 ShellForthInit;

{==============================================================================}
 
finalization
 {Nothing}

{==============================================================================}
{==============================================================================}
 
end.
