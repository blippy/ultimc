program ultimc;

{$mode objfpc}{$H+}

{ Raspberry Pi 3 Application                                                   }
{  Add your program code below, add additional units to the "uses" section if  }
{  required and create new units by selecting File, New Unit from the menu.    }
{                                                                              }
{  To compile your program select Run, Compile (or Run, Build) from the menu.  }

uses
  RaspberryPi3,
  GlobalConfig,
  GlobalConst,
  GlobalTypes,
  Platform,
  Threads,
  SysUtils,
  Classes,
  Ultibo,
  Console,
  Framebuffer,
  GimpPpm,
  Glute
;


var Fb:PFramebufferDevice;
 FramebufferProperties:TFramebufferProperties;
 WindowHandle:TWindowHandle;

begin
  Fb:=FrameBufferDeviceGetDefault;
  Sleep(100);
  FrameBufferProperties.Depth:=32;
  FrameBufferProperties.PhysicalWidth:= 1920 div 2;
  FrameBufferProperties.PhysicalHeight:=1080 div 2;
  FrameBufferProperties.VirtualWidth:=FrameBufferProperties.PhysicalWidth;
  FrameBufferProperties.VirtualHeight:=FrameBufferProperties.PhysicalHeight * 2;
  FrameBufferDeviceAllocate(Fb,@FrameBufferProperties);
  Sleep(100);
  FrameBufferDeviceSetDefault(Fb);
  FrameBufferDeviceGetProperties(Fb,@FrameBufferProperties);

  FramebufferDeviceFillRect(Fb, 0, 0, 500, 500, $44444444, FRAMEBUFFER_TRANSFER_DMA);

   WindowHandle:=ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_FULL,True);
 ConsoleWindowWriteLn(WindowHandle,'Hello Ultibo!');

 {Wait for C: drive to be ready}
 while not DirectoryExists('C:\') do
  begin
   {Sleep for a second}
   Sleep(1000);
  end;
    ConsoleWindowWriteLn(WindowHandle,'Directory now seems mounted!');

  LoadPpm('logo.ppm');
  FramebufferDevicePutRect(Fb, 0, 0, PpmBuffer, PpmWidth, PpmHeight, 0,  FRAMEBUFFER_TRANSFER_DMA);
  FreeMem(PpmBuffer);

  writeln('this seems to work     ........ writeln   .. yipee ');

  Tokenise('    hello world0.1');

   ThreadHalt(0);
end.

