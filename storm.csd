<CsoundSynthesizer>
<CsOptions>
;-o dac
-W -o storm.wav
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

seed 1

gisine  ftgen   0,0,4096,10,1
gaSendL,gaSendR init 0
gaRvbSend    init      0 ; global audio variable initialized to zero

instr ocean ; wgbow instrument turned into water sound
kamp     =        0.32
kfreq    =        p4 * rnd(1000)
ipres1   =        p5
ipres2   =        p6

kpres    rspline  ipres1,ipres2,0.5,0.6
krat     =        rnd(100) * 10
kvibf    =        rnd(1000)
kvibamp  =        0.5
iminfreq =        100
; call the wgbow opcode
aSigL    wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
; modulating delay time
kdel     rspline  0.01,0.1,0.1,0.5
; bow pressure parameter delayed by a varying time in the right channel
kpres    vdel_k   kpres,kdel,0.2,2
aSigR    wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
         outs     aSigL,aSigR
; send some audio to the reverb
gaSendL  =        gaSendL + aSigL/2
gaSendR  =        gaSendR + aSigR/2

endin

instr thunder

kamp = 0.34
kfreq = p4 * rnd(300) + 100
kc1 = 12
kc2 = 3
kvdepth = rnd(0.009)
kvrate = rnd(1000)

asig fmbell kamp, kfreq, kc1, kc2, kvdepth, kvrate

outs asig, asig

iRvbSendAmt = 2
gaRvbSend = gaRvbSend + (asig * iRvbSendAmt)

endin

instr reverb1 ; reverb - always on
kroomsize    init      1        ; room size (range 0 to 1)
kHFDamp      init      0.1           ; high freq. damping (range 0 to 1)
; create reverberated version of input signal (note stereo input and output)
aCarrier,aCarrier  freeverb  gaRvbSend, gaRvbSend,kroomsize,kHFDamp
             outs      aCarrier,aCarrier ; send audio to outputs
             clear     gaRvbSend    ; clear global audio variable
  endin
  
  instr reverb2 ; reverb
aRvbL,aRvbR reverbsc gaSendL,gaSendR,0.9,100000
            outs     aRvbL,aRvbR
            clear    gaSendL,gaSendR
 endin

</CsInstruments>
<CsScore>
f 1 0 32768 10 1

t 0 40

i "ocean"  0 280 280 0.03 0.2
i "ocean"  0 .   205 0.03 0.3
i "ocean"  0 .   200 0.03 0.09
i "ocean"  0 .   235 0.03 0.09
i "ocean"  0 .   270 0.02 0.09
i "ocean"  0 .   202 0.04 0.13
i "ocean"  0 .   233 0.05 0.11

i "thunder" 3 3 0.010 
i "thunder" + 10 0.010
i "thunder" + 10 0.010
i "thunder" + 10 0.010
i "thunder" + 10 0.002
i "thunder" + 2 0.003
i "thunder" + 10 0.002
i "thunder" + 2 0.003
i "thunder" + 10 0.009
i "thunder" + 10 0.009
i "thunder" + 10 0.015
i "thunder" + 3 0.015
i "thunder" + 10 0.015
i "thunder" + 10 0.011
i "thunder" + 10 0.011
i "thunder" + 10 0.011
i "thunder" + 10 0.015
i "thunder" + 3 0.015
i "thunder" + 10 0.015
i "thunder" + 10 0.011
i "thunder" + 10 0.011
i "thunder" + 10 0.011
i "thunder" + 10 0.011
i "thunder" + 10 0.015
i "thunder" + 3 0.015
i "thunder" + 10 0.015
i "thunder" + 10 0.011
i "thunder" + 10 0.011
i "thunder" + 10 0.011

i "reverb1" 0 280

i "reverb2" 0 280
e
</CsScore>
</CsoundSynthesizer>
