unit armall;

{$mode objfpc}{$H+}

interface

// USES_ARM is defined

uses
  // QEMUVersatilePB ,
  Console
  , FrameBuffer
  , GlobalConst
  , GlobalTypes
  , Keymap
  , Keymap_UK
  , Platform
  , Threads
  , SysUtils
  , Classes
  , Ultibo
  , Keyboard
  , FileSystem, MMC, FATFS
  , RemoteShell, ShellForth

  , engine
  , texteditor
  , ultiboapi
  , forthgpio
  ;


var Fb:PFramebufferDevice;
 FramebufferProperties:TFramebufferProperties;
 WindowHandle:TWindowHandle;
 c_drive_required:Boolean;

procedure  StartArmAll();

procedure OptionallyMountDrive();

implementation

procedure WritelnConsole(msg:string);
begin
  ConsoleWindowWriteLn(WindowHandle,msg);
end;

procedure ReadLnConsole(var text:string);
begin
 ConsoleWindowReadLn(WindowHandle, text);

end;

procedure P_uk_kbd();
begin
 KeymapSetDefault(KeymapFindByName('UK'));
end;

procedure  StartArmAll();
begin
  Fb:=FrameBufferDeviceGetDefault;
  Sleep(100);
  FrameBufferProperties.Depth:= 32;
  FrameBufferProperties.Order:= FRAMEBUFFER_ORDER_RGB;
  FrameBufferProperties.PhysicalWidth:= 1920 div 2;
  FrameBufferProperties.PhysicalHeight:=1080 div 2;
  FrameBufferProperties.VirtualWidth:=FrameBufferProperties.PhysicalWidth;
  FrameBufferProperties.VirtualHeight:=FrameBufferProperties.PhysicalHeight * 2;
  FrameBufferDeviceAllocate(Fb,@FrameBufferProperties);
  Sleep(100);
  FrameBufferDeviceSetDefault(Fb);
  FrameBufferDeviceGetProperties(Fb,@FrameBufferProperties);
  //FramebufferDeviceFillRect(Fb, 0, 0, 500, 500, $44444444, FRAMEBUFFER_TRANSFER_DMA);
   WindowHandle:=ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_FULL,True);
   WritelnConsole('Ultimc started');
   OptionallyMountDrive();
   //WritelnConsole('Start typing, see what happens.');
   using_raspberry := true; // needed to fix readln() wierdness
   MainRepl();
   ThreadHalt(0);
end;

procedure OptionallyMountDrive();
var i:integer;
label OK;
begin
  ConsoleWindowWrite(WindowHandle, 'Mounting drive... ');
 if not c_drive_required then begin
   WritelnConsole('SKIPPED');
   exit;
 end;

 {Wait for C: drive to be ready}

 for i := 1 to 10 do begin
   if DirectoryExists('C:\') then goto OK;
   write('.');
   sleep(1000); // second
 end;
 WritelnConsole('FAILED');
 exit();

 OK:
 WritelnConsole('OK');

end;


function percent(v:TCell; pc:TCell):TCell;
begin
 percent := TCell(round(v * pc / 100));
end;

procedure P_fbrect();
var x0, y0, x1, y1, rgb, rgb1, base:LongWord;
    r, g, b:integer;
begin
 rgb := pop();
 base := $100;

 b :=  percent(base, (rgb mod 100));
 g :=  percent(base, ((rgb div 100) mod 100));
 r := percent(base, ((rgb div 10000) mod 100));
 rgb1 := $FF000000 + (b shl 16) + (g shl 8) + r;
 //writeln('fbrect rgb: ', r, ' ', g, ' ', b);

 y1 := pop();
 x1 := pop();
 y0 := pop();
 x0 := pop();
 FramebufferDeviceFillRect(Fb, x0, y0, x1, y1, rgb1, FRAMEBUFFER_TRANSFER_DMA);
end;


initialization
begin
  ReadLinePtr := @ReadLnConsole;
  c_drive_required := True;
  AddPrim(0, 'FBRECT', @P_fbrect);
  AddPrim(0, 'EDITOR', @TextEditorMain);
  AddPrim(1, '#', @P_backslash);
  AddPrim(0, 'UK-KBD', @P_uk_kbd);

  UltiboApiAddPrimitives();
end;

end.

