<CsoundSynthesizer>
<CsOptions>
-odac  -m128
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 0.5
seed    0

gisine  ftgen   0,0,4096,10,1
gaRvbSend init 0 

instr Ghosts

 kC randomi rnd(3000), rnd(5000), 1, 2, 4
 kR randomi 1, 2, 2, 3
 kI randomi 1, 5, randomi:k(3,1,1,3), 3

 //transform
 kM = kC / kR
 kD = kI * kM

 //apply to standard model
 aModulator poscil kD, kM
 aCarrier poscil ampdb(port:k(kI*5-48,.1)), kC + aModulator
 aOut linen aCarrier, .1, p3, p3/10
 out aOut, aOut
 iRvbSendAmt  =         0.8               ; reverb send amount (0 - 1)
;add some of the audio from this instrument to the global reverb send variable
gaRvbSend    =         gaRvbSend + (aOut * iRvbSendAmt)

endin

instr DemonStrings ; wgbow instrument
kamp     =        0.2
kfreq    =        p4
ipres1   =        p5
ipres2   =        p6
; kpres (bow pressure) defined using a random spline
kpres    rspline  p5,p6,0.5,2
krat     =        0.127236
kvibf    =        4.5
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
gaSendL  =        gaRvbSend + aSigL/3
gaSendR  =        gaRvbSend + aSigR/3
 endin

instr ReverbEffect ; reverb - always on
kroomsize    init      0.85          ; room size (range 0 to 1)
kHFDamp      init      0.1           ; high freq. damping (range 0 to 1)
; create reverberated version of input signal (note stereo input and output)
aRvbL,aRvbR  freeverb  gaRvbSend, gaRvbSend,kroomsize,kHFDamp
             outs      aRvbL, aRvbR ; send audio to outputs
             clear     gaRvbSend    ; clear global audio variable
endin

</CsInstruments>
<CsScore>
//changing the ratio at constant index=3
//let some nonsense happen
i "DemonStrings"  0 480  70 0.03 0.1
i "DemonStrings"  0 480  85 0.03 0.1
i "DemonStrings"  0 480 100 0.03 0.09
i "DemonStrings"  0 480 135 0.03 0.09
i "DemonStrings"  0 480 170 0.02 0.09
i "DemonStrings"  0 480 202 0.04 0.1
i "DemonStrings"  0 480 233 0.05 0.11
i "Ghosts" 0 480
i "ReverbEffect" 0 480
i "EvilReverb" 0 480
</CsScore>
</CsoundSynthesizer>
;based on an example by joachim heintz


<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
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
