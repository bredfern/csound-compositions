<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 32
nchnls = 1
0dbfs = 1

instr 1   ; Amplitude-Modulation
aOffset linseg 0, 1, 0, 5, 1, 3, 0
aSine1 poscil 0.3, p4, 2 ; -> [230, 460, 690] Hz
aSine2 poscil 0.3, p5, 1
out (aSine1+aOffset)*aSine2
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1 ; sine
f 2 0 1024 10 1 1 1; 3 harmonics
i 1 0 10 230 600
i 1 10 20 440 800
i 1 30 10 200 300
i 1 40 .  230 740
i 1 50 .  340 100
e
</CsScore>
</CsoundSynthesizer>
