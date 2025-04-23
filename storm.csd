<CsoundSynthesizer>
<CsOptions>
;-b 32768 -B 65536 -o dac
-W -o storm.wav
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
seed    0

gisine  ftgen   0,0,4096,10,1

gaSendL,gaSendR init 0

gaRvbSend    init      0 ; global audio variable initialized to zero


instr ocean ; wgbow instrument turned into water sound
kamp     =        0.25
kfreq    =        p4
ipres1   =        p5
ipres2   =        p6

kpres    rspline  p5,p6,0.5,0.6
krat     =        rnd(100)
kvibf    =        14.5
kvibamp  =        0.2
iminfreq =        20
; call the wgbow opcode
aSigL    wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
; modulating delay time
kdel     rspline  0.01,0.1,0.1,0.5
; bow pressure parameter delayed by a varying time in the right channel
kpres    vdel_k   kpres,kdel,0.2,2
aSigR    wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
         outs     aSigL,aSigR
; send some audio to the reverb
gaSendL  =        gaSendL + aSigL/3
gaSendR  =        gaSendR + aSigR/3

endin

instr thunder

kamp = 0.025
kfreq = rnd(200)
kc1 = 127
kc2 = 30
kvdepth = 0.005
kvrate = rnd(400)

asig fmbell kamp, kfreq, kc1, kc2, kvdepth, kvrate

outs asig, asig

iRvbSendAmt  =         1 
gaRvbSend    =         gaRvbSend + (asig * iRvbSendAmt)

endin


instr reverb1 ; reverb - always on
kroomsize    init      0.9          ; room size (range 0 to 1)
kHFDamp      init      0.4           ; high freq. damping (range 0 to 1)
; create reverberated version of input signal (note stereo input and output)
aCarrier,aCarrier  freeverb  gaRvbSend, gaRvbSend,kroomsize,kHFDamp
             outs      aCarrier,aCarrier ; send audio to outputs
             clear     gaRvbSend    ; clear global audio variable
  endin
  
  instr reverb2 ; reverb
aRvbL,aRvbR reverbsc gaSendL,gaSendR,0.9,10000
            outs     aRvbL,aRvbR
            clear    gaSendL,gaSendR
 endin

</CsInstruments>
<CsScore>
f 1 0 32768 10 1

i "ocean"  0 180 180 0.03 0.2
i "ocean"  0 180 105 0.03 0.3
i "ocean"  0 180 100 0.03 0.09
i "ocean"  0 180 135 0.03 0.09
i "ocean"  0 180 170 0.02 0.09
i "ocean"  0 180 202 0.04 0.13
i "ocean"  0 180 233 0.05 0.11

i "thunder" 10 
i "thunder" + 10 
i "thunder" + 10 
i "thunder" + 10 

i "thunder" + 10
i "thunder" + 10
i "thunder" + 10

i "thunder" + 10 
i "thunder" + 10
i "thunder" + 10

i "thunder" + 10 
i "thunder" + 10 
i "thunder" + 10 

i "thunder" + 10 
i "thunder" + 10
i "thunder" + 10

i "reverb1" 0 180
i "reverb2" 0 180
e
</CsScore>
</CsoundSynthesizer>

