; Commando cracked by ZIBEROV OLEG (COMMANDO.TAP)
; https://spectrum4ever.org/fulltape.php?go=releases&id=235&by=cracker
    ld      a, r
    add     a, b
    and     $07
    or      $0a
    out     ($fe), a
    scf
    ret
