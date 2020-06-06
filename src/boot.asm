LD_BYTES equ $0556 ; https://skoolkid.github.io/rom/asm/0556.html
CLS      equ $0d6b ; https://skoolkid.github.io/rom/asm/0D6B.html
BORDCR   equ $5c48 ; https://skoolkid.github.io/rom/asm/5C48.html
ATTR_P   equ $5c8d ; https://skoolkid.github.io/rom/asm/5C8D.html
ld_bytes equ $fe00

; Clear the screen
    ld      a, $07
    ld      (ATTR_P), a
    ld      (BORDCR), a
    xor     a
    out     ($fe), a
    call    CLS

; Copy the standard loader from ROM to RAM
    ld      hl, LD_BYTES
    ld      de, ld_bytes
    ld      bc, $00af
    ldir

; Patch the copied code
    ld      hl,ld_bytes+$8d
    ld      (ld_bytes+$26),hl
    ld      (ld_bytes+$2d),hl
    ld      (ld_bytes+$75),hl
    ld      hl,ld_bytes+$91
    ld      (ld_bytes+$17),hl
    ld      (ld_bytes+$3c),hl
    ld      (ld_bytes+$46),hl
    ld      (ld_bytes+$8e),hl
    ld      hl,ld_bytes+$74
    ld      (ld_bytes+$80),hl
    sub     a
    ld      (ld_bytes+$05),a
    ld      (ld_bytes+$15),a
    ld      (ld_bytes+$9e),a

; Patch the copy with another pre-compiled patch
    ld      de, patch-pc_pos-1      ; the offset of the block to be moved
                                    ; relatively to the address after call minus 1
    inc     e                       ; add 1 to reset the z flag
    call    $1fc6                   ; this is effectively ld hl, pc
pc_pos:
    add     hl, de                  ; now hl points to the begginning of the block source
    ld      de, ld_bytes+$a7        ; de points to the block destination
    ld      bc, endpatch-patch      ; the size of the block to be moved
    ldir
    jr      load

patch:
    include __PATCH__
endpatch:

load:
    ld      ix, $4000
    ld      de, $1b00
    ld      a,  $ff
    scf
    call    ld_bytes
    ret
