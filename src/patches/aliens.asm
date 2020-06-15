; Aliens cracked by Marvin (ALIENS.TAP)
; https://spectrum4ever.org/fulltape.php?go=releases&id=721&by=cracker
    push    hl
    ld      hl, $feb8 ; color
    ld      a, (hl)
    add     a, 3
    ld      (hl), a
    and     $07
    or      $08
    out     ($fe), a
    pop     hl
    scf
    ret

color:
    defb    $00
