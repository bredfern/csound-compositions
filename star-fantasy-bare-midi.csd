<CsoundSynthesizer>
<CsOptions>
-+rtaudio=alsa -o dac:hw:2,0 -M hw:a --midi-key-cps=4 --midi-velocity=5
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 128
nchnls = 2
0dbfs = 1

gaOut init 0.0						; a global audio variable is initialised, this can be seen as an "global audio Bus" (g.a.Bus), where audiodata can be send and read from, but first it is NULL

instr 1 						; Sawthooth Oscillator triggered with notes on MIDI CH: 1
icps = p4
iamp = p5/127						; MIDI received velocity (from 0-127), becomes devided by 127 -> amplitude-range is now 0-1 
kFfreq invalue "filter_freq"
kFfreq port kFfreq, 0.05

aSrc oscili iamp, icps, 1				; reads form f-table 1, containing a sawthooth waveform
aFiltered moogvcf aSrc, kFfreq, 0.1			; the source signal becomes low pass filtered
aEnv madsr 0.01, 0.1, 0.9, 0.01			; defining the envelope
gaOut =  (aFiltered*aEnv) + gaOut 			; the signal becomes scaled by the envelope and is added to the "g.a.Bus" 
							; that no information (from other sources, or simultaneous voices) which already exists on the global variable will be lost, itself needs to become added as well
endin

instr 2 						; Sine Oscillator triggered with notes on MIDI CH: 2
icps = p4
iamp = p5/127
aSrc oscili iamp, icps, 2				; this instrument reads from f-table 2, containing a sinus waveform
aEnv madsr 0.01, 0.1, 0.9, 0.01			; defining the envelope
gaOut = (aSrc*aEnv) + gaOut
endin


instr 101					 ; Global Feedback Delay
kDryWet invalue "d_w_delay"			; receive values from the Widget Panel
kDelTime invalue "time_delay"
kFeedback invalue "feedb_delay"
aDelay delayr 1					;  a delayline, with 1 second maximum delay-time is initialised
aWet	deltapi kDelTime				; data at a flexible position is read from the delayline 
	delayw gaOut+(aWet*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 
gaOut	= (1-kDryWet) * gaOut + (kDryWet * aWet)	; the amount of pure-signal and delayed-signal is mixed, and written to the "g.a.Bus"
endin

instr 102					 			; Global Reverb
kroomsize init 0.4						; fixed values for reverb-roomsize and damp, but you can add knobs or faders on the Widget Panel and invalue the data here...
khfdamp init  0.8
kDryWet invalue "d_w_reverb"
aWetL, aWetR freeverb gaOut, gaOut, kroomsize, khfdamp		; the freeverb opcode works with stereo input, so we read twice the "g.a.Bus"
aOutL	 = (1-kDryWet) * gaOut + (kDryWet * aWetL)			; the amount of pure-signal (g.a.Bus) and reverbed-signal for the left side is mixed, and written to a local variable
aOutR	 = (1-kDryWet) * gaOut + (kDryWet * aWetR)
outs aOutL, aOutR								; main output of the final signal
gaOut = 0.0									; clear the global audio channel for the next k-loop
endin


</CsInstruments>
<CsScore>
f 1 0 1024 7 0 512 1 0 -1 512 0
f 2 0 1024 10 1
i 101 0 3600						; the delay runs for one hour
i 102 0 3600						; the reverb runs for one hour
e
</CsScore>
</CsoundSynthesizer>
; written by Alex Hofmann (Dec. 2009) - Incontri HMT-Hannover 
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>9469552</x>
 <y>0</y>
 <width>1</width>
 <height>145</height>
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
  <uuid>{a861f68d-e933-4321-8fb9-eee4eaa0bed0}</uuid>
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
