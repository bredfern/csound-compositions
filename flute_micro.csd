<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
;-odac           -iadc     -d     ;;;RT audio I/O
; For Non-realtime ouput leave only the line below:
; -o wgflute.wav -W ;;; for file output any platform
-+rtaudio=jack -i adc -o dac -+rtmidi=alsa -M hw:1
</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr = 44100
ksmps = 128
nchnls = 2

; Table #1 Kraig Grady's 14 tone mictotuned scale
;  numgrades = 14 (fourteen tones)
 ; interval = 2 (one octave)
 ; basefreq = 261.659 (Middle C)
;  basekeymidi = 60 (Middle C)
  gitemp ftgen 2, 0, 64, -2, 14, 2, 261.659, 60, 1.05, 1.125, 1.166666666666666667, 1.25, 1.3125, 1.333333333333333333, 1.4, \
             1.5, 1.575, 1.6875, 1.75, 1.875, 1.96875, 2

; Instrument #1.
instr 1
  ifn = 1
  ikoct     =     8     ;4 octave range
  kfratio     midic7     1, 1, ikoct ;mod.wheel controls transposition 
  i1 cpstmid ifn
  ivel veloc
  kamp = ivel*200
  kfreq = i1*kfratio
  kjet = rnd(0.5)
  iatt = 0.1
  idetk = 0.1
  kngain = 0.15
  kvibf = kfratio
  kvamp = 0.05
 
  kenv linsegr 0,0.001,ivel/128, 3, 0
  a1 wgflute kamp, kfreq, kjet, iatt, idetk, kngain, kvibf, kvamp, ifn
 
  outs a1*kenv,a1*kenv
endin
</CsInstruments>
<CsScore>
; Table #1, a sine wave.
f 1 0 16384 10 1
i 1 9999
e
</CsScore>
</CsoundSynthesizer>





<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>1166</x>
 <y>76</y>
 <width>30</width>
 <height>105</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>slider1</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{0f9a6870-e6e7-4ef9-bf59-5670ceea9b92}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 slider1
</MacGUI>
