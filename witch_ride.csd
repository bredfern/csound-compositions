<CsoundSynthesizer>
<CsOptions>
;-b 32768 -B 65536 -o dac
-W -o witch_ride.wav
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

 instr Bowing ; wgbow instrument
kamp     =        0.1
kfreq    =        p4
ipres1   =        p5
ipres2   =        p6
; kpres (bow pressure) defined using a random spline
kpres    rspline  p5,p6,0.5,2
krat     =        0.27236
kvibf    =        14.5
kvibamp  =        0
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

instr FM_timbr ;timbre change as the modulator is in the audio range
 kModAmp linseg 0, p3/2, 212, p3/2, 50
 kModFreq line 25, p3, 440
 kCarAmp linen 0.5, 0.1, p3, 0.5
 aModulator poscil kModAmp, kModFreq
 aCarrier poscil kCarAmp, 400 + aModulator
 out aCarrier, aCarrier
 iRvbSendAmt  =         0.6               ; reverb send amount (0 - 1)
;add some of the audio from this instrument to the global reverb send variable
gaRvbSend    =         gaRvbSend + (aCarrier * iRvbSendAmt)
endin

instr reverb1 ; reverb - always on
kroomsize    init      0.6          ; room size (range 0 to 1)
kHFDamp      init      0.1           ; high freq. damping (range 0 to 1)
; create reverberated version of input signal (note stereo input and output)
aCarrier,aCarrier  freeverb  gaRvbSend, gaRvbSend,kroomsize,kHFDamp
             outs      aCarrier,aCarrier ; send audio to outputs
             clear     gaRvbSend    ; clear global audio variable
  endin
  
  instr reverb2 ; reverb
aRvbL,aRvbR reverbsc gaSendL,gaSendR,0.9,7000
            outs     aRvbL,aRvbR
            clear    gaSendL,gaSendR
 endin

</CsInstruments>
<CsScore>
i "Bowing"  0 480  180 0.03 0.2
i "Bowing"  0 480 105 0.03 0.3
i "Bowing"  0 480 100 0.03 0.09
i "Bowing"  0 480 135 0.03 0.09
i "Bowing"  0 480 170 0.02 0.09
i "Bowing"  0 480 202 0.04 0.13
i "Bowing"  0 480 233 0.05 0.11

i "Bowing"  0 880  390 0.03 0.12
i "Bowing"  0 880  295 0.03 0.13
i "Bowing"  0 880 100 0.03 0.092
i "Bowing"  0 880 135 0.03 0.09
i "Bowing"  0 880 170 0.02 0.09
i "Bowing"  0 880 202 0.04 0.12
i "Bowing"  0 880 233 0.05 0.11

i "Bowing"  0 1480  70 0.03 0.2
i "Bowing"  0 1480  85 0.03 0.3
i "Bowing"  0 1480 100 0.03 0.09
i "Bowing"  0 1480 135 0.03 0.09
i "Bowing"  0 1480 170 0.02 0.09
i "Bowing"  0 1480 202 0.04 0.2
i "Bowing"  0 1480 233 0.05 0.15

i "FM_timbr" 60 60
i "FM_timbr" + .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .
i "FM_timbr" . .



i "reverb1" 0 1800
i "reverb2" 0 1800
e
</CsScore>
</CsoundSynthesizer>
;example by marijana janevska




















<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>0</width>
 <height>0</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
