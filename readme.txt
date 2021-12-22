**** z80test for MZ-80K/1200/700/1500 ****

Original Copyright (c) 2012 Patrik Rak
Ported by Snail 2021
Please read OriginalDocs/readme.txt

2021.12.22 V1.0b
- Full, Memptr and Ccf test's CRCs were taken from MZ-1500 by motochan1500. Thank you!

2021.12.21 V1.0a
- .MZF file included.
- Fixed some display.
- Now I/O tests(#096-#102) use printer data port (0xff). But their CRCs are not taken from actual machine.
  I would be grateful if you could check and tell me the actual CRC of each test.

2021.12.05 V1.0
- Changed makefile, print.asm, Uppercase strings.
- 'ALO' probably means 'Arithmetic and Logical operations' (ADD, ADC, SUB, SBC, AND, XOR, OR, CP)
- 'SRO' probably means 'Shift and Rotate operations' (RLC, RL, SLA, SLL, RRC, RR, SRA, SRL)
- Fortunately, the address of the executable binary (0x8000 # 0x4000) also went into the main RAM of the MZ-80K.
- I/O tests use printer control port (0xfe). please turn off the printer.

Snail
