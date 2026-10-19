<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac      ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o wgflute.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

instr 1

kfreq = p5
kjet init p4			;vary air jet
iatt = 0.1
idetk = 0.1
kngain = 0.05
kvibf = 5.925
kvamp = 0.05

asig wgflute .8, kfreq, kjet, iatt, idetk, kngain, kvibf, kvamp, 1
     outs asig, asig

endin
</CsInstruments>
<CsScore>
f 1 0 16384 10 1		;sine wave

i 1 0 2 0.001	 440		;more air jet
i 1 + 2 0.001 440
e
</CsScore>
</CsoundSynthesizer>
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
