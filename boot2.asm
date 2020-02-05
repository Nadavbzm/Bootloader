bits 16 ; NASM for 16bit code
org 0x7c00 ;output offset

boot:
  mov ax, 0x2401
  int 0x15 ;enable A20 bits

  mov ax, 0x3
  int 0x10 ;set vga text mode 3

  cli
  lgdt [gdt_pointer] ; load global descriptor table
  mov eax, cr0 ; now using 32bit registers
  or eax, 0x1 ;set the protected mode bit on special cpu register cr0
  mov cr0, eax
  jmp CODE_SEG:boot2 ;long jump to the code segment
gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:
gdt_pointer:
  dw gdt_end - gdt_start
  dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
boot2:
  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  mov esi, msg
  mov ebx, 0xb8000

.l:
  lodsb
  or al, al
  jz stop
  or eax, 0x5100
  mov word [ebx], ax
  add ebx, 2
  jmp .l

stop:
  cli
  hlt

msg: db "Hello From 32bit protected mode!", 0
times 510 - ($-$$) db 0
dw 0xaa55
