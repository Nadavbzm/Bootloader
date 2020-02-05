bits 16 ; NASM for 16bit code
org 0x7c00 ;output offset

boot:
  mov si, msg
  mov ah, 0x0e ;Write char in TTY
lp:
  lodsb
  or al, al;cmp al,0
  jz stop
  int 0x10 ; BIOS INT - Video Services
  jmp lp

  stop:
    cli ;Clear int flag
    hlt

msg: db "Bootloader Hello!", 0
times 510 - ($-$$) db 0 ; pad remaining 510 bytes with zeroes
dw 0xaa55 ; marks 512 byte sector bootable
