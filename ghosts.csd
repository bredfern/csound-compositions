<CsoundSynthesizer>
<CsOptions>
-odac  -m128
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 0.5

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
 aCarrier poscil ampdb(port:k(kI*5-28,.1)), kC + aModulator
 aOut linen aCarrier, .1, p3, p3/10
 out aOut, aOut
 iRvbSendAmt  =         0.8               ; reverb send amount (0 - 1)
;add some of the audio from this instrument to the global reverb send variable
gaRvbSend    =         gaRvbSend + (aOut * iRvbSendAmt)

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
i "Ghosts" 0 300
i "ReverbEffect" 0 300
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
