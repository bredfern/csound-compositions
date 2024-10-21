<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac     ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o soundsthatkill.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>
sr = 44100
kr = 441
ksmps = 100
nchnls = 2
0dbfs  = 1

instr 1

kamp = p4
kfreq = 880
kc1 = p5
kc2 = p6
kvdepth = 0.005
kvrate = 6

asig fmbell kamp, kfreq, kc1, kc2, kvdepth, kvrate, 1, 1, 1, 1, 1, p7
kenv      linen     1, p3/2, p3, p3/4
     outs kenv*asig, kenv*asig
endin

instr 2
    ispb = p3                    ; Seconds-per-beat. Must specify "1" in score
    p3 = ispb * p4               ; Reset the duration
    idur = p3                    ; Duration
    iamp = p5*10                    ; Amplitude

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

</CsInstruments>
<CsScore>
; sine wave.
f 1 0 32768 10 1

i 1 0 2 .2  .5 5 16
i 1 4  .  . . 4 14
i 1 6  . .  . 5 18
i 1 10 . . . 6 17

i 2 0 1 2 0.504 7.04 2
i 2 2 1 2 0.504 7.04 [1 / 3]
i 2 4 1 2 0.603 7.04 2
i 2 6 1 2 0.604 7.03 [1 / 1.5]
i 2 10 1 2 0.602 7.04
e
</CsScore>
</CsoundSynthesizer>
