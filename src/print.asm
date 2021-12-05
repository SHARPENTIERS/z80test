; Simple printing module.
;
; Copyright (C) 2012 Patrik Rak (patrik@raxoft.cz)
;
; This source code is released under the MIT license, see included license.txt.


; call アドレスの次の内容を print
print:      ex      (sp),hl
            call    printhl
            ex      (sp),hl
            ret

; HL の示すアドレスの内容を print
printhl:
.loop       ld      a,(hl)
            inc     hl
            or      a
            ret     z
            call    printchr
            jr      .loop

; a の内容を 10 進表示
printdeca:  ld      h,a
            ld      b,-100
            call    .digit
            ld      b,-10
            call    .digit
            ld      b,-1

.digit      ld      a,h
            ld      l,'0'-1
.loop       inc     l
            add     a,b
            jr      c,.loop
            sub     b
            ld      h,a
            ld      a,l
            jr      printchr


printcrc:   ld      b,4

; HL の挿す内容を 16進表示
printhexs:
.loop       ld      a,(hl)
            inc     hl
            call    printhexa
            djnz    .loop
            ret


printhexa:  push    af
            rrca
            rrca
            rrca
            rrca
            call    .nibble
            pop     af

.nibble     or      0xf0
            daa
            add     a,0xa0
            adc     a,0x40

; 1 文字表示
; in: a = ascii code
printchr:   push    iy
            push    bc
            push    de
            push    hl
            call    0x0012  ; print 1char
            pop     hl
            pop     de
            pop     bc
            pop     iy
            ret

; EOF ;
