; Frontline cracked by ZIBEROV OLEG (Frontline.TAP)
; https://spectrum4ever.org/fulltape.php?go=releases&id=235&by=cracker
    xor     $02
    and     $07
    or      $08
    out     ($fe), a
    and     $f9
    out     ($fe), a
    scf
    ret
