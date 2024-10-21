<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 44100
kr = 441
ksmps = 100
nchnls = 1
0dbfs = 1.0

instr wobbly
    ispb = p3                    ; Seconds-per-beat. Must specify "1" in score
    p3 = ispb * p4               ; Reset the duration
    idur = p3                    ; Duration
    iamp = p5                    ; Amplitude

    ipch = cpspch(p6)            ; Pitch
    idivision = 1 / (p7 * ispb)  ; Division of Wobble

    ; Oscillators
    a1 vco2 iamp, ipch * 1.005, 0
    a2 vco2 iamp, ipch * 0.495, 10
    a1 = a1 * a2 + a1

    ; Wobble envelope shape
    itable ftgenonce 0, 0, 8192, -7, 0, 4096, 1, 4096, 0

    ; LFO for wobble sound
    klfo oscil 1, idivision, itable

    ; Filter
    ibase = ipch
    imod = ibase * 9
    a1 moogladder a1, ibase + imod * klfo, 0.6

    ; Output
    out a1
endin

 instr 2

iolaps  = 2
igrsize = 0.04
ifreq   = iolaps/igrsize
ips     = 1/iolaps

istr = p4  /* timescale */
ipitch = p5 /* pitchscale */

a1 diskgrain "assets/bd.wav", 0.98, ifreq, ipitch, igrsize, ips*istr, 1, iolaps
   outs   a1, a1

endin

</CsInstruments>
<CsScore>
f 1 0 8192 20 2 1  ;Hanning function
t 0 140

i "wobbly" 0 1 2 0.404 6.04 2
i "wobbly" 2 1 2 0.404 6.04 [1 / 3]
i "wobbly" 4 1 2 0.404 6.04 2
i "wobbly" 6 1 2 0.404 7.04 [1 / 1.5]

i "wobbly" 8  1 2 0.404 5.09 2
i "wobbly" 10 1 2 0.404 5.09 1
i "wobbly" 12 1 2 0.404 5.09 [1 / 1.5]
i "wobbly" 14 1 2 0.404 6.11 [1 / 3]

i "wobbly" 16 1 2 0.404 6.04 1
i "wobbly" 18 1 2 0.404 6.04 [1 / 3]
i "wobbly" 20 1 2 0.404 6.04 2
i "wobbly" 22 1 2 0.404 7.04 [1 / 1.5]

i "wobbly" 24 1 2 0.404 6.09 2
i "wobbly" 26 1 2 0.404 6.09 1
i "wobbly" 28 1 2 0.404 6.11 [1 / 1.5]
i "wobbly" 30 1 2 0.404 6.09 [1 / 3]

i "wobbly" 32 1 2 0.404 6.04 2
i "wobbly" 34 1 2 0.404 6.04 [1 / 3]
i "wobbly" 36 1 2 0.404 6.04 2
i "wobbly" 38 1 2 0.404 7.04 [1 / 1.5]

i "wobbly" 40 1 2 0.404 5.09 2
i "wobbly" 42 1 2 0.404 5.09 1
i "wobbly" 44 1 2 0.404 5.09 [1 / 1.5]
i "wobbly" 46 1 2 0.404 6.11 [1 / 3]

i "wobbly" 48 1 2 0.404 6.04 1
i "wobbly" 50 1 2 0.404 6.04 [1 / 3]
i "wobbly" 52 1 2 0.404 6.04 2
i "wobbly" 54 1 2 0.404 7.04 [1 / 1.5]


i 2   10   1     1           0.6
i 2   11   .5     2           0.8
i 2   12   .     1          0.75
i 2   13   1     1.5        1.5
i 2   +   .    1        0.5
i 2   +   .    1        0.5
i 2   +   .    1        0.5
i 2   +   .    1        0.5
i 2   +   .    1        0.5
i 2   +   .    15        0.5
i 2   +   .    15        0.5
i 2   +   .    1        0.5
</CsScore>
</CsoundSynthesizer>
