program fipq;

{$mode objfpc}{$H+}

{ QEMU VersatilePB Application                                                 }


uses
  {$ifdef BUILD_MODE_QEMUVPB} QEMUVersatilePB,  {$endif}
  {$ifdef BUILD_MODE_RPI    } RaspberryPi,      {$endif}
  {$ifdef BUILD_MODE_RPI2   } RaspberryPi2,     {$endif}
  {$ifdef BUILD_MODE_RPI3   } RaspberryPi3,     {$endif}
  //QEMUVersatilePB
  armall

;

begin
  //c_drive_required := False;
  StartArmAll();
end.

