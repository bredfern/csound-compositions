<CsoundSynthesizer>
<CsOptions>
-odac
;-W  -o mystery.wav
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 16
nchnls = 2
0dbfs = 1
seed    0
gisine  ftgen	0,0,4096,10,1
gaSend init 0

instr 1
asig vco 0.1, p4 + rnd(280), 1
kcutoff line 10, p3, 500
kresonance = rnd(10)
kamp = 10
kcps = 5
itype = 4

k1 lfo kamp, kcps + rnd(640), itype
a1 lowres asig, kcutoff + k1, kresonance
aL, aR  freeverb a1, a1, rnd(0.9), 0.35, sr, 0
outs a1 + aL, a1 + aR
endin

; Instrument #2
instr 2
kamp = 0.2
kfreq = rnd(480)+10
kc1 = rnd(5)
kc2 = 5
kvdepth = rnd(0.009)
kvrate = rnd(6)
ifn1 = 1
ifn2 = 1
ifn3 = 1
ifn4 = 1
ivfn = 1

a1 fmbell kamp, kfreq, kc1, kc2, kvdepth, kvrate, ifn1, ifn2, ifn3, ifn4, ivfn
aL, aR  freeverb a1, a1, rnd(0.9), 0.35, sr, 0
outs a1 + aL, a1 + aR
endin

instr 3
a1 sleighbells 0.3, 0.1
outs a1, a1
endin

instr 4
  ; Generate some noise.
  asig noise 0.2, 0.5

  ; Run it through a wave-guide model.
  kfreq init rnd(2200)
  kcutoff init 3000
  kfeedback init 0.8
  awg1 wguide1 asig, kfreq, kcutoff, kfeedback

  out awg1
endin


 instr 5; wgbow instrument
kamp     =        0.3
kfreq    =        rnd(200)
kpres    =        0.2
krat     rspline  0.006,0.988,0.1,0.4
kvibf    =        4.5
kvibamp  =        0
iminfreq =        20
aSig	 wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
aSig     butlp     aSig,2000
aSig     pareq    aSig,80,6,0.707
         outs     aSig,aSig
gaSend   =        gaSend + aSig/3
 endin

 instr 6 ; reverb
aRvbL,aRvbR reverbsc gaSend,gaSend,0.9,7000
            outs     aRvbL,aRvbR
            clear    gaSend
 endin
</CsInstruments>
<CsScore>
f 1 0 32768 10 1
; Table
r 19
t 0 20

i 1 0 2 140
i 1 2 1 120
i 1 3 -1 130
i 1 4 . 150
i 1 5 -1 160
i 1 5.5 . 190
i 1 6 . 180
i 1 6.5 1 130
i 1 7 . 140
i 1 7.5 . 180
i 1 8 4 140

i 2 0 4
i 2 4 -1
i 2 5 .
i 2 6 .
i 2 7 .
i 2 8 4

i 3 0 0.25
i 3 + .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .
i 3 . .

i 4 0.30 0.25
i 4 0.60 0.25
i 4 0.90 0.25
i 4 1.20 0.25
i 4 1.50 0.10
i 4 1.60 .
i 4 1.70 .
i 4 1.80 .
i 4 1.90 .
i 4 3.00 0.25
i 4 3.30 .
i 4 3.60 .
i 4 3.90 .
i 4 4.20 0.10
i 4 4.30 .
i 4 4.40 .
i 4 5.50 .
i 4 5.60 .
i 4 5.70 .
i 4 6.00 0.25
i 4 6.30 .
i 4 6.60 .
i 4 6.90 .
i 4 7.10 .
i 4 7.40 .
i 4 7.70 .
i 4 8.00 .

i 5  0 8

i 6 0 8

e
</CsScore>
</CsoundSynthesizer>
