# fipq

A Forth created with Ulitbo that runs bare-metal on a generic ARM. It is suitable for use with QEMU

## Prepare the disk image

Run `mkimg`. This creates a file containing a VFAT partition for QEMU to use


## Building fipq

* Open up fipq.lpi using Ultibo
* Select menu item Run : Compile. This creates `kernel.bin`
* Run `install-extras`, if necessary. This copies over `core.4th` to the disk image. You only need to run this if the various extra files change, which is expected to be infrequently.

## Running the result

Simple enough: type `qlaunch`.

## Prebuilt image

Is available here: 
https://drive.google.com/file/d/1akRBnpphRVXvD3KEM4haf60TuW7-arPo/view?usp=sharing
