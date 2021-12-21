; Main driver for the Z80 tester.
;
; Copyright (C) 2012 Patrik Rak (patrik@raxoft.cz)
;
; This source code is released under the MIT license, see included license.txt.

            org     0x8000

main:       di
            push    iy
            exx
            push    hl

            call    print
            db      0x0d, 0

            call    print
            db      "Z80 "
            testname
            db      " TEST", 13
            db      "(C) 2012 RAXOFT", 13
            db      "FOR MZ-80K/700/1500 BY SNAIL 2021 V1.0A", 13, 13
            db      "** NOTE **", 0x0d, "I/O TEST CRCS ARE NOT TAKEN FROM ACTUAL MACHINE.", 13, 13, 0

            ld      bc,0
            ld      hl,testtable
            jr      .entry

.loop       push    hl
            push    bc
            call    .test
            pop     bc
            pop     hl

            add     a,b
            ld      b,a

            inc     c

.entry      ld      e,(hl)
            inc     hl
            ld      d,(hl)
            inc     hl

            ld      a,d
            or      e
            jr      nz,.loop

            call    print
            db      13,"RESULT: ",0

            ld      a,b
            or      a
            jr      z,.ok

            call    printdeca

            call    print
            db      " OF ",0

            ld      a,c
            call    printdeca

            call    print
            db      " TESTS FAILED.",13,0
            jr      .done

.ok         call    print
            db      "ALL TESTS PASSED.",13,0

.done       pop     hl
            exx
            pop     iy
            ei
            ret

.test       ld      hl,1+3*vecsize
            add     hl,de
            push    hl

            ld      a,c
            call    printdeca

            ld      a,' '
            call    printchr

            ld      hl,1+3*vecsize+4
            add     hl,de

            call    printhl

            ex      de,hl

            call    test

            ld      hl,data+3

            ld      (hl),e
            dec     hl
            ld      (hl),d
            dec     hl
            ld      (hl),c
            dec     hl
            ld      (hl),b

            pop     de

            ld      b,4
            call    .cmp

            jr      nz,.mismatch

            call    print
            db      " OK",13,0

            ret

.mismatch   call    print
            db      " FAILED",13
            db      "CRC:",0

            call    printcrc

            call    print
            db      "   EXPECTED:",0

            ex      de,hl
            call    printcrc

            ld      a,13
            call    printchr

            ld      a,1
            ret

.cmp        push    hl
            push    de
.cmploop    ld      a,(de)
            xor     (hl)
            jr      nz,.exit
            inc     de
            inc     hl
            djnz    .cmploop
.exit       pop     de
            pop     hl
            ret

            include print.asm
            include idea.asm
            include tests.asm

; EOF ;
