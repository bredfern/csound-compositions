<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr MassSpring
 ;set ksmps=1 in this instrument
 setksmps 1
 ;initial values
 a0        init      0
 a1        init      0.05
 kc        randomi   .001, .05, 8, 3
 ;calculation of the next value
 a2        =         a1+(a1-a0) - kc*a1
           outs      a0, a0
 ;actualize values for the next step
 a0        =         a1
 a1        =         a2
endin
</CsInstruments>
<CsScore>
i "MassSpring" 0 10
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz



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
