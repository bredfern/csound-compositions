<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr     = 48000
ksmps  = 32
nchnls = 2
0dbfs  = 1

instr 1
    aNoise rand 1

    ; Slowly vary the filter and volume for gusts
    kCut   randomi 400, 2500, 0.12
    kLevel randomi 0.15, 0.8, 0.08

    aWind tone aNoise, kCut
    aWind = aWind * kLevel * p4

    ; Let the sound drift across the stereo field
    kPan randomi 0.25, 0.75, 0.04
    aL, aR pan2 aWind, kPan
    outs aL, aR
endin
</CsInstruments>
<CsScore>
; Instrument, start, duration, amplitude
i1 0 30 0.3
e
</CsScore>
</CsoundSynthesizer>