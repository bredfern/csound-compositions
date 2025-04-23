<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 16 
nchnls = 2
0dbfs = 1

giSine    ftgen     0, 0, 2^10, 10, 1

instr 1 
ibasefrq  =         cpspch(p4)
ibaseamp  =         ampdbfs(p5)

aOsc1     poscil    ibaseamp, ibasefrq, giSine
aOsc2     poscil    ibaseamp/2, ibasefrq*1.02, giSine
aOsc3     poscil    ibaseamp/3, ibasefrq*1.1, giSine
aOsc4     poscil    ibaseamp/4, ibasefrq*1.23, giSine
aOsc5     poscil    ibaseamp/5, ibasefrq*1.26, giSine
aOsc6     poscil    ibaseamp/6, ibasefrq*1.31, giSine
aOsc7     poscil    ibaseamp/7, ibasefrq*1.39, giSine
aOsc8     poscil    ibaseamp/8, ibasefrq*1.41, giSine
kenv      linen     1, p3/4, p3, p3/4
aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
          outs aOut*kenv, aOut*kenv
endin
    
instr 2

aOffset linseg 0, 1, 0, 5, 1, 3, 0
aSine1 poscil 0.2, rnd(230), 2 ; -> [230, 460, 690] Hz
aSine2 poscil 0.2, rnd(800), 1
kenv      linen     1, p3/4, p3, p3/4
outs (aSine1+aOffset)*aSine2*kenv, (aSine1+aOffset)*aSine2*kenv
endin

instr 3
kamp = ampdbfs(p4)
kfreq = rnd(880) + 100
kc1 = p5
kc2 = p6
kvdepth = 0.005
kvrate = 6

asig fmbell kamp, kfreq, kc1, kc2, kvdepth, kvrate, 1, 1, 1, 1, 1, p7
     outs asig, asig
kenv      linen     1, p3/2, p3, p3/4
          outs      asig*kenv, asig*kenv
endin

instr 4 
kamp     =        0.3  
kfreq    =        p4
ipres1   =        p5
ipres2   =        p6

kpres    rspline  p5,p6,0.5,2
krat     =        0.127236
kvibf    =        4.5
kvibamp  =        0
iminfreq =        20

aSigL    wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,giSine,iminfreq

kdel     rspline  0.01,0.1,0.1,0.5

kpres    vdel_k   kpres,kdel,0.2,2
aSigR    wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,giSine,iminfreq
         outs     aSigL,aSigR
endin
</CsInstruments>
<CsScore>
;          pch       amp
f 1 0 1024 10 1 ; sine
f 2 0 1024 10 1 1 1; 3 harmonics
f 8 0 8192 10 1;

i 1 0   15 8.00 -28
i 1 13 15 9.00 -29
i 1 15 18 9.02 -28
i 1 16 19 7.01 -26
i 1 17 10 6.00 -21
i 1 25 20 8.01 -22
i 1 43 20 4.03 -21
i 1 60 20 8.00 -20
i 1 80 20 7.00 -28
i 1 100 16 8.00 -22
i 1 110 30 6.00 -21
i 1 180 20 7.00 -21
i 1 200 40 7.00 -22
i 1 240 20 6.00 -28
i 1 260 20 7.00 -22
i 1 280 20 6.00 -24
i 1 340 20 7.00 -22
i 1 400 40 7.00 -24
i 1 450 20 6.00 -22

i 2 0 10
i 2 10 5
i 2 15 5
i 2 20 10
i 2 30 15
i 2 45 10
i 2 60 5
i 2 65 10
i 2 80 20
i 2 100 20
i 2 120 20
i 2 180 20
i 2 200 5
i 2 205 5
i 2 210 20
i 2 260 20
i 2 280 20
i 2 300 40
i 2 360 20
i 2 380 20
i 2 400 40
i 2 440 20

i 3 0 10 -28 5 5 16
i 3 10 20 -29 6 4 12
i 3 30 10 -28 3 7 16
i 3 40 10 -29 5 5 16
i 3 50 20 -28 3 7 22
i 3 70 30 -22 8 4 16
i 3 100 10 -22 5 5 16
i 3 110 30 -21 4 3 12
i 3 150 10 -22 5 5 16
i 3 200 10 -28 6 2 18
i 3 260 10 -22 5 5 16
i 3 300 10 -24 6 5 17
i 3 340 10 -22 5 5 16
i 3 400 10 -21 3 5 17
i 3 460 10 -22 4 5 18

i 4  10 480  70 0.03 0.1
i 4  10 483  85 0.03 0.1
i 4  10 481 100 0.03 0.09
i 4  10 484 135 0.03 0.09
i 4  10 481 170 0.02 0.09
i 4  10 482 202 0.04 0.1
i 4  10 483 233 0.05 0.11

</CsScore>
</CsoundSynthesizer>
